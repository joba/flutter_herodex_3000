import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/blocs/search/search_bloc.dart';
import 'package:flutter_herodex_3000/blocs/search/search_event.dart';
import 'package:flutter_herodex_3000/blocs/search/search_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/hero_card_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(context.read<ApiManager>()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedAlignment;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load search history
    context.read<SearchBloc>().add(LoadSearchHistory());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(AppConstants.searchDebounceDuration, () {
      _searchHero();
    });
  }

  void _searchHero() {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) return;
    context.read<SearchBloc>().add(SearchHeroRequested(searchTerm));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RosterBloc, RosterState>(
          listener: (context, state) {
            if (state is RosterSuccess) {
              AppSnackBar.of(context).showSuccess(state.message);
            } else if (state is RosterError) {
              AppSnackBar.of(context).showError(state.message);
            }
          },
        ),
        BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchError) {
              AppSnackBar.of(context).showError(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.appPaddingBase),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: AppTexts.search.searchPlaceholder,
                    hintText: AppTexts.search.hint,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppConstants.appPaddingBase / 2),
                Wrap(
                  spacing: AppConstants.appPaddingBase / 2,
                  children: [
                    FilterChip(
                      label: Text('All'),
                      selectedColor: AppColors.primary,
                      selected: _selectedAlignment == null,
                      onSelected: (_) =>
                          setState(() => _selectedAlignment = null),
                      showCheckmark: false,
                    ),
                    FilterChip(
                      label: Text('Good'),
                      selectedColor: AppColors.secondary,
                      selected: _selectedAlignment == 'good',
                      onSelected: (_) =>
                          setState(() => _selectedAlignment = 'good'),
                      showCheckmark: false,
                    ),
                    FilterChip(
                      label: Text('Bad'),
                      selectedColor: AppColors.error,
                      selected: _selectedAlignment == 'bad',
                      onSelected: (_) =>
                          setState(() => _selectedAlignment = 'bad'),
                      showCheckmark: false,
                    ),
                    FilterChip(
                      label: Text('Neutral'),
                      selectedColor: AppColors.neutral,
                      selected: _selectedAlignment == 'neutral',
                      onSelected: (_) =>
                          setState(() => _selectedAlignment = 'neutral'),
                      showCheckmark: false,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.appPaddingBase),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchInitial &&
                          state.searchHistory.isEmpty) {
                        return Center(
                          child: Text(
                            AppTexts.search.emptyHistory,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      if (state is SearchInitial &&
                          state.searchHistory.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppTexts.search.recentSearches,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<SearchBloc>().add(
                                      ClearSearchHistory(),
                                    );
                                  },
                                  child: Text(AppTexts.search.clearAll),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppConstants.appPaddingBase / 2,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.searchHistory.length,
                                itemBuilder: (context, index) {
                                  final query = state.searchHistory[index];
                                  return ListTile(
                                    leading: const Icon(Icons.history),
                                    title: Text(query),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: AppConstants.cardIconSize,
                                      ),
                                      onPressed: () {
                                        context.read<SearchBloc>().add(
                                          RemoveFromSearchHistory(query),
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      _searchController.text = query;
                                      context.read<SearchBloc>().add(
                                        SearchHeroRequested(query),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SearchSuccess) {
                        // Filter heroes by alignment
                        final filteredHeroes = _selectedAlignment == null
                            ? state.result.results
                            : state.result.results
                                  .where(
                                    (hero) =>
                                        hero.biography?.alignment
                                            ?.toLowerCase() ==
                                        _selectedAlignment,
                                  )
                                  .toList();
                        return Column(
                          children: [
                            Text(
                              AppTexts.search.searchResults(
                                filteredHeroes.length,
                              ),
                            ),
                            const SizedBox(height: AppConstants.appPaddingBase),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredHeroes.length,
                                itemBuilder: (context, index) {
                                  final hero = filteredHeroes[index];
                                  return HeroCard(
                                    hero: hero,
                                    onAddPressed: () {
                                      context.read<RosterBloc>().add(
                                        AddHeroToRoster(hero),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
