import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/managers/location_manager.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/decorations.dart';
import 'package:flutter_herodex_3000/widgets/heroes_alignment_bar.dart';
import 'package:flutter_herodex_3000/widgets/map/battle_map_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load roster when screen is opened
    context.read<RosterBloc>().add(GetRoster());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<RosterBloc, RosterState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.appPaddingBase),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MergeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(
                          AppConstants.appPaddingBase * 2,
                        ),
                        decoration: homeCardDecoration(context),
                        child: Column(
                          children: [
                            Text(
                              AppTexts.home.totalHeroes.toUpperCase(),
                              style: theme.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppConstants.appPaddingBase),
                            Text(
                              '${state.heroCount}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 82,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            HeroesAlignmentBar(state: state),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.appPaddingBase * 4),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MergeSemantics(
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppConstants.appPaddingBase,
                            ),
                            decoration: homeCardDecoration(
                              context,
                              color: theme.colorScheme.secondary,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppTexts.home.power.toUpperCase(),
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: AppConstants.appPaddingBase,
                                ),
                                Text(
                                  '${state.totalPower}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        MergeSemantics(
                          child: Container(
                            padding: const EdgeInsets.all(
                              AppConstants.appPaddingBase,
                            ),
                            decoration: homeCardDecoration(
                              context,
                              color: theme.colorScheme.secondary,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppTexts.home.combat.toUpperCase(),
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: AppConstants.appPaddingBase,
                                ),
                                Text(
                                  '${state.totalCombat}',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    BattleMapWidget(
                      locationManager: context.read<LocationManager>(),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppTexts.news.latestNews.toUpperCase(),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.appPaddingBase),
                    Column(
                      children: [
                        _NewsItem(text: AppTexts.news.feed10),
                        _NewsItem(text: AppTexts.news.feed9),
                        _NewsItem(text: AppTexts.news.feed8),
                        _NewsItem(text: AppTexts.news.feed7),
                        _NewsItem(text: AppTexts.news.feed6),
                        _NewsItem(text: AppTexts.news.feed5),
                        _NewsItem(text: AppTexts.news.feed4),
                        _NewsItem(text: AppTexts.news.feed3),
                        _NewsItem(text: AppTexts.news.feed2),
                        _NewsItem(text: AppTexts.news.feed1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NewsItem extends StatelessWidget {
  final String text;

  const _NewsItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'News alert',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.appPaddingBase),
        padding: const EdgeInsets.all(AppConstants.appPaddingBase),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.warning_amber,
                color: Theme.of(context).colorScheme.error,
                size: AppConstants.appPaddingBase,
              ),
            ),
            const SizedBox(width: AppConstants.appPaddingBase),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
