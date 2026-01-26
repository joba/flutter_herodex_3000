import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiManager _apiManager;

  SearchBloc(this._apiManager) : super(SearchInitial()) {
    on<SearchHeroRequested>(_onSearchRequested);
  }

  Future<void> _onSearchRequested(
    SearchHeroRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final result = await _apiManager.searchHeroes(event.searchTerm);
      emit(SearchSuccess(result));
    } catch (e) {
      emit(SearchError('Error: $e'));
    }
  }
}
