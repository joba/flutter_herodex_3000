import 'package:flutter_herodex_3000/models/search_model.dart';

abstract class SearchState {
  final List<String> searchHistory;
  SearchState({this.searchHistory = const []});
}

class SearchInitial extends SearchState {
  SearchInitial({super.searchHistory});
}

class SearchLoading extends SearchState {
  SearchLoading({super.searchHistory});
}

class SearchSuccess extends SearchState {
  final SearchModel result;
  SearchSuccess(this.result, {super.searchHistory});
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message, {super.searchHistory});
}
