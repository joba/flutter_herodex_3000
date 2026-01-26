import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FirebaseFirestore _firestore;
  final AnalyticsManager _analyticsManager;
  final CrashlyticsManager _crashlyticsManager;

  FavoritesBloc({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _analyticsManager = AnalyticsManager(),
      _crashlyticsManager = CrashlyticsManager(),
      super(FavoritesInitial()) {
    on<AddHeroToFavorites>(_onAddHeroToFavorites);
  }

  Future<void> _onAddHeroToFavorites(
    AddHeroToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      await _firestore
          .collection('heroes')
          .doc(event.hero.id.toString())
          .set(event.hero.toJson());
      _analyticsManager.logEvent(
        name: 'add_hero_to_favorites',
        parameters: {'hero_name': event.hero.name},
      );
      emit(FavoritesSuccess(event.hero.name));
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to add hero to favorites',
      );
      emit(FavoritesError('Failed to add hero: $e'));
    }
  }
}
