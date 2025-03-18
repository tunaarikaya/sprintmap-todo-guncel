import 'package:flutter/material.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/features/map/models/library.dart';

class LibraryDetails extends StatelessWidget {
  final Library library;
  final VoidCallback onShowOnMap;
  final VoidCallback onGetDirections;

  const LibraryDetails({
    super.key,
    required this.library,
    required this.onShowOnMap,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            library.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          if (library.address.isNotEmpty) ...[
            const Text(
              'Adres:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryColor,
              ),
            ),
            Text(library.address),
            const SizedBox(height: 8),
          ],
          if (library.operator.isNotEmpty) ...[
            const Text(
              'İşleten:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryColor,
              ),
            ),
            Text(library.operator),
            const SizedBox(height: 8),
          ],
          if (library.openingHours.isNotEmpty) ...[
            const Text(
              'Çalışma Saatleri:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryColor,
              ),
            ),
            Text(library.openingHours),
            const SizedBox(height: 8),
          ],
          const Text(
            'Konum:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.tertiaryColor,
            ),
          ),
          Text(
            '${library.position.latitude.toStringAsFixed(6)}, ${library.position.longitude.toStringAsFixed(6)}',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onShowOnMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                ),
                icon: const Icon(Icons.map),
                label: const Text('Haritada Göster'),
              ),
              ElevatedButton.icon(
                onPressed: onGetDirections,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                ),
                icon: const Icon(Icons.directions),
                label: const Text('Yol Tarifi'),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 