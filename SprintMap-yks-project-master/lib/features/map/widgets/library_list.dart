import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';
import 'package:sprintmap/features/map/models/library.dart';

class LibraryList extends StatelessWidget {
  final List<Library> libraries;
  final Function(Library) onLibraryTap;

  const LibraryList({
    super.key,
    required this.libraries,
    required this.onLibraryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: libraries.isEmpty
          ? const Center(
              child: Text('Yakında kütüphane bulunamadı'),
            )
          : ListView.builder(
              itemCount: libraries.length,
              itemBuilder: (context, index) {
                final library = libraries[index];
                return ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.bookOpen,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(
                    library.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  subtitle: Text(library.address),
                  onTap: () => onLibraryTap(library),
                );
              },
            ),
    );
  }
} 