import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class RosterState {
  final Set<HeroModel> heroes;

  RosterState({Set<HeroModel>? heroes}) : heroes = heroes ?? {};

  int get heroCount => heroes.length;

  int get totalPower {
    return heroes.fold(0, (sum, hero) {
      final power = int.tryParse(hero.powerstats?.power ?? '0') ?? 0;
      return sum + power;
    });
  }
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
