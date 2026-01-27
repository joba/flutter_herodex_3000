import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class RosterState {
  final Set<HeroModel> heroes;

  RosterState({Set<HeroModel>? heroes}) : heroes = heroes ?? {};
}

class RosterInitial extends RosterState {
  RosterInitial() : super();
}

class RosterLoading extends RosterState {
  RosterLoading({super.heroes});
}

class RosterLoaded extends RosterState {
  final List<HeroModel> roster;

  RosterLoaded(this.roster) : super(heroes: roster.toSet());
}

class RosterSuccess extends RosterState {
  final String message;

  RosterSuccess(this.message, {super.heroes});
}

class RosterError extends RosterState {
  final String message;

  RosterError(this.message, {super.heroes});
}
