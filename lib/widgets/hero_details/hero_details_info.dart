import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';

class HeroDetailsInfo extends StatelessWidget {
  final HeroModel hero;
  const HeroDetailsInfo({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero.powerstats != null) ...[
            if (hero.biography != null) ...[
              Text('BIOGRAPHY', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.appPaddingBase),
              _buildInfoRow('Full Name', hero.biography!.fullName, theme),
              _buildInfoRow('Alter Egos', hero.biography!.alterEgos, theme),
              _buildInfoRow(
                'Place of Birth',
                hero.biography!.placeOfBirth,
                theme,
              ),
              _buildInfoRow(
                'First Appearance',
                hero.biography!.firstAppearance,
                theme,
              ),
              _buildInfoRow('Publisher', hero.biography!.publisher, theme),
              const SizedBox(height: AppConstants.appPaddingBase * 1.5),
            ],

            // Appearance
            if (hero.appearance != null) ...[
              Text('APPEARANCE', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.appPaddingBase),
              _buildInfoRow('Gender', hero.appearance!.gender, theme),
              _buildInfoRow('Race', hero.appearance!.race, theme),
              _buildInfoRow(
                'Height',
                hero.appearance!.height?.join(', '),
                theme,
              ),
              _buildInfoRow(
                'Weight',
                hero.appearance!.weight?.join(', '),
                theme,
              ),
              const SizedBox(height: AppConstants.appPaddingBase * 1.5),
            ],

            // Work
            if (hero.work != null) ...[
              Text('WORK', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.appPaddingBase),
              _buildInfoRow('Occupation', hero.work!.occupation, theme),
              _buildInfoRow('Base', hero.work!.base, theme),
              const SizedBox(height: AppConstants.appPaddingBase * 1.5),
            ],

            // Connections
            if (hero.connections != null) ...[
              Text('CONNECTIONS', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.appPaddingBase),
              _buildInfoRow(
                'Group Affiliation',
                hero.connections!.groupAffiliation,
                theme,
              ),
              _buildInfoRow('Relatives', hero.connections!.relatives, theme),
            ],
            const SizedBox(height: AppConstants.appPaddingBase * 1.5),
          ],
        ],
      ),
    );
  }
}

Widget _buildInfoRow(String label, String? value, ThemeData theme) {
  if (value == null || value.isEmpty || value == 'null' || value == '-') {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            '$label:',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
      ],
    ),
  );
}
