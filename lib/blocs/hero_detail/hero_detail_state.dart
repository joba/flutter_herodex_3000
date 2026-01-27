import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class HeroDetailState {}

class HeroDetailInitial extends HeroDetailState {}

class HeroDetailLoading extends HeroDetailState {}

class HeroDetailLoaded extends HeroDetailState {
  final HeroModel hero;
  HeroDetailLoaded(this.hero);
}

class HeroDetailError extends HeroDetailState {
  final String message;
  HeroDetailError(this.message);
}
