import 'package:flutter_herodex_3000/models/hero_alignment.dart';
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

  int get totalCombat {
    return heroes.fold(0, (sum, hero) {
      final combat = int.tryParse(hero.powerstats?.combat ?? '0') ?? 0;
      return sum + combat;
    });
  }

  int get totalSpeed {
    return heroes.fold(0, (sum, hero) {
      final speed = int.tryParse(hero.powerstats?.speed ?? '0') ?? 0;
      return sum + speed;
    });
  }

  int get totalStrength {
    return heroes.fold(0, (sum, hero) {
      final strength = int.tryParse(hero.powerstats?.strength ?? '0') ?? 0;
      return sum + strength;
    });
  }

  int get goodCount {
    return heroes
        .where(
          (hero) =>
              HeroAlignment.fromString(hero.biography?.alignment) ==
              HeroAlignment.good,
        )
        .length;
  }

  int get badCount {
    return heroes
        .where(
          (hero) =>
              HeroAlignment.fromString(hero.biography?.alignment) ==
              HeroAlignment.bad,
        )
        .length;
  }

  int get neutralCount {
    return heroes
        .where(
          (hero) =>
              HeroAlignment.fromString(hero.biography?.alignment) ==
              HeroAlignment.neutral,
        )
        .length;
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
