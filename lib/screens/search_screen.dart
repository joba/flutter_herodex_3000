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
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/hero_card_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(ApiManager()),
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
    _debounce = Timer(const Duration(milliseconds: 500), () {
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: AppTexts.search.searchPlaceholder,
                    hintText: AppTexts.search.hint,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
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
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.searchHistory.length,
                                itemBuilder: (context, index) {
                                  final query = state.searchHistory[index];
                                  return ListTile(
                                    leading: const Icon(Icons.history),
                                    title: Text(query),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.close, size: 20),
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
                        return Column(
                          children: [
                            Text(
                              AppTexts.search.searchResults(
                                state.result.results.length,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.result.results.length,
                                itemBuilder: (context, index) {
                                  final hero = state.result.results[index];
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
