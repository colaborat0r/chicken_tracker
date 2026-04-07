import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/report_model.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/services/csv_export_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isExporting = false;
  String? _exportStatus;
  String _selectedReportType =
      'production'; // 'production', 'sales', 'expenses', 'purchases', 'losses'
  String _periodView = 'daily'; // daily, weekly, monthly

  @override
  void initState() {
    super.initState();
    _selectedEndDate = DateTime.now();
    _selectedStartDate = _selectedEndDate!.subtract(const Duration(days: 30));
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _selectedStartDate ??
            DateTime.now().subtract(const Duration(days: 30)),
        end: _selectedEndDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  void _setQuickRange(int days) {
    final end = DateTime.now();
    setState(() {
      _selectedEndDate = end;
      _selectedStartDate = end.subtract(Duration(days: days));
    });
  }

  Future<ProductionReport?> _generateReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final logs = await ref.read(allDailyLogsProvider.future);

    final filteredLogs = logs
        .where((log) =>
            log.date.isAfter(
                _selectedStartDate!.subtract(const Duration(days: 1))) &&
            log.date.isBefore(_selectedEndDate!.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final lineItems = filteredLogs
        .map((log) => ReportLineItem(
              date: log.date,
              totalEggs: log.totalEggs,
              brownEggs: log.eggsBrown,
              coloredEggs: log.eggsColored,
              whiteEggs: log.eggsWhite,
              layingHens: log.layingHens,
              eggsPerHen: log.eggsPerHen,
              productionPercentage: log.productionPercentage,
              notes: log.notes,
            ))
        .toList();

    return ProductionReport(
      reportType: _periodView == 'monthly'
          ? ReportType.monthly
          : _periodView == 'weekly'
              ? ReportType.weekly
              : ReportType.daily,
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      lineItems: lineItems,
      title: title,
    );
  }

  Future<SalesReport?> _generateSalesReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final sales = await ref.read(allSalesProvider.future);

    final filteredSales = sales
        .where((sale) =>
            sale.date.isAfter(
                _selectedStartDate!.subtract(const Duration(days: 1))) &&
            sale.date.isBefore(_selectedEndDate!.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final lineItems = filteredSales
        .map((sale) => SalesReportLineItem(
              date: sale.date,
              type: sale.type,
              quantity: sale.quantity,
              amount: sale.amount,
              unitPrice: sale.unitPrice,
              customerName: sale.customerName,
            ))
        .toList();

    return SalesReport(
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      lineItems: lineItems,
      title: title,
      totalRevenue: filteredSales.fold(0.0, (sum, sale) => sum + sale.amount),
      totalEggsSold: filteredSales
          .where((sale) => sale.type == 'eggs')
          .fold(0, (sum, sale) => sum + sale.quantity),
      totalChickensSold: filteredSales
          .where((sale) => sale.type == 'chickens')
          .fold(0, (sum, sale) => sum + sale.quantity),
    );
  }

  Future<ExpensesReport?> _generateExpensesReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final expenses = await ref.read(allExpensesProvider.future);

    final filteredExpenses = expenses
        .where((expense) =>
            expense.date.isAfter(
                _selectedStartDate!.subtract(const Duration(days: 1))) &&
            expense.date
                .isBefore(_selectedEndDate!.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final lineItems = filteredExpenses
        .map((expense) => ExpensesReportLineItem(
              date: expense.date,
              category: expense.category,
              amount: expense.amount,
              description: expense.description,
              pounds: expense.pounds,
              costPerPound: expense.costPerPound,
            ))
        .toList();

    // Group by category for summary
    final categoryTotals = <String, double>{};
    for (final expense in filteredExpenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return ExpensesReport(
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      lineItems: lineItems,
      title: title,
      totalExpenses:
          filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount),
      categoryBreakdown: categoryTotals,
    );
  }

  Future<FlockPurchasesReport?> _generateFlockPurchasesReport(
      String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final purchases = await ref.read(allFlockPurchasesProvider.future);

    final filteredPurchases = purchases
        .where((purchase) =>
            purchase.date.isAfter(
                _selectedStartDate!.subtract(const Duration(days: 1))) &&
            purchase.date
                .isBefore(_selectedEndDate!.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final lineItems = filteredPurchases
        .map((purchase) => FlockPurchasesReportLineItem(
              date: purchase.date,
              type: purchase.type,
              quantity: purchase.quantity,
              cost: purchase.cost,
              costPerUnit: purchase.costPerUnit,
              supplier: purchase.supplier,
              hatchedCount: purchase.hatchedCount,
              hatchRate: purchase.hatchRate,
            ))
        .toList();

    return FlockPurchasesReport(
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      lineItems: lineItems,
      title: title,
      totalCost:
          filteredPurchases.fold(0.0, (sum, purchase) => sum + purchase.cost),
      totalChicksPurchased: filteredPurchases
          .where((purchase) => purchase.type == 'live_chicks')
          .fold(0, (sum, purchase) => sum + purchase.quantity),
      totalEggsPurchased: filteredPurchases
          .where((purchase) => purchase.type == 'hatching_eggs')
          .fold(0, (sum, purchase) => sum + purchase.quantity),
    );
  }

  Future<FlockLossesReport?> _generateFlockLossesReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final losses = await ref.read(allFlockLossesProvider.future);

    final filteredLosses = losses
        .where((loss) =>
            loss.date.isAfter(
                _selectedStartDate!.subtract(const Duration(days: 1))) &&
            loss.date.isBefore(_selectedEndDate!.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final lineItems = filteredLosses
        .map((loss) => FlockLossesReportLineItem(
              date: loss.date,
              type: loss.type,
              quantity: loss.quantity,
              predatorSubtype: loss.predatorSubtype,
            ))
        .toList();

    // Group by type for summary
    final typeTotals = <String, int>{};
    for (final loss in filteredLosses) {
      typeTotals[loss.type] = (typeTotals[loss.type] ?? 0) + loss.quantity;
    }

    return FlockLossesReport(
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      lineItems: lineItems,
      title: title,
      totalLosses: filteredLosses.fold(0, (sum, loss) => sum + loss.quantity),
      lossesByType: typeTotals,
    );
  }

  Future<void> _exportPdf() async {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range')),
      );
      return;
    }

    setState(() {
      _isExporting = true;
      _exportStatus = 'Generating PDF...';
    });

    try {
      dynamic report;
      String reportTitle;

      switch (_selectedReportType) {
        case 'production':
          report = await _generateReport('Production Report');
          reportTitle = 'Production Report';
          break;
        case 'sales':
          report = await _generateSalesReport('Sales Report');
          reportTitle = 'Sales Report';
          break;
        case 'expenses':
          report = await _generateExpensesReport('Expenses Report');
          reportTitle = 'Expenses Report';
          break;
        case 'purchases':
          report =
              await _generateFlockPurchasesReport('Flock Purchases Report');
          reportTitle = 'Flock Purchases Report';
          break;
        case 'losses':
          report = await _generateFlockLossesReport('Flock Losses Report');
          reportTitle = 'Flock Losses Report';
          break;
        default:
          throw Exception('Unknown report type');
      }

      if (report == null) throw Exception('Failed to generate report');

      final file = await PdfExportService.generatePdf(report);

      setState(() => _exportStatus = 'Sharing...');

      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
            '$reportTitle - ${DateFormat('MMM d, yyyy').format(_selectedStartDate!)}',
      );

      setState(() => _exportStatus = 'PDF exported successfully!');
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      if (!mounted) return;
      setState(() => _exportStatus = 'Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting PDF: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportCsv() async {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range')),
      );
      return;
    }

    setState(() {
      _isExporting = true;
      _exportStatus = 'Generating CSV...';
    });

    try {
      dynamic report;
      String reportTitle;

      switch (_selectedReportType) {
        case 'production':
          report = await _generateReport('Production Report');
          reportTitle = 'Production Report';
          break;
        case 'sales':
          report = await _generateSalesReport('Sales Report');
          reportTitle = 'Sales Report';
          break;
        case 'expenses':
          report = await _generateExpensesReport('Expenses Report');
          reportTitle = 'Expenses Report';
          break;
        case 'purchases':
          report =
              await _generateFlockPurchasesReport('Flock Purchases Report');
          reportTitle = 'Flock Purchases Report';
          break;
        case 'losses':
          report = await _generateFlockLossesReport('Flock Losses Report');
          reportTitle = 'Flock Losses Report';
          break;
        default:
          throw Exception('Unknown report type');
      }

      if (report == null) throw Exception('Failed to generate report');

      final file = await CsvExportService.generateCsv(report);

      setState(() => _exportStatus = 'Sharing...');

      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
            '$reportTitle - ${DateFormat('MMM d, yyyy').format(_selectedStartDate!)}',
      );

      setState(() => _exportStatus = 'CSV exported successfully!');
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      if (!mounted) return;
      setState(() => _exportStatus = 'Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting CSV: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logsAsync = ref.watch(allDailyLogsProvider);
    final salesAsync = ref.watch(allSalesProvider);
    final expensesAsync = ref.watch(allExpensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Exports'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1A1823), Color(0xFF111015)]
                : const [Color(0xFFF4F0FF), Color(0xFFFCFAFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReportsHero(
                  reportType: _selectedReportType,
                  startDate: _selectedStartDate,
                  endDate: _selectedEndDate,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Insights View',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'daily',
                              icon: Icon(Icons.today),
                              label: Text('Daily'),
                            ),
                            ButtonSegment(
                              value: 'weekly',
                              icon: Icon(Icons.view_week),
                              label: Text('Weekly'),
                            ),
                            ButtonSegment(
                              value: 'monthly',
                              icon: Icon(Icons.calendar_month),
                              label: Text('Monthly'),
                            ),
                          ],
                          selected: {_periodView},
                          onSelectionChanged: (selection) {
                            setState(() {
                              _periodView = selection.first;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Performance Charts',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                logsAsync.when(
                  data: (logs) => _EggTrendChartCard(
                    logs: logs,
                    periodView: _periodView,
                    startDate: _selectedStartDate,
                    endDate: _selectedEndDate,
                  ),
                  loading: () => const AppSkeletonCard(lines: 5),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                if (salesAsync.hasValue && expensesAsync.hasValue)
                  _SalesVsExpensesChartCard(
                    sales: salesAsync.value!,
                    expenses: expensesAsync.value!,
                    startDate: _selectedStartDate,
                    endDate: _selectedEndDate,
                  )
                else
                  const AppSkeletonCard(lines: 5),
                const SizedBox(height: 16),
                const Text(
                  'Quick Range',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.today, size: 18),
                      label: const Text('7 Days'),
                      onPressed: _isExporting ? null : () => _setQuickRange(7),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.date_range, size: 18),
                      label: const Text('30 Days'),
                      onPressed: _isExporting ? null : () => _setQuickRange(30),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.calendar_month, size: 18),
                      label: const Text('90 Days'),
                      onPressed: _isExporting ? null : () => _setQuickRange(90),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date Range Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Report Period',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    _isExporting ? null : _selectDateRange,
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('Choose Dates'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_selectedStartDate != null &&
                            _selectedEndDate != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isDark ? Colors.grey[800] : Colors.grey[100],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selected Period:',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${DateFormat('MMM d, yyyy').format(_selectedStartDate!)} - ${DateFormat('MMM d, yyyy').format(_selectedEndDate!)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Report Type Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report Type',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedReportType,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'production',
                              child: Text('📊 Production Report'),
                            ),
                            DropdownMenuItem(
                              value: 'sales',
                              child: Text('💰 Sales Report'),
                            ),
                            DropdownMenuItem(
                              value: 'expenses',
                              child: Text('💸 Expenses Report'),
                            ),
                            DropdownMenuItem(
                              value: 'purchases',
                              child: Text('🛒 Flock Purchases Report'),
                            ),
                            DropdownMenuItem(
                              value: 'losses',
                              child: Text('⚠️ Flock Losses Report'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedReportType = value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Export Options Section
                Text(
                  'Export Options',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // PDF Export
                _ExportCard(
                  title: 'Export to PDF',
                  description: 'Professional report with tables and summary',
                  icon: Icons.picture_as_pdf,
                  color: Colors.red,
                  onPressed: _isExporting ? null : _exportPdf,
                  isLoading:
                      _isExporting && _exportStatus?.contains('PDF') == true,
                ),
                const SizedBox(height: 12),

                // CSV Export
                _ExportCard(
                  title: 'Export to CSV',
                  description: 'Spreadsheet format for data analysis',
                  icon: Icons.table_chart,
                  color: Colors.green,
                  onPressed: _isExporting ? null : _exportCsv,
                  isLoading:
                      _isExporting && _exportStatus?.contains('CSV') == true,
                ),
                const SizedBox(height: 20),

                // Status Message
                if (_exportStatus != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _exportStatus!.contains('Error')
                          ? Colors.red[100]
                          : Colors.green[100],
                    ),
                    child: Row(
                      children: [
                        if (_isExporting) ...[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                _exportStatus!.contains('Error')
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Text(
                            _exportStatus!,
                            style: TextStyle(
                              color: _exportStatus!.contains('Error')
                                  ? Colors.red[800]
                                  : Colors.green[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Info Section
                Card(
                  color: isDark ? Colors.blue[900] : Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.blue[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About Reports',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• PDF: Professional formatted report with summary statistics and daily details\n'
                          '• CSV: Spreadsheet format for use in Excel, Sheets, or data analysis tools\n'
                          '• Reports include egg counts by color, production percentages, and daily averages\n'
                          '• Use a custom date range to analyze specific time periods',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportsHero extends StatelessWidget {
  final String reportType;
  final DateTime? startDate;
  final DateTime? endDate;

  const _ReportsHero({
    required this.reportType,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final readableType = switch (reportType) {
      'production' => 'Production',
      'sales' => 'Sales',
      'expenses' => 'Expenses',
      'purchases' => 'Flock Purchases',
      'losses' => 'Flock Losses',
      _ => 'Report',
    };

    final periodText = (startDate != null && endDate != null)
        ? '${DateFormat('MMM d').format(startDate!)} - ${DateFormat('MMM d, yyyy').format(endDate!)}'
        : 'Select a period';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3DB8), Color(0xFF432B8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Export Plan',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            readableType,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            periodText,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _ExportCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.arrow_forward, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _EggTrendChartCard extends StatelessWidget {
  final List<dynamic> logs;
  final String periodView;
  final DateTime? startDate;
  final DateTime? endDate;

  const _EggTrendChartCard({
    required this.logs,
    required this.periodView,
    required this.startDate,
    required this.endDate,
  });

  List<MapEntry<String, int>> _aggregate() {
    final filtered = logs.where((log) {
      if (startDate == null || endDate == null) return true;
      return !log.date.isBefore(startDate!) && !log.date.isAfter(endDate!);
    }).toList();

    final grouped = <String, int>{};
    for (final log in filtered) {
      late String key;
      if (periodView == 'monthly') {
        key = DateFormat('MMM yy').format(log.date);
      } else if (periodView == 'weekly') {
        final start = log.date.subtract(Duration(days: log.date.weekday - 1));
        key = 'Wk ${DateFormat('M/d').format(start)}';
      } else {
        key = DateFormat('M/d').format(log.date);
      }
      grouped[key] = (grouped[key] ?? 0) + (log.totalEggs as int);
    }

    final entries = grouped.entries.toList();
    if (entries.length > 8) {
      return entries.sublist(entries.length - 8);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final data = _aggregate();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Egg Trend',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 180,
              child: data.isEmpty
                  ? const Center(child: Text('No production data in range'))
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (i < 0 || i >= data.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  data[i].key,
                                  style: Theme.of(context).textTheme.labelSmall,
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: data
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      e.value.value.toDouble(),
                                    ))
                                .toList(),
                            isCurved: true,
                            color: const Color(0xFFDAA520),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesVsExpensesChartCard extends StatelessWidget {
  final List<dynamic> sales;
  final List<dynamic> expenses;
  final DateTime? startDate;
  final DateTime? endDate;

  const _SalesVsExpensesChartCard({
    required this.sales,
    required this.expenses,
    required this.startDate,
    required this.endDate,
  });

  bool _inRange(DateTime date) {
    if (startDate == null || endDate == null) return true;
    return !date.isBefore(startDate!) && !date.isAfter(endDate!);
  }

  String _formatAmount(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}k';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredSales = sales.where((item) => _inRange(item.date)).toList();
    final filteredExpenses =
        expenses.where((item) => _inRange(item.date)).toList();

    final salesTotal =
        filteredSales.fold<double>(0.0, (sum, item) => sum + item.amount);
    final expensesTotal =
        filteredExpenses.fold<double>(0.0, (sum, item) => sum + item.amount);
    final rawMax = salesTotal > expensesTotal ? salesTotal : expensesTotal;
    final maxY = rawMax <= 0 ? 10.0 : rawMax * 1.25;
    final interval = maxY / 4;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense vs Sales',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) return const SizedBox.shrink();
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _formatAmount(value),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          String label;
                          if (value.toInt() == 0) {
                            label = 'Sales';
                          } else if (value.toInt() == 1) {
                            label = 'Expenses';
                          } else {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = group.x == 0 ? 'Sales' : 'Expenses';
                        return BarTooltipItem(
                          '$label\n${_formatAmount(rod.toY)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: salesTotal,
                          color: const Color(0xFF0E7A4F),
                          width: 36,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: expensesTotal,
                          color: const Color(0xFFC5392A),
                          width: 36,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ChartLegendDot(color: const Color(0xFF0E7A4F)),
                const SizedBox(width: 6),
                Text('Sales: ${_formatAmount(salesTotal)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(width: 20),
                _ChartLegendDot(color: const Color(0xFFC5392A)),
                const SizedBox(width: 6),
                Text('Expenses: ${_formatAmount(expensesTotal)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartLegendDot extends StatelessWidget {
  final Color color;
  const _ChartLegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
