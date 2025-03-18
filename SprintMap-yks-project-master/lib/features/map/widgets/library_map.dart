import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/features/map/models/library.dart';

class LibraryMap extends StatelessWidget {
  final MapController mapController;
  final LatLng currentPosition;
  final List<Library> libraries;
  final Function(Library) onLibraryTap;

  const LibraryMap({
    super.key,
    required this.mapController,
    required this.currentPosition,
    required this.libraries,
    required this.onLibraryTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: currentPosition,
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.sprintmap',
        ),
        MarkerLayer(
          markers: [
            // Kullanıcının konumu
            Marker(
              width: 40.0,
              height: 40.0,
              point: currentPosition,
              child: const Icon(
                Icons.location_on,
                color: AppTheme.secondaryColor,
                size: 40.0,
              ),
            ),
            // Kütüphanelerin konumları
            ...libraries.map(
              (library) => Marker(
                width: 40.0,
                height: 40.0,
                point: library.position,
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.bookOpen,
                    color: AppTheme.accentColor,
                  ),
                  onPressed: () => onLibraryTap(library),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 