import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart' hide Image;
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
      child: InkWell(
        onTap: () => context.push('/details/${hero.id}'),
        child: HeroImageProvider(
          heroId: hero.id.toString(),
          heroName: hero.name,
          apiImageUrl: hero.image?.url,
          builder: (imageProvider) => Container(
            height: AppConstants.cardHeight,
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
            child: Container(
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
                                      hero.powerstats?.intelligence != 'null'
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
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.check_circle,
                                  size: AppConstants.cardIconSize,
                                  color: theme.colorScheme.primary,
                                ),
                              );
                            }

                            return IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                size: AppConstants.cardIconSize,
                              ),
                              color: theme.colorScheme.primary,
                              onPressed: onAddPressed,
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
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
            child: const Icon(Icons.delete, color: Colors.white),
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
}
