import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_control/viewmodels/parking_viewmodel.dart';
import 'package:parking_control/widgets/clear_records_dialog.dart';
import 'package:provider/provider.dart';

import 'clear_records_dialog_test.mocks.dart';

@GenerateMocks([ParkingViewModel])
void main() {
  late MockParkingViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockParkingViewModel();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ParkingViewModel>.value(
          value: mockViewModel,
          child: const ClearRecordsDialog(),
        ),
      ),
    );
  }

  testWidgets('ClearRecordsDialog should render correctly', (
    WidgetTester tester,
  ) async {
    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Verify dialog title is displayed
    expect(find.text('Finalizar Dia'), findsOneWidget);

    // Verify confirmation message is displayed
    expect(
      find.text(
        'Isso irá remover todos os registros de veículos e liberar todas as vagas. Esta ação não pode ser desfeita. Deseja continuar?',
      ),
      findsOneWidget,
    );

    // Verify buttons are displayed
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Confirmar'), findsOneWidget);
  });

  testWidgets('ClearRecordsDialog should call clearAllRecords when confirmed', (
    WidgetTester tester,
  ) async {
    // Setup mock to return success
    when(mockViewModel.clearAllRecords()).thenAnswer((_) async => true);

    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Tap confirm button
    await tester.tap(find.text('Confirmar'));
    await tester.pump();

    // Verify clearAllRecords was called
    verify(mockViewModel.clearAllRecords()).called(1);
  });

  testWidgets('ClearRecordsDialog should close on successful clearing', (
    WidgetTester tester,
  ) async {
    // Setup mock to return success
    when(mockViewModel.clearAllRecords()).thenAnswer((_) async => true);

    // Build widget in a dialog context
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ChangeNotifierProvider<ParkingViewModel>.value(
                            value: mockViewModel,
                            child: const ClearRecordsDialog(),
                          ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog is shown
    expect(find.byType(ClearRecordsDialog), findsOneWidget);

    // Tap confirm button
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.byType(ClearRecordsDialog), findsNothing);
  });

  testWidgets('ClearRecordsDialog should show error when clearing fails', (
    WidgetTester tester,
  ) async {
    // Setup mock to return failure
    when(mockViewModel.clearAllRecords()).thenAnswer((_) async => false);
    when(mockViewModel.errorMessage).thenReturn('Failed to clear records');

    // Build widget
    await tester.pumpWidget(buildTestWidget());

    // Tap confirm button
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    // Verify error message is displayed
    expect(find.text('Failed to clear records'), findsOneWidget);
  });

  testWidgets('ClearRecordsDialog should close when cancel button is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ChangeNotifierProvider<ParkingViewModel>.value(
                            value: mockViewModel,
                            child: const ClearRecordsDialog(),
                          ),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Tap cancel button
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // Verify dialog is closed
    expect(find.byType(ClearRecordsDialog), findsNothing);
  });
}
