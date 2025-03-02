import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/vehicle.dart';
import '../viewmodels/parking_viewmodel.dart';

class VehicleExitDialog extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleExitDialog({super.key, required this.vehicle});

  @override
  State<VehicleExitDialog> createState() => _VehicleExitDialogState();
}

class _VehicleExitDialogState extends State<VehicleExitDialog> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ParkingViewModel>();

    return AlertDialog(
      title: Text(
        'Registrar Saída',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placa: ${widget.vehicle.plate.toUpperCase()}',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (widget.vehicle.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Descrição: ${widget.vehicle.description!}',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
                if (widget.vehicle.driver != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Motorista: ${widget.vehicle.driver!}',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Vaga: ${widget.vehicle.spotNumber}',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Entrada: ${_formatDateTime(widget.vehicle.entryTime)}',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: GoogleFonts.poppins()),
        ),
        TextButton(
          onPressed: () async {
            final success = await viewModel.registerVehicleExit(
              widget.vehicle.id!,
            );
            if (success) {
              if (mounted) {
                Navigator.pop(context);
              }
            } else {
              if (mounted) {
                setState(() {
                  errorMessage = viewModel.errorMessage;
                });
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Confirmar Saída', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}
