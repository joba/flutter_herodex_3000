import 'package:flutter_herodex_3000/models/hero_model.dart';

abstract class RosterEvent {}

class AddHeroToRoster extends RosterEvent {
  final HeroModel hero;
  AddHeroToRoster(this.hero);
}

class RemoveHeroFromRoster extends RosterEvent {
  final String heroId;
  RemoveHeroFromRoster(this.heroId);
}

class GetRoster extends RosterEvent {
  GetRoster();
}

class GetHeroById extends RosterEvent {
  final String heroId;
  GetHeroById(this.heroId);
}
