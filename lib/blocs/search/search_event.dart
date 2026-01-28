abstract class SearchEvent {}

class SearchHeroRequested extends SearchEvent {
  final String searchTerm;
  SearchHeroRequested(this.searchTerm);
}

class LoadSearchHistory extends SearchEvent {}

class AddToSearchHistory extends SearchEvent {
  final String searchTerm;
  AddToSearchHistory(this.searchTerm);
}

class RemoveFromSearchHistory extends SearchEvent {
  final String searchTerm;
  RemoveFromSearchHistory(this.searchTerm);
}

class ClearSearchHistory extends SearchEvent {}
