import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
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

    // Load header image
    final headerImageBytes = await rootBundle.load('assets/farmreportheader.jpg');
    final headerImage = pw.MemoryImage(headerImageBytes.buffer.asUint8List());

    const accentBrown = PdfColor.fromInt(0xFF8B5A2B);
    const lightBg = PdfColor.fromInt(0xFFFFF8F0);
    const mutedText = PdfColor.fromInt(0xFF888888);
    const positiveGreen = PdfColor.fromInt(0xFF2E7D32);
    const negativeRed = PdfColor.fromInt(0xFFC5392A);
    const barColor = PdfColor.fromInt(0xFF7A9B8E);
    const cardBg = PdfColor.fromInt(0xFFFCFAF7);

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
            // Header with image banner
            pw.Stack(
              children: [
                pw.Image(headerImage, height: 130, fit: pw.BoxFit.cover),
                pw.Padding(
                  padding: const pw.EdgeInsets.fromLTRB(32, 68, 32, 10),
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
              ],
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
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: accentBrown,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  _buildRedesignedStatsGrid(data, accentBrown, profitLabel, profitColor, cardBg),
                 ],
               ),
             ),

            // ─────────────────────────────────────────────────────────────────────────────
            // DAILY PRODUCTION CHART
            // ─────────────────────────────────────────────────────────────────────────────
            pw.Container(
              color: PdfColors.white,
              padding: const pw.EdgeInsets.fromLTRB(32, 20, 32, 16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Daily Production ${data.monthLabel}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: accentBrown,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (data.dailyEggs.isEmpty)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          'No production data recorded.',
                          style: pw.TextStyle(fontSize: 11, color: mutedText),
                        ),
                      ],
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
                            child: pw.Container(height: 1, color: const PdfColor.fromInt(0xFFE0E0E0)),
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
                  pw.SizedBox(height: 10),
                ],
              ),
            ),

            // Footer spacer
            pw.Expanded(child: pw.Container(color: PdfColors.white)),

            // ─────────────────────────────────────────────────────────────────────────────
            // FOOTER
            // ─────────────────────────────────────────────────────────────────────────────
            pw.Container(
              color: const PdfColor.fromInt(0xFFF5EDE0),
              padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated by Chicken Tracker',
                    style: pw.TextStyle(fontSize: 9, color: mutedText),
                  ),
                  pw.Text('🐓', style: const pw.TextStyle(fontSize: 12)),
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

  /// Builds redesigned stats grid with new layout: 4 cards on top, 1 centered below
  static pw.Widget _buildRedesignedStatsGrid(
    FarmReportData data,
    PdfColor accentBrown,
    String profitLabel,
    PdfColor profitColor,
    PdfColor cardBg,
  ) {
    final stats = <({String icon, String value, String label, String sub, PdfColor? color})>[];

    if (data.settings.totalEggs) {
      stats.add((icon: 'eggs', value: '${data.totalEggs}', label: 'Eggs collected', sub: '', color: null));
    }
    if (data.settings.flockCount) {
      stats.add((icon: 'flock', value: '${data.flockCount}', label: 'Flock birds', sub: '', color: null));
    }
    if (data.settings.layingCount) {
      stats.add((icon: 'laying', value: '${data.layingCount}', label: 'Layers laying', sub: '', color: null));
    }
    if (data.settings.feedPerEgg) {
      stats.add((icon: 'feed', value: '\$${data.feedPerEgg.toStringAsFixed(2)}', label: 'Feed/Egg', sub: '', color: null));
    }
    if (data.settings.layingPercentage) {
      final layPercent = data.flockCount > 0
          ? '${((data.layingCount / data.flockCount) * 100).toStringAsFixed(0)}%'
          : '0%';
      stats.add((icon: 'percent', value: layPercent, label: 'Lay % active', sub: '', color: null));
    }
    if (data.settings.totalSales) {
      stats.add((icon: 'sales', value: '\$${data.totalSales.toStringAsFixed(2)}', label: 'Total Sales', sub: '', color: null));
    }
    if (data.settings.totalExpenses) {
      stats.add((icon: 'expenses', value: '\$${data.totalExpenses.toStringAsFixed(2)}', label: 'Total Expenses', sub: '', color: null));
    }
    if (data.settings.profitLoss) {
      stats.add((icon: 'profit', value: profitLabel, label: 'Profit/Loss', sub: '', color: profitColor));
    }

    if (stats.isEmpty) {
      return pw.Text('No metrics selected for display');
    }

    // Layout: First 4 in a row, rest centered below
    final List<pw.Widget> rows = [];

    // Top 4 cards
    final topCards = stats.take(4).toList();
    final topCardWidgets = <pw.Widget>[];
    for (int i = 0; i < topCards.length; i++) {
      if (i > 0) topCardWidgets.add(pw.SizedBox(width: 10));
      topCardWidgets.add(_buildRedesignedStatCard(topCards[i], cardBg));
    }
    rows.add(pw.Row(children: topCardWidgets));

    // Remaining cards centered
    if (stats.length > 4) {
      rows.add(pw.SizedBox(height: 12));
      final bottomCards = stats.skip(4).toList();
      final bottomCardWidgets = <pw.Widget>[];
      for (int i = 0; i < bottomCards.length; i++) {
        if (i > 0) bottomCardWidgets.add(pw.SizedBox(width: 10));
        if (i == 0) bottomCardWidgets.add(pw.Expanded(child: pw.SizedBox()));
        bottomCardWidgets.add(_buildRedesignedStatCard(bottomCards[i], cardBg));
        if (i == bottomCards.length - 1) bottomCardWidgets.add(pw.Expanded(child: pw.SizedBox()));
      }
      rows.add(pw.Row(children: bottomCardWidgets));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: rows,
    );
  }

  /// Returns a vector-drawn icon widget for a given stat type
  static pw.Widget _buildStatIcon(String type, {PdfColor? color}) {
    return pw.CustomPaint(
      size: const PdfPoint(40, 40),
      painter: (canvas, size) {
        switch (type) {
          case 'eggs':
            _drawEggsIcon(canvas);
            break;
          case 'flock':
            _drawFlockIcon(canvas);
            break;
          case 'laying':
            _drawLayingIcon(canvas);
            break;
          case 'feed':
            _drawFeedIcon(canvas);
            break;
          case 'percent':
            _drawPercentIcon(canvas);
            break;
          case 'sales':
            _drawSalesIcon(canvas);
            break;
          case 'expenses':
            _drawExpensesIcon(canvas);
            break;
          case 'profit':
            _drawProfitIcon(canvas, color ?? const PdfColor.fromInt(0xFF2E7D32));
            break;
          default:
            _drawDefaultIcon(canvas);
        }
      },
    );
  }

  // ─── Icon Painters ────────────────────────────────────────────────────────

  /// Egg basket icon (40×40, PDF y=0 at bottom)
  static void _drawEggsIcon(PdfGraphics canvas) {
    // Basket body (trapezoid)
    canvas.setFillColor(const PdfColor.fromInt(0xFFB8882A));
    canvas.moveTo(5, 4);
    canvas.lineTo(35, 4);
    canvas.lineTo(32, 16);
    canvas.lineTo(8, 16);
    canvas.closePath();
    canvas.fillPath();
    // Basket weave lines
    canvas.setStrokeColor(const PdfColor.fromInt(0xFF8B6010));
    canvas.setLineWidth(0.8);
    canvas.drawLine(5, 9, 35, 9);
    canvas.drawLine(6, 14, 34, 14);
    // Basket handle arc
    canvas.setStrokeColor(const PdfColor.fromInt(0xFF8B6010));
    canvas.setLineWidth(2.5);
    canvas.moveTo(8, 16);
    canvas.curveTo(8, 34, 20, 36, 32, 16);
    canvas.strokePath();
    // Three eggs
    canvas.setFillColor(PdfColors.white);
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFD4C090));
    canvas.setLineWidth(0.5);
    canvas.drawEllipse(13, 23, 5, 6);
    canvas.fillAndStrokePath();
    canvas.drawEllipse(20, 25, 5, 6);
    canvas.fillAndStrokePath();
    canvas.drawEllipse(27, 23, 5, 6);
    canvas.fillAndStrokePath();
  }

  /// Chicken/flock icon (40×40)
  static void _drawFlockIcon(PdfGraphics canvas) {
    // Body (white oval)
    canvas.setFillColor(PdfColors.white);
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFCCCCCC));
    canvas.setLineWidth(0.5);
    canvas.drawEllipse(17, 17, 12, 9);
    canvas.fillAndStrokePath();
    // Head
    canvas.drawEllipse(29, 25, 7, 7);
    canvas.fillAndStrokePath();
    // Comb (red bumps)
    canvas.setFillColor(const PdfColor.fromInt(0xFFCC0000));
    canvas.drawEllipse(28, 32, 3, 3);
    canvas.fillPath();
    canvas.drawEllipse(33, 33, 2.5, 2.5);
    canvas.fillPath();
    // Beak (orange triangle)
    canvas.setFillColor(const PdfColor.fromInt(0xFFF5A020));
    canvas.moveTo(35, 25);
    canvas.lineTo(40, 23);
    canvas.lineTo(35, 21);
    canvas.closePath();
    canvas.fillPath();
    // Eye
    canvas.setFillColor(const PdfColor.fromInt(0xFF222222));
    canvas.drawEllipse(31, 26, 1.2, 1.2);
    canvas.fillPath();
    // Wing feather line
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFAAAAAA));
    canvas.setLineWidth(1.2);
    canvas.moveTo(10, 19);
    canvas.curveTo(9, 23, 14, 25, 18, 20);
    canvas.strokePath();
    // Legs
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFF5A020));
    canvas.setLineWidth(1.5);
    canvas.moveTo(15, 8);
    canvas.lineTo(13, 2);
    canvas.strokePath();
    canvas.moveTo(13, 2);
    canvas.lineTo(10, 0);
    canvas.strokePath();
    canvas.moveTo(13, 2);
    canvas.lineTo(15, 0);
    canvas.strokePath();
    canvas.moveTo(20, 8);
    canvas.lineTo(20, 2);
    canvas.strokePath();
    canvas.moveTo(20, 2);
    canvas.lineTo(17, 0);
    canvas.strokePath();
    canvas.moveTo(20, 2);
    canvas.lineTo(22, 0);
    canvas.strokePath();
  }

  /// Laying hen on nest icon (40×40)
  static void _drawLayingIcon(PdfGraphics canvas) {
    // Nest (dark brown oval at bottom)
    canvas.setFillColor(const PdfColor.fromInt(0xFF6B4510));
    canvas.drawEllipse(20, 7, 16, 7);
    canvas.fillPath();
    // Egg in nest
    canvas.setFillColor(PdfColors.white);
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFD4C090));
    canvas.setLineWidth(0.5);
    canvas.drawEllipse(20, 10, 6, 8);
    canvas.fillAndStrokePath();
    // Hen body (orange-brown)
    canvas.setFillColor(const PdfColor.fromInt(0xFFCC8800));
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFAA6600));
    canvas.setLineWidth(0.5);
    canvas.drawEllipse(17, 20, 12, 9);
    canvas.fillAndStrokePath();
    // Head
    canvas.drawEllipse(28, 26, 7, 7);
    canvas.fillAndStrokePath();
    // Comb
    canvas.setFillColor(const PdfColor.fromInt(0xFFCC0000));
    canvas.drawEllipse(28, 33, 3, 3);
    canvas.fillPath();
    // Beak
    canvas.setFillColor(const PdfColor.fromInt(0xFFFF8800));
    canvas.moveTo(34, 26);
    canvas.lineTo(39, 24);
    canvas.lineTo(34, 22);
    canvas.closePath();
    canvas.fillPath();
    // Wing
    canvas.setFillColor(const PdfColor.fromInt(0xFFAA7000));
    canvas.drawEllipse(12, 21, 7, 5);
    canvas.fillPath();
  }

  /// Money bag / feed cost icon (40×40)
  static void _drawFeedIcon(PdfGraphics canvas) {
    // Bag body
    canvas.setFillColor(const PdfColor.fromInt(0xFF9B7B3A));
    canvas.drawEllipse(20, 18, 13, 14);
    canvas.fillPath();
    // Bag neck
    canvas.drawRect(15, 6, 10, 8);
    canvas.fillPath();
    // Tie/knot (darker)
    canvas.setFillColor(const PdfColor.fromInt(0xFF6B4E1A));
    canvas.drawRect(14, 5, 12, 3);
    canvas.fillPath();
    // Dollar sign — vertical stem
    canvas.setStrokeColor(PdfColors.white);
    canvas.setLineWidth(2);
    canvas.drawLine(20, 9, 20, 29);
    // S-curve top
    canvas.setLineWidth(1.5);
    canvas.moveTo(24, 26);
    canvas.curveTo(24, 30, 16, 30, 16, 26);
    canvas.strokePath();
    // S-curve bottom
    canvas.moveTo(16, 26);
    canvas.curveTo(16, 22, 24, 22, 24, 18);
    canvas.strokePath();
  }

  /// Percentage / donut chart icon (40×40)
  static void _drawPercentIcon(PdfGraphics canvas) {
    const brown = PdfColor.fromInt(0xFF8B5A2B);
    const bgColor = PdfColor.fromInt(0xFFFFF8F0);
    // Outer filled ring
    canvas.setFillColor(brown);
    canvas.drawEllipse(20, 20, 16, 16);
    canvas.fillPath();
    // Inner white hole
    canvas.setFillColor(bgColor);
    canvas.drawEllipse(20, 20, 9, 9);
    canvas.fillPath();
    // % symbol: top-left small circle
    canvas.setFillColor(brown);
    canvas.drawEllipse(14, 26, 3.5, 3.5);
    canvas.fillPath();
    // % symbol: bottom-right small circle
    canvas.drawEllipse(26, 14, 3.5, 3.5);
    canvas.fillPath();
    // % diagonal slash
    canvas.setStrokeColor(brown);
    canvas.setLineWidth(2.2);
    canvas.drawLine(11, 12, 29, 28);
  }

  /// Stacked coins / sales icon (40×40)
  static void _drawSalesIcon(PdfGraphics canvas) {
    const gold = PdfColor.fromInt(0xFFD4A820);
    const darkGold = PdfColor.fromInt(0xFF9B7810);
    // Draw 3 stacked coins (bottom to top)
    for (int i = 0; i < 3; i++) {
      final baseY = 4.0 + i * 9.0;
      // Coin edge
      canvas.setFillColor(darkGold);
      canvas.drawRect(7, baseY, 26, 5);
      canvas.fillPath();
      // Coin top face
      canvas.setFillColor(gold);
      canvas.drawEllipse(20, baseY + 5, 13, 5);
      canvas.fillPath();
    }
    // Dollar sign on top coin
    canvas.setStrokeColor(PdfColors.white);
    canvas.setLineWidth(1.5);
    canvas.drawLine(20, 25, 20, 35);
    canvas.moveTo(24, 33);
    canvas.curveTo(24, 37, 16, 37, 16, 33);
    canvas.strokePath();
    canvas.moveTo(16, 33);
    canvas.curveTo(16, 29, 24, 29, 24, 25);
    canvas.strokePath();
  }

  /// Receipt / expenses icon (40×40)
  static void _drawExpensesIcon(PdfGraphics canvas) {
    // Receipt paper
    canvas.setFillColor(PdfColors.white);
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFCCCCCC));
    canvas.setLineWidth(1);
    canvas.drawRect(7, 4, 26, 32);
    canvas.fillAndStrokePath();
    // Lines on receipt
    canvas.setStrokeColor(const PdfColor.fromInt(0xFFAAAAAA));
    canvas.setLineWidth(1.5);
    for (double ly = 10.0; ly <= 26; ly += 6) {
      canvas.drawLine(12, ly, 30, ly);
    }
    // Red circle with minus (expense indicator)
    canvas.setFillColor(const PdfColor.fromInt(0xFFC5392A));
    canvas.drawEllipse(30, 32, 8, 8);
    canvas.fillPath();
    canvas.setStrokeColor(PdfColors.white);
    canvas.setLineWidth(2);
    canvas.drawLine(25, 32, 35, 32);
  }

  /// Bar chart with trend arrow for profit/loss (40×40)
  static void _drawProfitIcon(PdfGraphics canvas, PdfColor arrowColor) {
    const barBase = PdfColor.fromInt(0xFFDDD0B8);
    // Three bars of increasing height
    canvas.setFillColor(barBase);
    canvas.drawRect(4, 4, 8, 12);
    canvas.fillPath();
    canvas.drawRect(16, 4, 8, 18);
    canvas.fillPath();
    canvas.drawRect(28, 4, 8, 26);
    canvas.fillPath();
    // Colored top caps
    canvas.setFillColor(arrowColor);
    canvas.drawRect(4, 16, 8, 4);
    canvas.fillPath();
    canvas.drawRect(16, 22, 8, 4);
    canvas.fillPath();
    canvas.drawRect(28, 30, 8, 4);
    canvas.fillPath();
    // Trend line
    canvas.setStrokeColor(arrowColor);
    canvas.setLineWidth(2);
    canvas.moveTo(8, 18);
    canvas.lineTo(20, 24);
    canvas.lineTo(32, 32);
    canvas.strokePath();
    // Arrow head
    canvas.setFillColor(arrowColor);
    canvas.moveTo(36, 36);
    canvas.lineTo(28, 32);
    canvas.lineTo(32, 26);
    canvas.closePath();
    canvas.fillPath();
  }

  /// Fallback icon — simple farm silhouette (40×40)
  static void _drawDefaultIcon(PdfGraphics canvas) {
    canvas.setFillColor(const PdfColor.fromInt(0xFF8B5A2B));
    canvas.drawEllipse(20, 20, 14, 14);
    canvas.fillPath();
  }


  /// Builds a redesigned stat card matching the image design
  static pw.Widget _buildRedesignedStatCard(
    ({String icon, String value, String label, String sub, PdfColor? color}) stat,
    PdfColor cardBg,
  ) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: cardBg,
        border: pw.Border.all(color: const PdfColor.fromInt(0xFFE8DCC8), width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          _buildStatIcon(stat.icon, color: stat.color),
          pw.SizedBox(height: 6),
          pw.Text(
            stat.value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: stat.color,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            stat.label,
            style: pw.TextStyle(
              fontSize: 8,
              color: const PdfColor.fromInt(0xFF333333),
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
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

