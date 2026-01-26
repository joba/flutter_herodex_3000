import 'package:flutter_herodex_3000/models/search_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final SearchModel result;
  SearchSuccess(this.result);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
