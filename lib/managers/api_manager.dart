import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_herodex_3000/managers/image_manager.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_herodex_3000/models/search_model.dart';
import 'package:path_provider/path_provider.dart';

final imageManager = ImageManager();

class ApiManager {
  // Create a singleton instance
  ApiManager._internal();
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;

  final String _baseUrl = 'https://superheroapi.com/api';
  final String _apiKey = dotenv.env['SUPERHERO_API_KEY'] ?? '';

  // CORS proxy for web
  final String _corsProxy = kIsWeb ? 'http://localhost:3000' : '';

  Future<SearchModel> searchHeroes(String name) async {
    final baseUrl = kIsWeb ? _corsProxy : _baseUrl;
    final apiPath = kIsWeb ? '/api/search/$name' : '/$_apiKey/search/$name';
    final url = '$baseUrl$apiPath';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SearchModel.fromJson(data);
      } else {
        throw Exception('Failed to search heroes: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to search heroes: $e');
    }
  }

  Future<HeroModel> getHeroById(String id) async {
    final baseUrl = kIsWeb ? _corsProxy : _baseUrl;
    final apiPath = kIsWeb ? '/api/$id' : '/$_apiKey/$id';
    final url = '$baseUrl$apiPath';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HeroModel.fromJson(data);
      } else {
        throw Exception('Failed to get hero by ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get hero by ID: $e');
    }
  }

  /// Download and save hero image locally
  Future<String> downloadAndSaveHeroImage(
    String imageUrl,
    String heroId,
  ) async {
    final response = await http.get(
      Uri.parse(imageUrl),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'DNT': '1',
        'Connection': 'keep-alive',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download hero image: HTTP ${response.statusCode}',
      );
    }

    // Get the application documents directory (writable)
    final appDir = await getApplicationDocumentsDirectory();

    // Create images directory if it doesn't exist
    final imagesDir = Directory('${appDir.path}/hero_images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // Get file extension from URL or default to jpg
    final uri = Uri.parse(imageUrl);
    String extension = 'jpg';
    if (uri.pathSegments.isNotEmpty) {
      final lastSegment = uri.pathSegments.last;
      if (lastSegment.contains('.')) {
        extension = lastSegment.split('.').last.toLowerCase();
      }
    }

    // Create local file path
    final fileName = '${heroId}_image.$extension';
    final filePath = '${imagesDir.path}/$fileName';
    final file = File(filePath);

    // Write image bytes to file
    await file.writeAsBytes(response.bodyBytes);

    return filePath; // Return the local file path
  }

  /// Download hero image only if it doesn't exist locally
  Future<String?> downloadHeroImageIfNeeded(
    String imageUrl,
    String heroId,
  ) async {
    // Check if image already exists
    final existingPath = await imageManager.getLocalHeroImagePath(heroId);
    if (existingPath != null) {
      debugPrint('Image already exists for hero $heroId: $existingPath');
      return existingPath;
    }

    // Download if not exists
    try {
      // final nameLowerCase = name.toLowerCase().replaceAll(' ', '-');
      // final imageUrl = '$_imageBaseUrl/$heroId-$nameLowerCase.jpg';
      final localPath = await downloadAndSaveHeroImage(imageUrl, heroId);
      debugPrint('Downloaded new image for hero $heroId: $localPath');
      return localPath;
    } catch (e) {
      debugPrint('Failed to download image for hero $heroId: $e');
      return null;
    }
  }

  /// Delete local hero image
  Future<bool> deleteLocalHeroImage(String heroId) async {
    return await imageManager.deleteLocalHeroImage(heroId);
  }
}
