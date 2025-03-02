import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/parking_spot.dart';
import '../models/vehicle.dart';

class ParkingSpotTile extends StatelessWidget {
  final ParkingSpot spot;
  final Vehicle? vehicle;
  final VoidCallback onTap;

  const ParkingSpotTile({
    super.key,
    required this.spot,
    this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              spot.isOccupied
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: spot.isOccupied ? Colors.red : Colors.green,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vaga ${spot.number}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: spot.isOccupied ? Colors.red : Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            if (vehicle != null) ...[
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  vehicle!.plate,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
