import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_bloc.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_event.dart';
import 'package:flutter_herodex_3000/blocs/hero_detail/hero_detail_state.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/widgets/hero_details/hero_details_header.dart';
import 'package:flutter_herodex_3000/widgets/hero_details/hero_details_info.dart';
import 'package:flutter_herodex_3000/widgets/hero_details/hero_details_stats.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

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
                      HeroDetailsHeader(hero: hero),
                      HeroDetailsStats(hero: hero),
                      HeroDetailsInfo(hero: hero),
                      BlocBuilder<RosterBloc, RosterState>(
                        builder: (context, state) {
                          final isInRoster = state.heroes
                              .map((h) => h.id)
                              .contains(hero.id);

                          return UpperCaseElevatedButton(
                            onPressed: isInRoster
                                ? null
                                : () {
                                    context.read<RosterBloc>().add(
                                      AddHeroToRoster(hero),
                                    );
                                  },
                            child: Text(AppTexts.roster.addHero),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Back button
                Positioned(
                  top: AppConstants.appPaddingBase,
                  left: AppConstants.appPaddingBase,
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
}
