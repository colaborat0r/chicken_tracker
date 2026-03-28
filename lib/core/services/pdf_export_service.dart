import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';

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
}
