import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'roster_event.dart';
import 'roster_state.dart';

class RosterBloc extends Bloc<RosterEvent, RosterState> {
  final FirebaseFirestore _firestore;
  final AnalyticsManager _analyticsManager;
  final CrashlyticsManager _crashlyticsManager;
  final String _collectionName = 'heroes';

  RosterBloc({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _analyticsManager = AnalyticsManager(),
      _crashlyticsManager = CrashlyticsManager(),
      super(RosterInitial()) {
    on<AddHeroToRoster>(_onAddHeroToRoster);
    on<GetHeroById>(_onGetHeroById);
    on<GetRoster>(_onGetRoster);
  }

  Future<void> _onGetRoster(GetRoster event, Emitter<RosterState> emit) async {
    emit(RosterLoading(heroes: state.heroes));
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      final heroes = snapshot.docs
          .map((doc) => HeroModel.fromJson(doc.data()))
          .toList();
      emit(RosterLoaded(heroes));
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to get roster',
      );
      emit(RosterError('Failed to load roster: $e', heroes: state.heroes));
    }
  }

  Future<void> _onAddHeroToRoster(
    AddHeroToRoster event,
    Emitter<RosterState> emit,
  ) async {
    emit(RosterLoading(heroes: state.heroes));
    try {
      await _firestore
          .collection(_collectionName)
          .doc(event.hero.id.toString())
          .set(event.hero.toJson());
      _analyticsManager.logEvent(
        name: 'add_hero_to_roster',
        parameters: {'hero_name': event.hero.name},
      );

      // Update the hero IDs set
      final updatedHeroes = Set<HeroModel>.from(state.heroes)..add(event.hero);
      emit(
        RosterSuccess(
          'Hero ${event.hero.name} added successfully',
          heroes: updatedHeroes,
        ),
      );
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to add hero to roster',
      );
      emit(RosterError('Failed to add hero: $e', heroes: state.heroes));
    }
  }

  Future<HeroModel> _onGetHeroById(
    GetHeroById event,
    Emitter<RosterState> emit,
  ) async {
    emit(RosterLoading());
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(event.heroId)
          .get();
      if (doc.exists) {
        final hero = HeroModel.fromJson(doc.data()!);
        emit(RosterSuccess('Hero loaded successfully'));
        return hero;
      } else {
        emit(RosterError('Hero not found'));
        throw Exception('Hero not found');
      }
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to get hero by ID',
      );
      emit(RosterError('Failed to get hero: $e'));
      throw Exception('Failed to get hero: $e');
    }
  }
}
