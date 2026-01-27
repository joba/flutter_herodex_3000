import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/blocs/search/search_bloc.dart';
import 'package:flutter_herodex_3000/blocs/search/search_event.dart';
import 'package:flutter_herodex_3000/blocs/search/search_state.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:flutter_herodex_3000/widgets/hero_card_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchBloc(ApiManager())),
        BlocProvider(create: (context) => RosterBloc()),
      ],
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
    // Load the roster to know which heroes are already added
    context.read<RosterBloc>().add(GetRoster());
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
    return BlocListener<RosterBloc, RosterState>(
      listener: (context, state) {
        if (state is RosterSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is RosterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search for a hero',
                    hintText: 'Enter hero name...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _searchHero(),
                ),
                const SizedBox(height: 16),
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is SearchLoading ? null : _searchHero,
                      child: state is SearchLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('SEARCH'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchError) {
                        return Text(
                          state.message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                      if (state is SearchSuccess) {
                        // final String searchTerm = _searchController.text.trim();
                        // final List<HeroModel> rosterResults = context
                        //     .read<RosterBloc>()
                        //     .state
                        //     .heroes
                        //     .where(
                        //       (hero) => hero.name.toLowerCase().contains(
                        //         searchTerm.toLowerCase(),
                        //       ),
                        //     )
                        //     .toList();
                        return Column(
                          children: [
                            // Display roster results first
                            // Text(
                            //   'Found ${rosterResults.length} result(s) already in roster',
                            // ),
                            // const SizedBox(height: 16),
                            // Expanded(
                            //   child: ListView.builder(
                            //     itemCount: rosterResults.length,
                            //     itemBuilder: (context, index) {
                            //       final hero = rosterResults[index];
                            //       return HeroCard(
                            //         hero: hero,
                            //         onAddPressed: () {
                            //           context.read<RosterBloc>().add(
                            //             AddHeroToRoster(hero),
                            //           );
                            //         },
                            //       );
                            //     },
                            //   ),
                            // ),
                            Text(
                              'Found ${state.result.results.length} result(s)',
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
