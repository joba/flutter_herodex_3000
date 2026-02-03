enum HeroAlignment {
  good,
  bad,
  neutral;

  String get value => name;

  static HeroAlignment? fromString(String? str) {
    if (str == null) return null;
    final normalized = str.toLowerCase().trim();

    try {
      return HeroAlignment.values.firstWhere((e) => e.name == normalized);
    } catch (_) {
      return null;
    }
  }

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }
}
