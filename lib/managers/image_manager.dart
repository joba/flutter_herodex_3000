import 'dart:io';

class ImageManager {
  ImageManager._internal();
  static final ImageManager _instance = ImageManager._internal();
  factory ImageManager() => _instance;

  /// Check if hero image already exists locally
  bool hasLocalHeroImage(String heroId) {
    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final file = File('images/${heroId}_image.$ext');
      if (file.existsSync()) {
        return true;
      }
    }
    return false;
  }

  /// Get local hero image path if it exists
  String? getLocalHeroImagePath(String heroId) {
    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    for (final ext in extensions) {
      final filePath = 'images/${heroId}_image.$ext';
      final file = File(filePath);
      if (file.existsSync()) {
        return filePath;
      }
    }
    return null;
  }
}
