import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_herodex_3000/models/hero_model.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';

void main() {
  group('HeroModel Tests', () {
    test('HeroModel fromJson creates a valid hero object', () {
      final json = {
        'id': '1',
        'name': 'Batman',
        'powerstats': {
          'intelligence': '100',
          'strength': '26',
          'speed': '27',
          'durability': '50',
          'power': '47',
          'combat': '100',
        },
        'biography': {
          'fullName': 'Bruce Wayne',
          'alterEgos': 'No alter egos found.',
          'aliases': ['Dark Knight', 'Caped Crusader'],
          'placeOfBirth': 'Gotham City',
          'firstAppearance': 'Detective Comics #27',
          'publisher': 'DC Comics',
          'alignment': 'good',
        },
        'image': {'url': 'https://example.com/batman.jpg'},
      };

      final hero = HeroModel.fromJson(json);

      expect(hero.id, '1');
      expect(hero.name, 'Batman');
      expect(hero.powerstats?.intelligence, '100');
      expect(hero.powerstats?.combat, '100');
      expect(hero.biography?.fullName, 'Bruce Wayne');
      expect(hero.biography?.publisher, 'DC Comics');
      expect(hero.image?.url, 'https://example.com/batman.jpg');
    });

    test('HeroModel toJson creates valid JSON', () {
      final powerstats = Powerstats('100', '26', '27', '50', '47', '100');
      final biography = Biography(
        'Bruce Wayne',
        'No alter egos found.',
        ['Dark Knight', 'Caped Crusader'],
        'Gotham City',
        'Detective Comics #27',
        'DC Comics',
        'good',
      );
      final image = Image('https://example.com/batman.jpg');

      final hero = HeroModel(
        '1',
        'Batman',
        powerstats,
        biography,
        null,
        null,
        null,
        image,
      );

      final json = hero.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Batman');
      expect(json['powerstats']['intelligence'], '100');
      expect(json['biography']['fullName'], 'Bruce Wayne');
      expect(json['image']['url'], 'https://example.com/batman.jpg');
    });
  });

  group('RosterState Tests', () {
    test('RosterState heroCount returns correct count', () {
      final hero1 = HeroModel(
        '1',
        'Batman',
        Powerstats('100', '26', '27', '50', '47', '100'),
        null,
        null,
        null,
        null,
        null,
      );
      final hero2 = HeroModel(
        '2',
        'Superman',
        Powerstats('94', '100', '100', '100', '100', '85'),
        null,
        null,
        null,
        null,
        null,
      );

      final state = RosterLoaded([hero1, hero2]);

      expect(state.heroCount, 2);
    });

    test('RosterState totalPower calculates correctly', () {
      final hero1 = HeroModel(
        '1',
        'Batman',
        Powerstats('100', '26', '27', '50', '47', '100'),
        null,
        null,
        null,
        null,
        null,
      );
      final hero2 = HeroModel(
        '2',
        'Superman',
        Powerstats('94', '100', '100', '100', '100', '85'),
        null,
        null,
        null,
        null,
        null,
      );

      final state = RosterLoaded([hero1, hero2]);

      expect(state.totalPower, 147); // 47 + 100
    });

    test('RosterState totalCombat calculates correctly', () {
      final hero1 = HeroModel(
        '1',
        'Batman',
        Powerstats('100', '26', '27', '50', '47', '100'),
        null,
        null,
        null,
        null,
        null,
      );
      final hero2 = HeroModel(
        '2',
        'Superman',
        Powerstats('94', '100', '100', '100', '100', '85'),
        null,
        null,
        null,
        null,
        null,
      );

      final state = RosterLoaded([hero1, hero2]);

      expect(state.totalCombat, 185); // 100 + 85
    });
  });
}
