import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/pdf_service.dart';
import '../viewmodels/parking_viewmodel.dart';

class VehicleHistoryDialog extends StatelessWidget {
  const VehicleHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ParkingViewModel>();

    return AlertDialog(
      title: Text(
        'Histórico de Veículos',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            viewModel.vehicleHistory.isEmpty
                ? Center(
                  child: Text(
                    'Nenhum registro encontrado',
                    style: GoogleFonts.poppins(),
                  ),
                )
                : Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.vehicleHistory.length,
                    itemBuilder: (context, index) {
                      final vehicle = viewModel.vehicleHistory[index];
                      final bool isActive = vehicle.exitTime == null;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1)
                                  : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isActive
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              context,
                              'Placa:',
                              vehicle.plate.toUpperCase(),
                              isActive: isActive,
                            ),
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              context,
                              'Vaga:',
                              '${vehicle.spotNumber}',
                            ),
                            if (vehicle.driver != null) ...[
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                context,
                                'Motorista:',
                                vehicle.driver!,
                              ),
                            ],
                            const SizedBox(height: 4),
                            _buildInfoRow(
                              context,
                              'Entrada:',
                              _formatDateTime(vehicle.entryTime),
                            ),
                            if (vehicle.exitTime != null) ...[
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                context,
                                'Saída:',
                                _formatDateTime(vehicle.exitTime!),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Fechar', style: GoogleFonts.poppins()),
        ),
        if (viewModel.vehicleHistory.isNotEmpty)
          TextButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: Text('Gerar Relatório', style: GoogleFonts.poppins()),
            onPressed: () {
              PdfService.printPdf(viewModel.vehicleHistory);
            },
          ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    label,
    String value, {
    bool isActive = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color:
                isActive && label == 'Placa:'
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}
