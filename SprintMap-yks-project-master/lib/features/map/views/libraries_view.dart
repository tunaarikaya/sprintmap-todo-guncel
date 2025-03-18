import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/features/map/models/library.dart';
import 'package:sprintmap/features/map/services/library_service.dart';
import 'package:sprintmap/features/map/widgets/library_map.dart';
import 'package:sprintmap/features/map/widgets/library_list.dart';
import 'package:sprintmap/features/map/widgets/library_details.dart';

class LibrariesView extends StatefulWidget {
  const LibrariesView({super.key});

  @override
  State<LibrariesView> createState() => _LibrariesViewState();
}

class _LibrariesViewState extends State<LibrariesView> {
  final MapController _mapController = MapController();
  final LibraryService _libraryService = LibraryService();
  
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Library> _libraries = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Konum izinlerini kontrol et
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Konum izni reddedildi');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Konum izinleri kalıcı olarak reddedildi, ayarlardan etkinleştirin');
      }

      // Mevcut konumu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Yakındaki kütüphaneleri ara
      await _searchNearbyLibraries();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyLibraries() async {
    if (_currentPosition == null) return;

    try {
      final libraries = await _libraryService.searchNearbyLibraries(_currentPosition!);
      setState(() {
        _libraries = libraries;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _showLibraryDetails(Library library) {
    showModalBottomSheet(
      context: context,
      builder: (context) => LibraryDetails(
        library: library,
        onShowOnMap: () {
          Navigator.pop(context);
          _mapController.move(library.position, 16.0);
        },
        onGetDirections: () {
          // Burada yol tarifi için bir uygulama açılabilir
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.accentColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Bir hata oluştu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationNotFoundView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Konum bulunamadı',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Column(
      children: [
        Expanded(
          child: LibraryMap(
            mapController: _mapController,
            currentPosition: _currentPosition!,
            libraries: _libraries,
            onLibraryTap: _showLibraryDetails,
          ),
        ),
        LibraryList(
          libraries: _libraries,
          onLibraryTap: (library) {
            _mapController.move(library.position, 16.0);
            _showLibraryDetails(library);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : _currentPosition == null
                  ? _buildLocationNotFoundView()
                  : _buildMapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
} 