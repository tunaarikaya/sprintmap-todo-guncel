import 'package:latlong2/latlong.dart';

class Library {
  final int id;
  final String name;
  final LatLng position;
  final String address;
  final String operator;
  final String openingHours;

  Library({
    required this.id,
    required this.name,
    required this.position,
    required this.address,
    required this.operator,
    required this.openingHours,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'],
      name: json['name'] ?? 'İsimsiz Kütüphane',
      position: json['position'],
      address: json['address'] ?? '',
      operator: json['operator'] ?? '',
      openingHours: json['opening_hours'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'address': address,
      'operator': operator,
      'opening_hours': openingHours,
    };
  }
} 