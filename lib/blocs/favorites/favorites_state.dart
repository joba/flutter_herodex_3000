abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesSuccess extends FavoritesState {
  final String heroName;
  FavoritesSuccess(this.heroName);
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
