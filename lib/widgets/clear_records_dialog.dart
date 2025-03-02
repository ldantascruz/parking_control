import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../viewmodels/parking_viewmodel.dart';

class ClearRecordsDialog extends StatelessWidget {
  const ClearRecordsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ParkingViewModel>();

    return AlertDialog(
      title: Text(
        'Finalizar Dia',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: Text(
        'Isso irá remover todos os registros de veículos e liberar todas as vagas. Esta ação não pode ser desfeita. Deseja continuar?',
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: GoogleFonts.poppins()),
        ),
        TextButton(
          onPressed: () async {
            final success = await viewModel.clearAllRecords();
            if (context.mounted) {
              if (success) {
                Navigator.pop(context);
                showAdaptiveDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Sucesso', style: GoogleFonts.poppins()),
                        content: Text(
                          'Todos os registros foram removidos com sucesso!',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            child: Text('OK', style: GoogleFonts.poppins()),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                );
              } else {
                // Show error message when operation fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(viewModel.errorMessage ?? 'Um erro ocorreu'),
                  ),
                );
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Confirmar', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}
