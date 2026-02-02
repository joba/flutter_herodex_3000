import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/image_manager.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/logger.dart';

class HeroImageProvider extends StatelessWidget {
  final String heroId;
  final String heroName;
  final String? apiImageUrl;
  final BoxFit fit;

  const HeroImageProvider({
    super.key,
    required this.heroId,
    required this.heroName,
    required this.apiImageUrl,
    this.fit = BoxFit.cover,
  });

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Theme.of(context).colorScheme.onErrorContainer,
          size: AppConstants.cardIconSize * 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageManager = ImageManager();

    // On web, always use network images as local storage doesn't work the same way
    if (kIsWeb) {
      AppLogger.log('Using network image for hero $heroName (web)');
      final webImageUrl = imageManager.getWebImageUrl(heroId, heroName);
      return Image.network(
        webImageUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          AppLogger.log('Error loading web image for hero $heroName: $error');
          return _buildErrorPlaceholder(context);
        },
      );
    }

    return FutureBuilder<String?>(
      future: imageManager.getLocalHeroImagePath(heroId),
      builder: (context, snapshot) {
        AppLogger.log(
          'FutureBuilder snapshot for hero $heroName: ${snapshot.connectionState}, hasData: ${snapshot.hasData}',
        );

        if (snapshot.hasData && snapshot.data != null) {
          AppLogger.log('Using local image for hero $heroName');
          // Use local image if available
          return Image.file(
            File(snapshot.data!),
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              AppLogger.log(
                'Error loading local image for hero $heroName: $error',
              );
              // Fall back to network image if local image fails
              if (apiImageUrl != null && apiImageUrl!.isNotEmpty) {
                return Image.network(
                  apiImageUrl!,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    AppLogger.log(
                      'Error loading network fallback for hero $heroName: $error',
                    );
                    return _buildErrorPlaceholder(context);
                  },
                );
              }
              return _buildErrorPlaceholder(context);
            },
          );
        } else {
          AppLogger.log('Using network image for hero $heroName');
          // Fall back to network image
          if (apiImageUrl != null && apiImageUrl!.isNotEmpty) {
            return Image.network(
              apiImageUrl!,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                AppLogger.log(
                  'Error loading network image for hero $heroName: $error',
                );
                return _buildErrorPlaceholder(context);
              },
            );
          }
          // No image URL available
          return _buildErrorPlaceholder(context);
        }
      },
    );
  }
}
