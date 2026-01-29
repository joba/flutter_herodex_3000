import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/image_manager.dart';

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

    return FutureBuilder<String?>(
      future: imageManager.getLocalHeroImagePath(heroId),
      builder: (context, snapshot) {
        ImageProvider imageProvider;

        if (snapshot.hasData && snapshot.data != null) {
          debugPrint('Using local image for hero $heroName');
          // Use local image if available
          imageProvider = FileImage(File(snapshot.data!));
        } else {
          debugPrint('Using network image for hero $heroName');
          // Fall back to network image
          imageProvider = NetworkImage(apiImageUrl ?? '');
        }

        return builder(imageProvider);
      },
    );
  }
}
