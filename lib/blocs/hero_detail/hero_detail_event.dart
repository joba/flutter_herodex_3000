abstract class HeroDetailEvent {}

class LoadHeroDetail extends HeroDetailEvent {
  final String heroId;
  LoadHeroDetail(this.heroId);
}
