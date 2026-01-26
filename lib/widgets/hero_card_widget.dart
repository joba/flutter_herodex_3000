import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart' hide Image;

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback? onAddPressed;

  const HeroCard({super.key, required this.hero, this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(hero.image?.url ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(255)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                hero.name.toUpperCase(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hero.powerstats?.strength != null
                              ? 'Strength: ${hero.powerstats!.strength}'
                              : 'Strength: N/A',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          hero.powerstats?.intelligence != null
                              ? 'Intelligence: ${hero.powerstats!.intelligence}'
                              : 'Intelligence: N/A',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          hero.powerstats?.combat != null
                              ? 'Combat: ${hero.powerstats!.combat}'
                              : 'Combat: N/A',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 28),
                    color: theme.colorScheme.primary,
                    onPressed: onAddPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
