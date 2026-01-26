import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/models/search_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiManager _apiManager = ApiManager();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  SearchModel? _searchResult;
  String _error = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchHero() async {
    final searchTerm = _searchController.text.trim();
    if (searchTerm.isEmpty) return;

    setState(() {
      _searchResult = null;
      _error = '';
      _isLoading = true;
    });
    try {
      final result = await _apiManager.searchHeroes(searchTerm);
      setState(() {
        _searchResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
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
              ElevatedButton(
                onPressed: _isLoading ? null : _searchHero,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('SEARCH'),
              ),
              const SizedBox(height: 20),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (_searchResult != null) ...[
                Text('Found ${_searchResult!.results.length} results'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResult!.results.length,
                    itemBuilder: (context, index) {
                      final hero = _searchResult!.results[index];
                      return ListTile(
                        title: Text(hero.name),
                        subtitle: Text('ID: ${hero.id}'),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
