import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_event.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_state.dart';

class HeroDetails extends StatelessWidget {
  final String id;
  const HeroDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeroDetailBloc, HeroDetailState>(
      builder: (context, state) {
        if (state is HeroDetailLoading || state is HeroDetailInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HeroDetailError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<HeroDetailBloc>().add(LoadHeroDetail(id)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! HeroDetailLoaded) {
          return const Center(child: Text('Hero not found'));
        }

        final theme = Theme.of(context);
        final hero = state.hero;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image
                  if (hero.image?.url != null)
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(hero.image!.url),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
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
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          hero.name.toUpperCase(),
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Powerstats
                        if (hero.powerstats != null) ...[
                          Text(
                            'POWERSTATS',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            'Intelligence',
                            hero.powerstats!.intelligence,
                            theme,
                          ),
                          _buildStatRow(
                            'Strength',
                            hero.powerstats!.strength,
                            theme,
                          ),
                          _buildStatRow('Speed', hero.powerstats!.speed, theme),
                          _buildStatRow(
                            'Durability',
                            hero.powerstats!.durability,
                            theme,
                          ),
                          _buildStatRow('Power', hero.powerstats!.power, theme),
                          _buildStatRow(
                            'Combat',
                            hero.powerstats!.combat,
                            theme,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Biography
                        if (hero.biography != null) ...[
                          Text(
                            'BIOGRAPHY',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Full Name',
                            hero.biography!.fullName,
                            theme,
                          ),
                          _buildInfoRow(
                            'Alter Egos',
                            hero.biography!.alterEgos,
                            theme,
                          ),
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
                          _buildInfoRow(
                            'Publisher',
                            hero.biography!.publisher,
                            theme,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Appearance
                        if (hero.appearance != null) ...[
                          Text(
                            'APPEARANCE',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Gender',
                            hero.appearance!.gender,
                            theme,
                          ),
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
                          const SizedBox(height: 24),
                        ],

                        // Work
                        if (hero.work != null) ...[
                          Text(
                            'WORK',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Occupation',
                            hero.work!.occupation,
                            theme,
                          ),
                          _buildInfoRow('Base', hero.work!.base, theme),
                          const SizedBox(height: 24),
                        ],

                        // Connections
                        if (hero.connections != null) ...[
                          Text(
                            'CONNECTIONS',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Group Affiliation',
                            hero.connections!.groupAffiliation,
                            theme,
                          ),
                          _buildInfoRow(
                            'Relatives',
                            hero.connections!.relatives,
                            theme,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, String? value, ThemeData theme) {
    if (value == null || value == 'null') return const SizedBox.shrink();

    final intValue = int.tryParse(value) ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: intValue / 100,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
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
}
