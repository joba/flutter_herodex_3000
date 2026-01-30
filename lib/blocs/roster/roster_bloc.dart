import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_herodex_3000/managers/analytics_manager.dart';
import 'package:flutter_herodex_3000/managers/api_manager.dart';
import 'package:flutter_herodex_3000/managers/crashlytics_manager.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'roster_event.dart';
import 'roster_state.dart';

class RosterBloc extends Bloc<RosterEvent, RosterState> {
  final ApiManager _apiManager;
  final FirebaseFirestore _firestore;
  final AnalyticsManager _analyticsManager;
  final CrashlyticsManager _crashlyticsManager;
  final String _collectionName = 'heroes';

  RosterBloc({FirebaseFirestore? firestore, ApiManager? apiManager})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _apiManager = apiManager ?? ApiManager(),
      _analyticsManager = AnalyticsManager(),
      _crashlyticsManager = CrashlyticsManager(),
      super(RosterInitial()) {
    on<AddHeroToRoster>(_onAddHeroToRoster);
    on<GetHeroById>(_onGetHeroById);
    on<GetRoster>(_onGetRoster);
    on<RemoveHeroFromRoster>(_removeHeroFromRoster);
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

      if (event.hero.image != null && event.hero.image!.url.isNotEmpty) {
        await downloadAndSaveHeroImage(
          event.hero.image!.url,
          event.hero.id.toString(),
        );
      }

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

  Future<void> _removeHeroFromRoster(
    RemoveHeroFromRoster event,
    Emitter<RosterState> emit,
  ) async {
    // Optimistically remove from state immediately
    final updatedHeroes = Set<HeroModel>.from(state.heroes)
      ..removeWhere((hero) => hero.id.toString() == event.heroId);

    emit(RosterLoaded(updatedHeroes.toList()));

    try {
      await _firestore.collection(_collectionName).doc(event.heroId).delete();

      // Delete local image if it exists
      await _apiManager.deleteLocalHeroImage(event.heroId);

      _analyticsManager.logEvent(
        name: 'remove_hero_from_roster',
        parameters: {'hero_id': event.heroId},
      );

      emit(RosterSuccess('Hero removed successfully', heroes: updatedHeroes));
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to remove hero from roster',
      );

      // Revert the change on error by reloading
      add(GetRoster());
      emit(RosterError('Failed to remove hero: $e', heroes: state.heroes));
    }
  }

  Future<void> downloadAndSaveHeroImage(String imageUrl, String heroId) async {
    debugPrint('Downloading image for hero: $imageUrl');
    try {
      await _apiManager.downloadHeroImageIfNeeded(imageUrl, heroId);
      _analyticsManager.logEvent(
        name: 'download_hero_image',
        parameters: {'hero_id': heroId},
      );
    } catch (e, stackTrace) {
      _crashlyticsManager.recordError(
        e,
        stackTrace,
        reason: 'Failed to download and save hero image',
      );
      // Handle error as needed
    }
  }
}
