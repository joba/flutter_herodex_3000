import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiManager _apiManager;
  final AnalyticsManager _analyticsManager;
  static const String _historyKey = 'search_history';
  static const int _maxHistoryItems = AppConstants.maxSearchHistory;

  SearchBloc({
    required ApiManager apiManager,
    required AnalyticsManager analyticsManager,
  }) : _apiManager = apiManager,
       _analyticsManager = analyticsManager,
       super(SearchInitial()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchHeroRequested>(_onSearchRequested);
    on<AddToSearchHistory>(_onAddToSearchHistory);
    on<RemoveFromSearchHistory>(_onRemoveFromSearchHistory);
    on<ClearSearchHistory>(_onClearSearchHistory);
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    emit(SearchInitial(searchHistory: history));
  }

  Future<void> _onSearchRequested(
    SearchHeroRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading(searchHistory: state.searchHistory));
    try {
      _analyticsManager.logEvent(
        name: 'search_hero',
        parameters: {'search_term': event.searchTerm},
      );
      final result = await _apiManager.searchHeroes(event.searchTerm);
      // Add to history after successful search
      add(AddToSearchHistory(event.searchTerm));
      _analyticsManager.logEvent(
        name: 'search_hero_success',
        parameters: {'search_term': event.searchTerm},
      );
      emit(SearchSuccess(result, searchHistory: state.searchHistory));
    } catch (e) {
      _analyticsManager.logEvent(
        name: 'search_hero_error',
        parameters: {'search_term': event.searchTerm, 'error': e.toString()},
      );
      emit(SearchError('Error: $e', searchHistory: state.searchHistory));
    }
  }

  Future<void> _onAddToSearchHistory(
    AddToSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = List<String>.from(state.searchHistory);

    // Remove if already exists (to avoid duplicates)
    history.remove(event.searchTerm);

    // Add to front
    history.insert(0, event.searchTerm);

    // Limit to max items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await prefs.setStringList(_historyKey, history);

    // Update state with new history
    if (state is SearchSuccess) {
      emit(
        SearchSuccess((state as SearchSuccess).result, searchHistory: history),
      );
    } else if (state is SearchError) {
      emit(SearchError((state as SearchError).message, searchHistory: history));
    } else if (state is SearchLoading) {
      emit(SearchLoading(searchHistory: history));
    } else {
      emit(SearchInitial(searchHistory: history));
    }
  }

  Future<void> _onRemoveFromSearchHistory(
    RemoveFromSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final history = List<String>.from(state.searchHistory);
    history.remove(event.searchTerm);
    await prefs.setStringList(_historyKey, history);

    // Update state with new history
    if (state is SearchSuccess) {
      emit(
        SearchSuccess((state as SearchSuccess).result, searchHistory: history),
      );
    } else if (state is SearchError) {
      emit(SearchError((state as SearchError).message, searchHistory: history));
    } else if (state is SearchLoading) {
      emit(SearchLoading(searchHistory: history));
    } else {
      emit(SearchInitial(searchHistory: history));
    }
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    _analyticsManager.logEvent(name: 'clear_search_history');

    // Update state with empty history
    if (state is SearchSuccess) {
      emit(SearchSuccess((state as SearchSuccess).result, searchHistory: []));
    } else if (state is SearchError) {
      emit(SearchError((state as SearchError).message, searchHistory: []));
    } else if (state is SearchLoading) {
      emit(SearchLoading(searchHistory: []));
    } else {
      emit(SearchInitial(searchHistory: []));
    }
  }
}
