import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/report_model.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../core/services/csv_export_service.dart';

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
  String _selectedReportType = 'production'; // 'production', 'sales', 'expenses', 'purchases', 'losses'

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
        start: _selectedStartDate ?? DateTime.now().subtract(const Duration(days: 30)),
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

  Future<ProductionReport?> _generateReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final logs = await ref.read(allDailyLogsProvider.future);

    final filteredLogs = logs
        .where((log) =>
            log.date.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
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
      reportType: ReportType.daily,
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
            sale.date.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
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
            expense.date.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
            expense.date.isBefore(_selectedEndDate!.add(const Duration(days: 1))))
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
      totalExpenses: filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount),
      categoryBreakdown: categoryTotals,
    );
  }

  Future<FlockPurchasesReport?> _generateFlockPurchasesReport(String title) async {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;

    final purchases = await ref.read(allFlockPurchasesProvider.future);

    final filteredPurchases = purchases
        .where((purchase) =>
            purchase.date.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
            purchase.date.isBefore(_selectedEndDate!.add(const Duration(days: 1))))
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
      totalCost: filteredPurchases.fold(0.0, (sum, purchase) => sum + purchase.cost),
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
            loss.date.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
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
          report = await _generateFlockPurchasesReport('Flock Purchases Report');
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
        subject: '$reportTitle - ${DateFormat('MMM d, yyyy').format(_selectedStartDate!)}',
      );

      setState(() => _exportStatus = 'PDF exported successfully!');
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
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
          report = await _generateFlockPurchasesReport('Flock Purchases Report');
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
        subject: '$reportTitle - ${DateFormat('MMM d, yyyy').format(_selectedStartDate!)}',
      );

      setState(() => _exportStatus = 'CSV exported successfully!');
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Reports & Exports'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Report Period',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isExporting ? null : _selectDateRange,
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Choose Dates'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedStartDate != null && _selectedEndDate != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
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
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedReportType,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                isLoading: _isExporting && _exportStatus?.contains('PDF') == true,
              ),
              const SizedBox(height: 12),

              // CSV Export
              _ExportCard(
                title: 'Export to CSV',
                description: 'Spreadsheet format for data analysis',
                icon: Icons.table_chart,
                color: Colors.green,
                onPressed: _isExporting ? null : _exportCsv,
                isLoading: _isExporting && _exportStatus?.contains('CSV') == true,
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
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                  color: color.withOpacity(0.2),
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
