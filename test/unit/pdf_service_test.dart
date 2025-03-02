import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_control/models/vehicle.dart';
import 'package:parking_control/services/pdf_service.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockAssetBundle mockAssetBundle;
  late List<Vehicle> testVehicles;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    TestWidgetsFlutterBinding.ensureInitialized();

    // Setup test data
    testVehicles = [
      Vehicle(
        id: '1',
        plate: 'ABC1234',
        driver: 'John Doe',
        spotNumber: 1,
        entryTime: DateTime(2024, 1, 1, 10, 0),
        exitTime: DateTime(2024, 1, 1, 12, 0),
      ),
      Vehicle(
        id: '2',
        plate: 'XYZ5678',
        spotNumber: 2,
        entryTime: DateTime(2024, 1, 1, 11, 0),
      ),
    ];

    // Mock font loading
    when(
      () => mockAssetBundle.load(any()),
    ).thenAnswer((_) async => Uint8List(0).buffer.asByteData());
  });

  group('PdfService', () {
    test(
      'generateVehicleHistoryReport creates PDF with correct content',
      () async {
        final pdfData = await PdfService.generateVehicleHistoryReport(
          testVehicles,
        );

        expect(pdfData, isA<Uint8List>());
        expect(pdfData.length, greaterThan(0));
      },
    );

    test('generateDailyReport creates PDF with correct content', () async {
      final pdfData = await PdfService.generateDailyReport(testVehicles);

      expect(pdfData, isA<Uint8List>());
      expect(pdfData.length, greaterThan(0));
    });

    test('saveReport saves PDF file to correct location', () async {
      final pdfData = await PdfService.generateVehicleHistoryReport(
        testVehicles,
      );
      final filePath = await PdfService.saveReport(pdfData, 'test_report');

      expect(filePath, isNotEmpty);
      expect(File(filePath).existsSync(), isTrue);

      // Cleanup
      await File(filePath).delete();
    });

    test('generateVehicleHistoryReport handles empty vehicle list', () async {
      final pdfData = await PdfService.generateVehicleHistoryReport([]);

      expect(pdfData, isA<Uint8List>());
      expect(pdfData.length, greaterThan(0));
    });

    test('generateDailyReport handles empty vehicle list', () async {
      final pdfData = await PdfService.generateDailyReport([]);

      expect(pdfData, isA<Uint8List>());
      expect(pdfData.length, greaterThan(0));
    });
  });
}
