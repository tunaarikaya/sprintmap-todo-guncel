import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:sprintmap/features/map/models/library.dart';

class LibraryService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';
  static const int _searchRadius = 5000; // 5 km

  Future<List<Library>> searchNearbyLibraries(LatLng position) async {
    try {
      final query = '''
        [out:json];
        (
          node["amenity"="library"]
            (around:$_searchRadius,${position.latitude},${position.longitude});
          node["building"="library"]
            (around:$_searchRadius,${position.latitude},${position.longitude});
        );
        out body;
      ''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: query,
      );

      if (response.statusCode == 200) {
        final jsonString = utf8.decode(response.bodyBytes);
        final data = jsonDecode(jsonString);
        final elements = data['elements'] as List;

        return elements.map((element) {
          final tags = element['tags'] as Map<String, dynamic>;
          return Library(
            id: element['id'],
            name: tags['name'] ?? 'İsimsiz Kütüphane',
            position: LatLng(
              element['lat'].toDouble(),
              element['lon'].toDouble(),
            ),
            address: tags['addr:street'] ?? tags['addr:full'] ?? '',
            operator: tags['operator'] ?? '',
            openingHours: tags['opening_hours'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Kütüphaneler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kütüphaneler aranırken hata oluştu: $e');
    }
  }
} 