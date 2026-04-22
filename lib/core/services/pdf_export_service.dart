import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';
import '../providers/report_settings_provider.dart';

/// Service for exporting reports to PDF format
class PdfExportService {
  /// Generate a PDF report and return the file
  static Future<File> generatePdf(dynamic report) async {
    final pdf = pw.Document();

    if (report is ProductionReport) {
      return _generateProductionPdf(pdf, report);
    } else if (report is SalesReport) {
      return _generateSalesPdf(pdf, report);
    } else if (report is ExpensesReport) {
      return _generateExpensesPdf(pdf, report);
    } else if (report is FlockPurchasesReport) {
      return _generateFlockPurchasesPdf(pdf, report);
    } else if (report is FlockLossesReport) {
      return _generateFlockLossesPdf(pdf, report);
    } else {
      throw UnsupportedError('Unsupported report type: ${report.runtimeType}');
    }
  }

  /// Generate production PDF
  static Future<File> _generateProductionPdf(pw.Document pdf, ProductionReport report) async {
    final summary = report.summary;

    // Create the PDF with multiple pages if needed
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Text('Production Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
          pw.SizedBox(height: 10),
          pw.Text('Period: ${report.dateRangeDisplay}'),
          pw.SizedBox(height: 20),

          // Summary section
          pw.Text('Summary Statistics', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Text('Total Eggs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(summary.totalEggs.toString()),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Brown Eggs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${summary.totalBrownEggs} (${summary.brownPercentage.toStringAsFixed(1)}%)'),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Colored Eggs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${summary.totalColoredEggs} (${summary.coloredPercentage.toStringAsFixed(1)}%)'),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('White Eggs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${summary.totalWhiteEggs} (${summary.whitePercentage.toStringAsFixed(1)}%)'),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Average Eggs/Day', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(summary.averageEggsPerDay.toStringAsFixed(2)),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Average Eggs/Hen', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(summary.averageEggsPerHen.toStringAsFixed(2)),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Average Production %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${summary.averageProductionPercentage.toStringAsFixed(1)}%'),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              pw.TableRow(
                children: [
                  pw.Text('Days with Data', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(summary.daysWithData.toString()),
                ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
              ),
              if (summary.peakEggsDay != null)
                pw.TableRow(
                  children: [
                    pw.Text('Peak Day', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${summary.peakEggsDay!.formattedDate} (${summary.peakEggsDay!.totalEggs} eggs)'),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
              if (summary.lowestEggsDay != null)
                pw.TableRow(
                  children: [
                    pw.Text('Lowest Day', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('${summary.lowestEggsDay!.formattedDate} (${summary.lowestEggsDay!.totalEggs} eggs)'),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
            ],
          ),
          pw.SizedBox(height: 20),

          // Daily details section
          if (report.lineItems.isNotEmpty) ...[
            pw.Text('Daily Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Day', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Total Eggs', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Brown', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Colored', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('White', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Laying Hens', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Eggs/Hen', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Production %', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: text)).toList(),
                ),
                ...report.lineItems.map((item) {
                  final dayOfWeek = DateFormat('EEEE').format(item.date);
                  return pw.TableRow(
                    children: [
                      pw.Text(item.formattedDate),
                      pw.Text(dayOfWeek),
                      pw.Text(item.totalEggs.toString()),
                      pw.Text(item.brownEggs.toString()),
                      pw.Text(item.coloredEggs.toString()),
                      pw.Text(item.whiteEggs.toString()),
                      pw.Text(item.layingHens.toString()),
                      pw.Text(item.eggsPerHen.toStringAsFixed(2)),
                      pw.Text('${item.productionPercentage.toStringAsFixed(1)}%'),
                      pw.Text(item.notes ?? ''),
                    ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: text)).toList(),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Production_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate sales PDF
  static Future<File> _generateSalesPdf(pw.Document pdf, SalesReport report) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Sales Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 10),
            pw.Text('Period: ${report.dateRangeDisplay}'),
            pw.SizedBox(height: 20),
            pw.Text('Total Revenue: \$${report.totalRevenue.toStringAsFixed(2)}'),
            pw.Text('Eggs Sold: ${report.totalEggsSold}'),
            pw.Text('Chickens Sold: ${report.totalChickensSold}'),
            pw.SizedBox(height: 20),
            pw.Text('Sales Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.lineItems.map((item) => pw.TableRow(
                  children: [
                    pw.Text(item.formattedDate),
                    pw.Text(item.type),
                    pw.Text(item.quantity.toString()),
                    pw.Text('\$${item.amount.toStringAsFixed(2)}'),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Sales_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate expenses PDF
  static Future<File> _generateExpensesPdf(pw.Document pdf, ExpensesReport report) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Expenses Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 10),
            pw.Text('Period: ${report.dateRangeDisplay}'),
            pw.SizedBox(height: 20),
            pw.Text('Total Expenses: \$${report.totalExpenses.toStringAsFixed(2)}'),
            pw.SizedBox(height: 20),
            pw.Text('Expenses by Category:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.categoryBreakdown.entries.map((entry) => pw.TableRow(
                  children: [
                    pw.Text(entry.key),
                    pw.Text('\$${entry.value.toStringAsFixed(2)}'),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Expense Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.lineItems.map((item) => pw.TableRow(
                  children: [
                    pw.Text(item.formattedDate),
                    pw.Text(item.category),
                    pw.Text('\$${item.amount.toStringAsFixed(2)}'),
                    pw.Text(item.description ?? ''),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Expenses_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate flock purchases PDF
  static Future<File> _generateFlockPurchasesPdf(pw.Document pdf, FlockPurchasesReport report) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Flock Purchases Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 10),
            pw.Text('Period: ${report.dateRangeDisplay}'),
            pw.SizedBox(height: 20),
            pw.Text('Total Cost: \$${report.totalCost.toStringAsFixed(2)}'),
            pw.Text('Chicks Purchased: ${report.totalChicksPurchased}'),
            pw.Text('Eggs Purchased: ${report.totalEggsPurchased}'),
            pw.SizedBox(height: 20),
            pw.Text('Purchase Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Cost per Unit', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Total Cost', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Supplier', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Hatch Rate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.lineItems.map((item) => pw.TableRow(
                  children: [
                    pw.Text(item.formattedDate),
                    pw.Text(item.type),
                    pw.Text(item.quantity.toString()),
                    pw.Text('\$${item.costPerUnit.toStringAsFixed(2)}'),
                    pw.Text('\$${item.cost.toStringAsFixed(2)}'),
                    pw.Text(item.supplier ?? ''),
                    pw.Text(item.hatchRate != null ? '${item.hatchRate!.toStringAsFixed(1)}%' : ''),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Flock_Purchases_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate flock losses PDF
  static Future<File> _generateFlockLossesPdf(pw.Document pdf, FlockLossesReport report) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Flock Losses Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 10),
            pw.Text('Period: ${report.dateRangeDisplay}'),
            pw.SizedBox(height: 20),
            pw.Text('Total Losses: ${report.totalLosses}'),
            pw.SizedBox(height: 20),
            pw.Text('Losses by Type:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Count', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.lossesByType.entries.map((entry) => pw.TableRow(
                  children: [
                    pw.Text(entry.key),
                    pw.Text(entry.value.toString()),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Loss Details:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Quantity', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                ),
                ...report.lineItems.map((item) => pw.TableRow(
                  children: [
                    pw.Text(item.formattedDate),
                    pw.Text(item.type),
                    pw.Text(item.quantity.toString()),
                    pw.Text(item.predatorSubtype ?? ''),
                  ].map((text) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: text)).toList(),
                )),
              ],
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Flock_Losses_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate a beautiful one-page Farm Report Card PDF
  static Future<File> generateFarmReportCard(FarmReportData data) =>
      _generateFarmReportCardImpl(data);

  /// Internal implementation of farm report generation
  static Future<File> _generateFarmReportCardImpl(FarmReportData data) async {
    final pdf = pw.Document();

    const headerBg = PdfColor.fromInt(0xFF6D451E);
    const accentBrown = PdfColor.fromInt(0xFF8A5A2B);
    const lightBg = PdfColor.fromInt(0xFFFFF8F0);
    const mutedText = PdfColor.fromInt(0xFF888888);
    const positiveGreen = PdfColor.fromInt(0xFF2E7D32);
    const negativeRed = PdfColor.fromInt(0xFFC5392A);
    const barColor = PdfColor.fromInt(0xFF8A5A2B);

    final profitColor = data.profitLoss >= 0 ? positiveGreen : negativeRed;
    final profitLabel = data.profitLoss >= 0
        ? '+\$${data.profitLoss.toStringAsFixed(2)}'
        : '-\$${data.profitLoss.abs().toStringAsFixed(2)}';

    final chartHeight = 80.0;
    final chartWidth = 480.0;
    final maxEggs = data.dailyEggs.isEmpty
        ? 1
        : data.dailyEggs.map((e) => e.eggs).reduce((a, b) => a > b ? a : b);
    final barWidth = data.dailyEggs.isEmpty
        ? 10.0
        : (chartWidth / data.dailyEggs.length).clamp(3.0, 20.0);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Header
            pw.Container(
              color: headerBg,
              padding: const pw.EdgeInsets.fromLTRB(32, 22, 32, 18),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        data.farmName,
                        style: pw.TextStyle(
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Monthly Farm Report',
                        style: pw.TextStyle(
                          fontSize: 13,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        data.monthLabel,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Generated ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats Grid
            pw.Container(
              color: lightBg,
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Monthly Snapshot',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: accentBrown,
                    ),
                   ),
                   pw.SizedBox(height: 14),
                   _buildStatsGridWithSettings(data, accentBrown, profitLabel, profitColor),
                 ],
               ),
             ),

            // Chart
            pw.Container(
              color: PdfColors.white,
              padding: const pw.EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Daily Production — ${data.monthLabel}',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: accentBrown,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  if (data.dailyEggs.isEmpty)
                    pw.Text(
                      'No production data recorded.',
                      style: pw.TextStyle(color: mutedText),
                    )
                  else
                    pw.SizedBox(
                      width: chartWidth,
                      height: chartHeight + 20,
                      child: pw.Stack(
                        children: [
                          pw.Positioned(
                            bottom: 18,
                            left: 0,
                            right: 0,
                            child: pw.Container(height: 1, color: mutedText),
                          ),
                          pw.Positioned(
                            bottom: 19,
                            left: 0,
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: data.dailyEggs.map((entry) {
                                final h = maxEggs > 0
                                    ? (entry.eggs / maxEggs) * chartHeight
                                    : 0.0;
                                return pw.Padding(
                                  padding: pw.EdgeInsets.only(
                                      right: barWidth > 5 ? 2 : 1),
                                  child: pw.Container(
                                    width: barWidth - (barWidth > 5 ? 2 : 1),
                                    height: h.clamp(1.0, chartHeight),
                                    color: barColor,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Footer spacer
            pw.Expanded(child: pw.Container(color: PdfColors.white)),

            // Footer
            pw.Container(
              color: const PdfColor.fromInt(0xFFF5EDE0),
              padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    '🐓 Generated by Chicken Tracker',
                    style: pw.TextStyle(fontSize: 9, color: mutedText),
                  ),
                  pw.Text(
                    data.farmName,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: accentBrown,
                    ),
                  ),
                ],
              ),
             ),
           ],
         ),
       ),
     );

    // Photos page — only added if the user included photos
    if (data.photos.isNotEmpty) {
      final photoWidgets = <pw.Widget>[];
      for (final photo in data.photos) {
        Uint8List? bytes;
        try {
          bytes = await File(photo.filePath).readAsBytes();
        } catch (_) {
          continue;
        }
        final img = pw.MemoryImage(bytes);
        photoWidgets.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.ClipRRect(
                horizontalRadius: 6,
                verticalRadius: 6,
                child: pw.Image(img, height: 160, fit: pw.BoxFit.cover),
              ),
              if (photo.caption.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4),
                  child: pw.Text(
                    photo.caption,
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: const PdfColor.fromInt(0xFF555555),
                    ),
                  ),
                ),
            ],
          ),
        );
      }

      if (photoWidgets.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '📸 Farm Photos — ${data.monthLabel}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: const PdfColor.fromInt(0xFF6D451E),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: photoWidgets
                      .map((w) => pw.SizedBox(width: 240, child: w))
                      .toList(),
                ),
                pw.Expanded(child: pw.SizedBox()),
                pw.Divider(color: const PdfColor.fromInt(0xFFE0D0C0)),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('🐓 Generated by Chicken Tracker',
                        style: pw.TextStyle(
                            fontSize: 9,
                            color: const PdfColor.fromInt(0xFF888888))),
                    pw.Text(data.farmName,
                        style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: const PdfColor.fromInt(0xFF8A5A2B))),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'FarmReport_${data.monthLabel.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Builds stats grid dynamically based on enabled metrics
  static pw.Widget _buildStatsGridWithSettings(
    FarmReportData data,
    PdfColor accentBrown,
    String profitLabel,
    PdfColor profitColor,
  ) {
    final stats = <({String label, String value, String sub, PdfColor? color})>[];

    if (data.settings.totalEggs) {
      stats.add((label: '🥚 Eggs', value: '${data.totalEggs}', sub: 'collected', color: null));
    }
    if (data.settings.totalSales) {
      stats.add((label: '💰 Sales', value: '\$${data.totalSales.toStringAsFixed(2)}', sub: 'revenue', color: null));
    }
    if (data.settings.totalExpenses) {
      stats.add((label: '💸 Expenses', value: '\$${data.totalExpenses.toStringAsFixed(2)}', sub: 'spent', color: null));
    }
    if (data.settings.profitLoss) {
      stats.add((label: '📊 Profit', value: profitLabel, sub: 'net', color: profitColor));
    }
    if (data.settings.flockCount) {
      stats.add((label: '🐔 Flock', value: '${data.flockCount}', sub: 'birds', color: null));
    }
    if (data.settings.layingCount) {
      stats.add((label: '🥚 Layers', value: '${data.layingCount}', sub: 'laying', color: null));
    }
    if (data.settings.feedPerEgg) {
      stats.add((label: '🌾 Feed/Egg', value: '\$${data.feedPerEgg.toStringAsFixed(3)}', sub: 'per egg', color: null));
    }
    if (data.settings.layingPercentage) {
      final layPercent = data.flockCount > 0
          ? '${((data.layingCount / data.flockCount) * 100).toStringAsFixed(0)}%'
          : '—';
      stats.add((label: '📈 Lay %', value: layPercent, sub: 'active', color: null));
    }

    if (stats.isEmpty) {
      return pw.Text('No metrics selected for display');
    }

    // Split stats into groups of 4 for layout
    final rows = <pw.Widget>[];
    for (var i = 0; i < stats.length; i += 4) {
      final rowStats = stats.skip(i).take(4).toList();
      final rowChildren = <pw.Widget>[];

      for (var j = 0; j < rowStats.length; j++) {
        if (j > 0) {
          rowChildren.add(pw.SizedBox(width: 12));
        }

        final stat = rowStats[j];
        if (stat.color != null) {
          rowChildren.add(_reportStatBoxColored(stat.label, stat.value, stat.sub, stat.color!));
        } else {
          rowChildren.add(_reportStatBox(stat.label, stat.value, stat.sub));
        }
      }

      rows.add(pw.Row(children: rowChildren));
      if (i + 4 < stats.length) {
        rows.add(pw.SizedBox(height: 12));
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: rows,
    );
  }

  static pw.Widget _reportStatBox(String label, String value, String sub) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: const PdfColor.fromInt(0xFFE0D0C0)),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label,
                style: pw.TextStyle(fontSize: 9, color: const PdfColor.fromInt(0xFF888888))),
            pw.SizedBox(height: 4),
            pw.Text(value,
                style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 2),
            pw.Text(sub, style: pw.TextStyle(fontSize: 8, color: const PdfColor.fromInt(0xFFAAAAAA))),
          ],
        ),
      ),
    );
  }

  static pw.Widget _reportStatBoxColored(
      String label, String value, String sub, PdfColor valueColor) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: const PdfColor.fromInt(0xFFE0D0C0)),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 9, color: const PdfColor.fromInt(0xFF888888))),
            pw.SizedBox(height: 4),
            pw.Text(value,
                style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold, color: valueColor)),
            pw.SizedBox(height: 2),
            pw.Text(sub, style: pw.TextStyle(fontSize: 8, color: const PdfColor.fromInt(0xFFAAAAAA))),
          ],
        ),
      ),
    );
  }

}

// ─────────────────────────────────────────────────────────────────────────────
// Farm Report Card - Models & Export
// ─────────────────────────────────────────────────────────────────────────────

class FarmReportData {
  final String farmName;
  final String monthLabel;
  final int totalEggs;
  final double totalSales;
  final double totalExpenses;
  final double profitLoss;
  final int flockCount;
  final int layingCount;
  final double feedPerEgg;
  final List<DailyEggEntry> dailyEggs;
  final ReportSettings settings;
  final List<FarmReportPhoto> photos;

  FarmReportData({
    required this.farmName,
    required this.monthLabel,
    required this.totalEggs,
    required this.totalSales,
    required this.totalExpenses,
    required this.profitLoss,
    required this.flockCount,
    required this.layingCount,
    required this.feedPerEgg,
    required this.dailyEggs,
    required this.settings,
    this.photos = const [],
  });
}

class DailyEggEntry {
  final int day;
  final int eggs;
  DailyEggEntry({required this.day, required this.eggs});
}

class FarmReportPhoto {
  final String filePath;
  final String caption;
  FarmReportPhoto({required this.filePath, required this.caption});
}

