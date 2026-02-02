import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/widgets/hero_image_widget.dart';

class HeroDetailsHeader extends StatelessWidget {
  final HeroModel hero;
  const HeroDetailsHeader({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HeroImageProvider(
            heroId: hero.id.toString(),
            heroName: hero.name,
            apiImageUrl: hero.image?.url,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(0),
                  Colors.black.withAlpha(204),
                ],
              ),
            ),
            padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
            alignment: Alignment.bottomLeft,
            child: Text(
              hero.name.toUpperCase(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
