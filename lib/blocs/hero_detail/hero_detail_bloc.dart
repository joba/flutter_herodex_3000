import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'hero_detail_event.dart';
import 'hero_detail_state.dart';

class HeroDetailBloc extends Bloc<HeroDetailEvent, HeroDetailState> {
  final ApiManager _apiManager;
  final RosterBloc? _rosterBloc;

  HeroDetailBloc({required ApiManager apiManager, RosterBloc? rosterBloc})
    : _apiManager = apiManager,
      _rosterBloc = rosterBloc,
      super(HeroDetailInitial()) {
    on<LoadHeroDetail>(_onLoadHeroDetail);
  }

  Future<void> _onLoadHeroDetail(
    LoadHeroDetail event,
    Emitter<HeroDetailState> emit,
  ) async {
    emit(HeroDetailLoading());

    try {
      // First, check if hero exists in roster
      if (_rosterBloc != null) {
        final heroInRoster = _rosterBloc.state.heroes
            .where((h) => h.id.toString() == event.heroId)
            .firstOrNull;

        if (heroInRoster != null) {
          emit(HeroDetailLoaded(heroInRoster));
          return;
        }
      }

      // If not in roster, fetch from API
      final hero = await _apiManager.getHeroById(event.heroId);
      emit(HeroDetailLoaded(hero));
    } catch (e) {
      emit(HeroDetailError('Failed to load hero: $e'));
    }
  }
}
