// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EDEN - Algerian Plant Intelligence';

  @override
  String get appName => 'EDEN';

  @override
  String get appTagline => 'Algerian Plant Intelligence';

  @override
  String get splashLoading => 'Initializing flora database...';

  @override
  String get splashFooter => 'Powered by AI & Nature';

  @override
  String get skip => 'Skip';

  @override
  String get onboardingTitle1 => 'Discover Algeria\'s';

  @override
  String get onboardingTitle1Highlight => 'Flora';

  @override
  String get onboardingDesc1 =>
      'Instantly recognize local plants. Point your camera at any flower or tree to unlock the secrets of nature.';

  @override
  String get onboardingTitle2 => 'Know Your Plants Inside Out';

  @override
  String get onboardingDesc2 =>
      'Access detailed botanical data on local Algerian flora and instantly detect potential diseases.';

  @override
  String get onboardingTitle3 => 'Play & Learn Anywhere';

  @override
  String get onboardingDesc3 =>
      'Test your knowledge with fun quizzes and identify plants in the deepest Sahara without internet.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get greeting => 'Salam,';

  @override
  String get userName => 'Yacine 🌿';

  @override
  String get searchPlaceholder => 'Search for Algerian plants...';

  @override
  String get recentlyIdentified => 'Recently Identified';

  @override
  String get seeAll => 'See All';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get didYouKnow => 'Did you know?';

  @override
  String get didYouKnowText =>
      'Algeria has over 3,150 plant species. The Tell Atlas region is a biodiversity hotspot containing many endemic species found nowhere else on Earth.';

  @override
  String get trendingInAlgeria => 'Trending in Algeria';

  @override
  String get readGuide => 'Read Guide';

  @override
  String get navHome => 'Home';

  @override
  String get navDiseases => 'Diseases';

  @override
  String get navMyGarden => 'My Garden';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String error(String message) {
    return 'Error: $message';
  }
}
