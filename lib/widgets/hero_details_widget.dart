import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_event.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/widgets/hero_image_widget.dart';

class HeroDetails extends StatefulWidget {
  final String id;
  const HeroDetails({super.key, required this.id});

  @override
  State<HeroDetails> createState() => _HeroDetailsState();
}

class _HeroDetailsState extends State<HeroDetails> {
  @override
  void initState() {
    super.initState();
    // Load hero detail when widget is initialized
    context.read<HeroDetailBloc>().add(LoadHeroDetail(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<HeroDetailBloc>().add(
                    LoadHeroDetail(widget.id),
                  ),
                  child: Text(AppTexts.common.retry),
                ),
              ],
            ),
          );
        }

        if (state is! HeroDetailLoaded) {
          return Center(child: Text(AppTexts.roster.heroNotFound));
        }

        final hero = state.hero;

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      if (hero.image?.url != null)
                        SizedBox(
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
                            ],
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
                                style: theme.textTheme.titleMedium,
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
                              _buildStatRow(
                                'Speed',
                                hero.powerstats!.speed,
                                theme,
                              ),
                              _buildStatRow(
                                'Durability',
                                hero.powerstats!.durability,
                                theme,
                              ),
                              _buildStatRow(
                                'Power',
                                hero.powerstats!.power,
                                theme,
                              ),
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
                                style: theme.textTheme.titleMedium,
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
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow(
                                'Gender',
                                hero.appearance!.gender,
                                theme,
                              ),
                              _buildInfoRow(
                                'Race',
                                hero.appearance!.race,
                                theme,
                              ),
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
                              Text('WORK', style: theme.textTheme.titleMedium),
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
                                style: theme.textTheme.titleMedium,
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
                        backgroundColor: Colors.black.withAlpha(128),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
