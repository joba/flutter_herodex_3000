import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class HeroDetailsStats extends StatelessWidget {
  final HeroModel hero;

  const HeroDetailsStats({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero.powerstats != null) ...[
            Text('POWERSTATS', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.appPaddingBase),
            _buildStatRow('Intelligence', hero.powerstats!.intelligence, theme),
            _buildStatRow('Strength', hero.powerstats!.strength, theme),
            _buildStatRow('Speed', hero.powerstats!.speed, theme),
            _buildStatRow('Durability', hero.powerstats!.durability, theme),
            _buildStatRow('Power', hero.powerstats!.power, theme),
            _buildStatRow('Combat', hero.powerstats!.combat, theme),
          ],
        ],
      ),
    );
  }
}

Widget _buildStatRow(String label, String? value, ThemeData theme) {
  if (value == null || value == 'null') return const SizedBox.shrink();

  final intValue = int.tryParse(value) ?? 0;

  return Padding(
    padding: const EdgeInsets.only(bottom: AppConstants.appPaddingBase),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.appPaddingBase / 4),
        LinearProgressIndicator(
          value: intValue / 100,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      ],
    ),
  );
}
