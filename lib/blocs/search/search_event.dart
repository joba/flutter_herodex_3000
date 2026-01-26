abstract class SearchEvent {}

class SearchHeroRequested extends SearchEvent {
  final String searchTerm;
  SearchHeroRequested(this.searchTerm);
}
