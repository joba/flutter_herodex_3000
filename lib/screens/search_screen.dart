import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/search/search_bloc.dart';
import 'package:flutter_herodex_3000/blocs/search/search_event.dart';
import 'package:flutter_herodex_3000/blocs/search/search_state.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
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
    return Scaffold(
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
                      return Column(
                        children: [
                          Text('Found ${state.result.results.length} results'),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.result.results.length,
                              itemBuilder: (context, index) {
                                final hero = state.result.results[index];
                                return HeroCard(hero: hero);
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
    );
  }
}
