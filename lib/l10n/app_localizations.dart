import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'EDEN - Algerian Plant Intelligence'**
  String get appTitle;

  /// App name displayed on splash screen
  ///
  /// In en, this message translates to:
  /// **'EDEN'**
  String get appName;

  /// App tagline on splash screen
  ///
  /// In en, this message translates to:
  /// **'Algerian Plant Intelligence'**
  String get appTagline;

  /// Loading message on splash screen
  ///
  /// In en, this message translates to:
  /// **'Initializing flora database...'**
  String get splashLoading;

  /// Footer text on splash screen
  ///
  /// In en, this message translates to:
  /// **'Powered by AI & Nature'**
  String get splashFooter;

  /// Skip button on onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// First part of onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Discover Algeria\'s'**
  String get onboardingTitle1;

  /// Highlighted word (Flora) in onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Flora'**
  String get onboardingTitle1Highlight;

  /// Description for onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Instantly recognize local plants. Point your camera at any flower or tree to unlock the secrets of nature.'**
  String get onboardingDesc1;

  /// Title for onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Know Your Plants Inside Out'**
  String get onboardingTitle2;

  /// Description for onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Access detailed botanical data on local Algerian flora and instantly detect potential diseases.'**
  String get onboardingDesc2;

  /// Title for onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Play & Learn Anywhere'**
  String get onboardingTitle3;

  /// Description for onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge with fun quizzes and identify plants in the deepest Sahara without internet.'**
  String get onboardingDesc3;

  /// Get started button on last onboarding page
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Next button on onboarding pages
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Greeting on home page
  ///
  /// In en, this message translates to:
  /// **'Salam,'**
  String get greeting;

  /// User name on home page
  ///
  /// In en, this message translates to:
  /// **'Yacine 🌿'**
  String get userName;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search for Algerian plants...'**
  String get searchPlaceholder;

  /// Recently identified section title
  ///
  /// In en, this message translates to:
  /// **'Recently Identified'**
  String get recentlyIdentified;

  /// See all button
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Time label for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Time label for yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Time label for days ago
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// Did you know section title
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get didYouKnow;

  /// Did you know section content
  ///
  /// In en, this message translates to:
  /// **'Algeria has over 3,150 plant species. The Tell Atlas region is a biodiversity hotspot containing many endemic species found nowhere else on Earth.'**
  String get didYouKnowText;

  /// Trending section title
  ///
  /// In en, this message translates to:
  /// **'Trending in Algeria'**
  String get trendingInAlgeria;

  /// Read guide button text
  ///
  /// In en, this message translates to:
  /// **'Read Guide'**
  String get readGuide;

  /// Bottom navigation home label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation diseases label
  ///
  /// In en, this message translates to:
  /// **'Diseases'**
  String get navDiseases;

  /// Bottom navigation my garden label
  ///
  /// In en, this message translates to:
  /// **'My Garden'**
  String get navMyGarden;

  /// Bottom navigation quiz label
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get navQuiz;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// Select language dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Error message template
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
