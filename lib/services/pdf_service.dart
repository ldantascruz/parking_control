import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/vehicle.dart';

class PdfService {
  static Future<Uint8List> generateVehicleHistoryReport(
    List<Vehicle> vehicles,
  ) async {
    final pdf = pw.Document();
    final font = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final fontBold = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final fontSemiBold = await rootBundle.load(
      'assets/fonts/Poppins-SemiBold.ttf',
    );
    final ttf = pw.Font.ttf(font);
    final ttfBold = pw.Font.ttf(fontBold);
    final ttfSemiBold = pw.Font.ttf(fontSemiBold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (pw.Context context) => [
              _buildHeader(ttfBold),
              _buildVehicleTable(vehicles, ttf, ttfSemiBold),
              pw.SizedBox(height: 20),
              _buildSummary(vehicles, ttf, ttfSemiBold),
            ],
        footer: (context) => _buildFooter(context, ttf),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Estacionamento',
          style: pw.TextStyle(font: fontBold, fontSize: 20),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Relatório de Histórico de Veículos',
          style: pw.TextStyle(font: fontBold, fontSize: 16),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildVehicleTable(
    List<Vehicle> vehicles,
    pw.Font font,
    pw.Font fontSemiBold,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5), // Placa
        1: const pw.FlexColumnWidth(2), // Motorista
        2: const pw.FlexColumnWidth(1), // Vaga
        3: const pw.FlexColumnWidth(2), // Entrada
        4: const pw.FlexColumnWidth(2), // Saída
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Placa', fontSemiBold, isHeader: true),
            _buildTableCell('Motorista', fontSemiBold, isHeader: true),
            _buildTableCell('Vaga', fontSemiBold, isHeader: true),
            _buildTableCell('Entrada', fontSemiBold, isHeader: true),
            _buildTableCell('Saída', fontSemiBold, isHeader: true),
          ],
        ),
        // Data rows
        ...vehicles.map(
          (vehicle) => pw.TableRow(
            children: [
              _buildTableCell(vehicle.plate.toUpperCase(), font),
              _buildTableCell(vehicle.driver ?? '-', font),
              _buildTableCell('${vehicle.spotNumber}', font),
              _buildTableCell(_formatDateTime(vehicle.entryTime), font),
              _buildTableCell(
                vehicle.exitTime != null
                    ? _formatDateTime(vehicle.exitTime!)
                    : 'Em andamento',
                font,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableCell(
    String text,
    pw.Font font, {
    bool isHeader = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildSummary(
    List<Vehicle> vehicles,
    pw.Font font,
    pw.Font fontSemiBold,
  ) {
    final activeVehicles = vehicles.where((v) => v.exitTime == null).length;
    final completedVehicles = vehicles.where((v) => v.exitTime != null).length;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Resumo',
            style: pw.TextStyle(font: fontSemiBold, fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total de veículos:', style: pw.TextStyle(font: font)),
              pw.Text('${vehicles.length}', style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Veículos ativos:', style: pw.TextStyle(font: font)),
              pw.Text('$activeVehicles', style: pw.TextStyle(font: font)),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Veículos finalizados:', style: pw.TextStyle(font: font)),
              pw.Text('$completedVehicles', style: pw.TextStyle(font: font)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context context, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(font: font, fontSize: 9),
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static Future<void> printPdf(List<Vehicle> vehicles) async {
    final pdfData = await generateVehicleHistoryReport(vehicles);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
      name:
          'Histórico de Veículos - ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
    );
  }

  static Future<File> savePdf(List<Vehicle> vehicles) async {
    final pdfData = await generateVehicleHistoryReport(vehicles);
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/historico_veiculos_${DateFormat('dd-MM-yyyy').format(DateTime.now())}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfData);
    return file;
  }

  static Future<Uint8List> generateDailyReport(List<Vehicle> vehicles) async {
    final pdf = pw.Document();
    final font = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final fontBold = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final fontSemiBold = await rootBundle.load('assets/fonts/Poppins-SemiBold.ttf');
    final ttf = pw.Font.ttf(font);
    final ttfBold = pw.Font.ttf(fontBold);
    final ttfSemiBold = pw.Font.ttf(fontSemiBold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          _buildDailyHeader(ttfBold),
          _buildVehicleTable(vehicles, ttf, ttfSemiBold),
          pw.SizedBox(height: 20),
          _buildSummary(vehicles, ttf, ttfSemiBold),
        ],
        footer: (context) => _buildFooter(context, ttf),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildDailyHeader(pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Estacionamento',
          style: pw.TextStyle(font: fontBold, fontSize: 20),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Relatório Diário',
          style: pw.TextStyle(font: fontBold, fontSize: 16),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static Future<String> saveReport(Uint8List pdfData, String fileName) async {
    String filePath;
    try {
      // Try to use application documents directory
      final directory = await getApplicationDocumentsDirectory();
      filePath = '${directory.path}/$fileName.pdf';
    } catch (e) {
      // Fallback for tests - use temporary directory
      final directory = Directory.systemTemp;
      filePath = '${directory.path}/$fileName.pdf';
    }
    
    final file = File(filePath);
    await file.writeAsBytes(pdfData);
    return filePath;
  }
}
