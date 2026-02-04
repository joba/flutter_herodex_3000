import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/models/hero_alignment.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart' hide Image;
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/hero_image_widget.dart';
import 'package:go_router/go_router.dart';

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback? onAddPressed;
  final bool showIcon;

  const HeroCard({
    super.key,
    required this.hero,
    this.onAddPressed,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardWidget = Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        label: '${hero.name}. ${_buildStatsDescription()}',
        hint: 'Tap to view details',
        button: true,
        child: InkWell(
          onTap: () => context.push('/details/${hero.id}'),
          child: SizedBox(
            height: AppConstants.cardHeight,
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
                        Colors.black.withAlpha(255),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(AppConstants.cardPadding),
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
                                  hero.powerstats?.strength != null &&
                                          hero.powerstats?.strength != 'null'
                                      ? 'Strength: ${hero.powerstats!.strength}'
                                      : 'Strength: N/A',
                                  style: theme.textTheme.displayMedium,
                                ),
                                Text(
                                  hero.powerstats?.intelligence != null &&
                                          hero.powerstats?.intelligence !=
                                              'null'
                                      ? 'Intelligence: ${hero.powerstats!.intelligence}'
                                      : 'Intelligence: N/A',
                                  style: theme.textTheme.displayMedium,
                                ),
                                Text(
                                  hero.powerstats?.combat != null &&
                                          hero.powerstats?.combat != 'null'
                                      ? 'Combat: ${hero.powerstats!.combat}'
                                      : 'Combat: N/A',
                                  style: theme.textTheme.displayMedium,
                                ),
                              ],
                            ),
                          ),
                          if (showIcon)
                            BlocBuilder<RosterBloc, RosterState>(
                              builder: (context, state) {
                                final isInRoster = state.heroes
                                    .map((h) => h.id)
                                    .contains(hero.id);

                                if (isInRoster) {
                                  return Semantics(
                                    label: '${hero.name} is in your roster',
                                    readOnly: true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: AppConstants.cardIconSize,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }

                                return Semantics(
                                  label: 'Add ${hero.name} to roster',
                                  button: true,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      size: AppConstants.cardIconSize,
                                    ),
                                    color: theme.colorScheme.primary,
                                    onPressed: onAddPressed,
                                  ),
                                );
                              },
                            ),
                          if (!showIcon)
                            Semantics(
                              label:
                                  'Alignment: ${hero.biography?.alignment ?? "unknown"}',
                              readOnly: true,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.shield,
                                  size: AppConstants.cardIconSize,
                                  color:
                                      HeroAlignment.fromString(
                                            hero.biography?.alignment,
                                          ) ==
                                          HeroAlignment.good
                                      ? AppColors.secondary
                                      : HeroAlignment.fromString(
                                              hero.biography?.alignment,
                                            ) ==
                                            HeroAlignment.bad
                                      ? AppColors.error
                                      : AppColors.neutral,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Only make it dismissible when showIcon is false (roster screen)
    if (!showIcon) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.cardPadding),
        child: Dismissible(
          key: Key(hero.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: theme.colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Semantics(
              label: 'Delete',
              child: const Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {
            context.read<RosterBloc>().add(
              RemoveHeroFromRoster(hero.id.toString()),
            );
            AppSnackBar.of(
              context,
            ).showSuccess(AppTexts.roster.heroRemoved(hero.name));
          },
          child: cardWidget,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.cardPadding),
      child: cardWidget,
    );
  }

  String _buildStatsDescription() {
    final strength =
        hero.powerstats?.strength != null && hero.powerstats?.strength != 'null'
        ? hero.powerstats!.strength
        : 'N/A';
    final intelligence =
        hero.powerstats?.intelligence != null &&
            hero.powerstats?.intelligence != 'null'
        ? hero.powerstats!.intelligence
        : 'N/A';
    final combat =
        hero.powerstats?.combat != null && hero.powerstats?.combat != 'null'
        ? hero.powerstats!.combat
        : 'N/A';
    return 'Strength $strength, Intelligence $intelligence, Combat $combat';
  }
}
