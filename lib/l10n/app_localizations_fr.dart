// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'EDEN - Intelligence Végétale Algérienne';

  @override
  String get appName => 'EDEN';

  @override
  String get appTagline => 'Intelligence Végétale Algérienne';

  @override
  String get splashLoading => 'Initialisation de la base de données florale...';

  @override
  String get splashFooter => 'Propulsé par l\'IA et la Nature';

  @override
  String get skip => 'Passer';

  @override
  String get onboardingTitle1 => 'Découvrez la';

  @override
  String get onboardingTitle1Highlight => 'Flore';

  @override
  String get onboardingDesc1 =>
      'Reconnaissez instantanément les plantes locales. Pointez votre caméra sur n\'importe quelle fleur ou arbre pour découvrir les secrets de la nature.';

  @override
  String get onboardingTitle2 => 'Connaissez Vos Plantes en Profondeur';

  @override
  String get onboardingDesc2 =>
      'Accédez à des données botaniques détaillées sur la flore algérienne locale et détectez instantanément les maladies potentielles.';

  @override
  String get onboardingTitle3 => 'Jouez et Apprenez Partout';

  @override
  String get onboardingDesc3 =>
      'Testez vos connaissances avec des quiz amusants et identifiez les plantes dans le Sahara le plus profond sans internet.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get greeting => 'Salam,';

  @override
  String get userName => 'Yacine 🌿';

  @override
  String get searchPlaceholder => 'Rechercher des plantes algériennes...';

  @override
  String get recentlyIdentified => 'Récemment Identifiées';

  @override
  String get seeAll => 'Voir Tout';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(int count) {
    return 'Il y a ${count}j';
  }

  @override
  String get didYouKnow => 'Le saviez-vous ?';

  @override
  String get didYouKnowText =>
      'L\'Algérie compte plus de 3 150 espèces végétales. La région de l\'Atlas tellien est un point chaud de biodiversité contenant de nombreuses espèces endémiques que l\'on ne trouve nulle part ailleurs sur Terre.';

  @override
  String get trendingInAlgeria => 'Tendances en Algérie';

  @override
  String get readGuide => 'Lire le Guide';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiseases => 'Maladies';

  @override
  String get navMyGarden => 'Mon Jardin';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String error(String message) {
    return 'Erreur : $message';
  }

  @override
  String get login => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get email => 'Adresse E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get dontHaveAccount => 'Pas encore de compte ?';

  @override
  String get alreadyHaveAccount => 'Membre de EDEN ?';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get welcomeBack => 'Bienvenue sur';

  @override
  String get joinGarden => 'Rejoignez le Jardin';

  @override
  String get discoverFlora => 'Découvrez la Flore Algérienne';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get defaultUsername => 'Utilisateur';
}
