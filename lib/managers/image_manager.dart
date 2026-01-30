import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ImageManager {
  ImageManager._internal();
  static final ImageManager _instance = ImageManager._internal();
  factory ImageManager() => _instance;

  String getWebImageUrl(String heroId, String heroName) {
    final String imageBaseUrl =
        'https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/images/lg';
    final nameLowerCase = heroName.toLowerCase().replaceAll(' ', '-');
    return '$imageBaseUrl/$heroId-$nameLowerCase.jpg';
  }

  /// Check if hero image already exists locally
  Future<bool> hasLocalHeroImage(String heroId) async {
    // Local storage not supported on web
    if (kIsWeb) return false;

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/hero_images');

    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final file = File('${imagesDir.path}/${heroId}_image.$ext');
      if (file.existsSync()) {
        return true;
      }
    }
    return false;
  }

  /// Get local hero image path if it exists
  Future<String?> getLocalHeroImagePath(String heroId) async {
    // Local storage not supported on web
    if (kIsWeb) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/hero_images');

    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final filePath = '${imagesDir.path}/${heroId}_image.$ext';
      final file = File(filePath);
      if (file.existsSync()) {
        return filePath;
      }
    }
    return null;
  }
}
