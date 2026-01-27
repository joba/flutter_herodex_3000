import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class RosterState {
  final Set<String> heroIds;

  RosterState({Set<String>? heroIds}) : heroIds = heroIds ?? {};
}

class RosterInitial extends RosterState {
  RosterInitial() : super();
}

class RosterLoading extends RosterState {
  RosterLoading({super.heroIds});
}

class RosterLoaded extends RosterState {
  final List<HeroModel> heroes;

  RosterLoaded(this.heroes)
    : super(heroIds: heroes.map((h) => h.id.toString()).toSet());
}

class RosterSuccess extends RosterState {
  final String message;

  RosterSuccess(this.message, {super.heroIds});
}

class RosterError extends RosterState {
  final String message;

  RosterError(this.message, {super.heroIds});
}
