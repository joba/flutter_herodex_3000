import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class FavoritesEvent {}

class AddHeroToFavorites extends FavoritesEvent {
  final HeroModel hero;
  AddHeroToFavorites(this.hero);
}
