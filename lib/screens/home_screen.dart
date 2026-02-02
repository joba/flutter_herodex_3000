import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/utils/decorations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Load roster when screen is opened
    context.read<RosterBloc>().add(GetRoster());
    return BlocBuilder<RosterBloc, RosterState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: homeCardDecoration(context),
                      child: Column(
                        children: [
                          Text(
                            AppTexts.home.totalHeroes.toUpperCase(),
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${state.heroCount}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 82,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
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
                              const SizedBox(height: 16),
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
                        Container(
                          padding: const EdgeInsets.all(16),
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
                              const SizedBox(height: 16),
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
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppTexts.news.latestNews.toUpperCase(),
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(30),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
