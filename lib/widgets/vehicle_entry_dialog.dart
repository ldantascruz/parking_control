import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../viewmodels/parking_viewmodel.dart';

class VehicleEntryDialog extends StatefulWidget {
  final int? preSelectedSpot;

  const VehicleEntryDialog({super.key, this.preSelectedSpot});

  @override
  State<VehicleEntryDialog> createState() => _VehicleEntryDialogState();
}

class _VehicleEntryDialogState extends State<VehicleEntryDialog> {
  final formKey = GlobalKey<FormState>();
  late String plate;
  String? description;
  String? driver;
  late int spotNumber;

  final plateFormatter = MaskTextInputFormatter(
    mask: 'AAA-#@#@',
    filter: {
      'A': RegExp(r'[A-Za-z]'),
      '#': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
    },
  );

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ParkingViewModel>();
    spotNumber =
        widget.preSelectedSpot ?? viewModel.availableParkingSpots.first.number;
    plate = '';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ParkingViewModel>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Registrar Entrada',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFormField(
                          label: 'Placa do Veículo',
                          hint: 'ABC-1234',
                          icon: Icons.credit_card,
                          inputFormatters: [plateFormatter],
                          textCapitalization: TextCapitalization.characters,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Informe a placa';
                            }
                            final regex = RegExp(
                              r'^[A-Za-z]{3}-[A-Za-z0-9]{4,5}$',
                            );
                            if (!regex.hasMatch(value!)) {
                              return 'Placa inválida. Formato correto: ABC-1234, ABC-1A34';
                            }
                            return null;
                          },
                          onSaved: (value) => plate = value ?? '',
                        ),

                        SizedBox(height: 16),
                        _buildFormField(
                          label: 'Nome do Motorista',
                          hint: 'Nome do motorista',
                          icon: Icons.person,
                          textCapitalization: TextCapitalization.characters,
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true
                                      ? 'Informe o nome do motorista'
                                      : null,
                          onSaved: (value) => driver = value,
                        ),
                        SizedBox(height: 16),
                        _buildFormField(
                          label: 'Descrição do Veículo',
                          hint: 'Descrição (opcional)',
                          icon: Icons.description,
                          textCapitalization: TextCapitalization.characters,
                          onSaved: (value) => description = value,
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(16),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'Número da Vaga',
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              prefixIcon: Icon(
                                Icons.local_parking,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            value: spotNumber,
                            items:
                                (() {
                                  final availableSpots =
                                      viewModel.availableParkingSpots
                                          .map((spot) => spot.number)
                                          .toSet();
                                  if (!availableSpots.contains(spotNumber)) {
                                    availableSpots.add(spotNumber);
                                  }
                                  return availableSpots
                                      .map(
                                        (number) => DropdownMenuItem<int>(
                                          value: number,
                                          child: Text(
                                            'Vaga $number',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList();
                                })(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  spotNumber = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text('Confirmar', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        validator: validator,
        onSaved: onSaved,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      final viewModel = context.read<ParkingViewModel>();
      final success = await viewModel.registerVehicleEntry(
        plate,
        description,
        driver,
        spotNumber,
      );
      if (success) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao registrar entrada')));
        }
      }
    }
  }
}
