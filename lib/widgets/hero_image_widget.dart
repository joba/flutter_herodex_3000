import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/image_manager.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';

class HeroImageProvider extends StatelessWidget {
  final String heroId;
  final String heroName;
  final String? apiImageUrl;
  final Widget Function(ImageProvider imageProvider) builder;

  const HeroImageProvider({
    super.key,
    required this.heroId,
    required this.heroName,
    required this.apiImageUrl,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final imageManager = ImageManager();

    // On web, always use network images as local storage doesn't work the same way
    if (kIsWeb) {
      AppLogger.log('Using network image for hero $heroName (web)');
      final webImageUrl = imageManager.getWebImageUrl(heroId, heroName);
      return builder(NetworkImage(webImageUrl));
    }

    return FutureBuilder<String?>(
      future: imageManager.getLocalHeroImagePath(heroId),
      builder: (context, snapshot) {
        ImageProvider imageProvider;

        AppLogger.log(
          'FutureBuilder snapshot for hero $heroName: ${snapshot.connectionState}, hasData: ${snapshot.hasData}',
        );
        if (snapshot.hasData && snapshot.data != null) {
          AppLogger.log('Using local image for hero $heroName');
          // Use local image if available
          imageProvider = FileImage(File(snapshot.data!));
        } else {
          AppLogger.log('Using network image for hero $heroName');
          // Fall back to network image
          imageProvider = NetworkImage(apiImageUrl ?? '');
        }

        return builder(imageProvider);
      },
    );
  }
}
