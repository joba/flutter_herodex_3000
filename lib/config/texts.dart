class AppTexts {
  AppTexts._(); // Private constructor to prevent instantiation

  // Onboarding Screen
  static const onboarding = _OnBoardingTexts();

  // Home Screen
  static const home = _HomeTexts();

  // Auth Screen
  static const auth = _AuthTexts();

  // Search Screen
  static const search = _SearchTexts();

  // Roster Screen
  static const roster = _RosterTexts();

  // Settings Screen
  static const settings = _SettingsTexts();

  // Common/Shared texts
  static const common = _CommonTexts();

  // News
  static const news = _NewsTexts();
}

class _OnBoardingTexts {
  const _OnBoardingTexts();

  String get welcome => 'Welcome to HeroDex 3000';
  String get getStarted =>
      'Thank you for choosing our app. Let\'s get you started with a quick setup.';
  String get finish => 'Finish';

  String get analyticsTitle => 'Analytics'.toUpperCase();
  String get analyticsInfo =>
      'Help us improve the app by allowing anonymous analytics tracking.';
  String get enableAnalytics => 'Enable analytics';

  String get crashLyticsTitle => 'Crashlytics'.toUpperCase();
  String get enableCrashlytics => 'Enable Crashlytics';
  String get crashLyticsInfo =>
      'Enable crash reporting to help us fix issues and improve stability.';

  String get locationTitle => 'Location'.toUpperCase();
  String get locationInfo =>
      'Allow location access to get localized content and features.';
  String get enableLocation => 'Enable Location';
}

class _HomeTexts {
  const _HomeTexts();

  String get totalHeroes => 'Total Heroes in Roster';
  String get welcomeMessage => 'Welcome to HeroDex 3000';
  String get power => 'Power';
  String get combat => 'Combat';
}

class _AuthTexts {
  const _AuthTexts();

  String get signIn => 'Sign In';
  String get signUp => 'Sign Up';
  String get emailPlaceholder => 'Email';
  String get passwordPlaceholder => 'Password';
  String get invalidEmail => 'Please enter an email';
  String get invalidPassword => 'Please enter a password';
}

class _SearchTexts {
  const _SearchTexts();

  String get search => 'Search';
  String get recentSearches => 'Recent Searches';
  String get clearAll => 'Clear All';
  String get searchPlaceholder => 'Search for a hero...';
  String get hint => 'Enter a hero name';
  String get noResults => 'No heroes found';
  String searchResults(int result) => 'Found $result result(s)';
  String get searchError => 'Failed to search heroes';
}

class _RosterTexts {
  const _RosterTexts();

  String get title => 'My Roster';
  String get empty => 'No heroes in your roster yet';
  String get deleteConfirm => 'Remove hero from roster?';
  String get heroNotFound => 'Hero not found';
  String heroAdded(String name) => '$name added to roster';
  String heroRemoved(String name) => '$name removed from roster';
}

class _SettingsTexts {
  const _SettingsTexts();

  String get title => 'Settings';
  String get logout => 'Logout';
  String get logoutConfirm => 'Are you sure you want to logout?';
}

class _CommonTexts {
  const _CommonTexts();

  String get title => 'HeroDex 3000';
  String get cancel => 'Cancel';
  String get confirm => 'Confirm';
  String get delete => 'Delete';
  String get save => 'Save';
  String get loading => 'Loading...';
  String get error => 'An error occurred';
  String get retry => 'Retry';
  String get next => 'Next';
}

class _NewsTexts {
  const _NewsTexts();

  String get latestNews => 'Invasion intel feed';
  String get feed1 =>
      'Breaking: Unidentified spacecraft detected entering Earth\'s atmosphere over major cities';
  String get feed2 =>
      'Global defense forces mobilize as alien fleet establishes orbit around the Moon';
  String get feed3 =>
      'First contact attempt fails - extraterrestrial forces begin ground assault on multiple continents';
  String get feed4 =>
      'Heroes unite! Super-powered individuals form defensive line at invasion front';
  String get feed5 =>
      'Scientists decode alien transmission: "Surrender or face total extinction"';
  String get feed6 =>
      'Underground resistance networks established in occupied territories';
  String get feed7 =>
      'Major victory: Combined hero task force destroys alien command ship over Pacific';
  String get feed8 =>
      'Urgent: Alien forces deploy bio-weapons - civilians urged to seek shelter immediately';
  String get feed9 =>
      'Hope emerges as captured alien technology reverse-engineered by global alliance';
  String get feed10 =>
      'Final push begins - heroes lead counteroffensive to reclaim Earth from invaders';
}
