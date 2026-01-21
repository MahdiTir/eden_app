// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'إيدن - ذكاء النباتات الجزائرية';

  @override
  String get appName => 'إيدن';

  @override
  String get appTagline => 'ذكاء النباتات الجزائرية';

  @override
  String get splashLoading => 'جاري تهيئة قاعدة بيانات النباتات...';

  @override
  String get splashFooter => 'مدعوم بالذكاء الاصطناعي والطبيعة';

  @override
  String get skip => 'تخطي';

  @override
  String get onboardingTitle1 => 'اكتشف';

  @override
  String get onboardingTitle1Highlight => 'النباتات';

  @override
  String get onboardingDesc1 =>
      'تعرف على النباتات المحلية على الفور. وجه كاميرتك إلى أي زهرة أو شجرة لكشف أسرار الطبيعة.';

  @override
  String get onboardingTitle2 => 'اعرف نباتاتك من الداخل والخارج';

  @override
  String get onboardingDesc2 =>
      'احصل على بيانات نباتية مفصلة عن النباتات الجزائرية المحلية واكتشف الأمراض المحتملة على الفور.';

  @override
  String get onboardingTitle3 => 'العب وتعلم في أي مكان';

  @override
  String get onboardingDesc3 =>
      'اختبر معرفتك بالاختبارات الممتعة وحدد النباتات في أعماق الصحراء بدون إنترنت.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get next => 'التالي';

  @override
  String get greeting => 'السلام عليكم،';

  @override
  String get userName => 'ياسين 🌿';

  @override
  String get searchPlaceholder => 'ابحث عن النباتات الجزائرية...';

  @override
  String get recentlyIdentified => 'تم التعرف عليها مؤخراً';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get didYouKnow => 'هل تعلم؟';

  @override
  String get didYouKnowText =>
      'تضم الجزائر أكثر من 3150 نوعاً نباتياً. تعتبر منطقة أطلس التل نقطة ساخنة للتنوع البيولوجي تحتوي على العديد من الأنواع المستوطنة التي لا توجد في أي مكان آخر على وجه الأرض.';

  @override
  String get trendingInAlgeria => 'الأكثر رواجاً في الجزائر';

  @override
  String get readGuide => 'اقرأ الدليل';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDiseases => 'الأمراض';

  @override
  String get navMyGarden => 'حديقتي';

  @override
  String get navQuiz => 'اختبار';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String error(String message) {
    return 'خطأ: $message';
  }

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'عضو في إيدن؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get welcomeBack => 'مرحباً بكم في';

  @override
  String get joinGarden => 'انضم إلى الحديقة';

  @override
  String get discoverFlora => 'اكتشف النباتات الجزائرية';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get defaultUsername => 'مستخدم';
}
