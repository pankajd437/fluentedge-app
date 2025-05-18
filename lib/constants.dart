import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// FLUENTEDGE UI & DESIGN CONSTANTS
/// ------------------------------------------------------------

/// 🎨 PRIMARY COLORS
const Color kPrimaryBlue     = Color(0xFF1976D2);
const Color kAccentGreen     = Color(0xFF43A047);
const Color kSecondaryBlue   = Color(0xFF42A5F5);
const Color kPrimaryIconBlue = Color(0xFF0D47A1);

/// 🌈 BACKGROUNDS
const Color kBackgroundSoftBlue  = Color(0xFFF2F6FB);
const Color kCardBackground      = Colors.white;

/// 🌙 DARK MODE (future support)
const Color kDarkBackground      = Color(0xFF121212);
const Color kDarkCardBackground  = Color(0xFF1E1E1E);
const Color kDarkPrimaryBlue     = Color(0xFF90CAF9);
const Color kDarkAccentGreen     = Color(0xFF81C784);

/// 🪄 GRADIENTS
final LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kPrimaryBlue, kSecondaryBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient kBannerGradient = const LinearGradient(
  colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// 🧱 CARD & CONTAINER STYLING
const double kCardPadding   = 12.0;
const double kCardRadius    = 16.0;
const double kCardRadiusSm  = 8.0;
const double kCardRadiusMed = 14.0;
const double kCardRadiusLg  = 24.0;
const double kCardRadiusLarge = 20.0;

final List<BoxShadow> kCardBoxShadow = [
  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
];
final List<BoxShadow> kCardBoxShadowHovered = [
  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
];

/// 🔤 TYPOGRAPHY
const double kFontSmall   = 12.0;
const double kFontMedium  = 13.5;
const double kFontLarge   = 16.0;
const double kFontXLarge  = 18.0;

const FontWeight kWeightRegular   = FontWeight.w400;
const FontWeight kWeightMedium    = FontWeight.w500;
const FontWeight kWeightBold      = FontWeight.w600;
const FontWeight kWeightExtraBold = FontWeight.w700;

final TextTheme kAppTextTheme = const TextTheme(
  displayLarge:   TextStyle(fontSize: 32.0, fontWeight: kWeightBold),
  displayMedium:  TextStyle(fontSize: 24.0, fontWeight: kWeightBold),
  headlineMedium: TextStyle(fontSize: kFontXLarge, fontWeight: kWeightBold),
  titleLarge:     TextStyle(fontSize: kFontLarge,  fontWeight: kWeightMedium),
  bodyLarge:      TextStyle(fontSize: kFontMedium, fontWeight: kWeightRegular),
  bodyMedium:     TextStyle(fontSize: kFontSmall,  fontWeight: kWeightRegular),
  labelLarge:     TextStyle(fontSize: kFontLarge,  fontWeight: kWeightBold),
);

/// 🧩 BUTTON STYLES
const double kButtonHeight          = 48.0;
const double kButtonRadius          = 12.0;
const double kButtonTextSize        = 14.0;
const double kButtonElevation       = 2.0;
const Color  kButtonBackgroundColor = kPrimaryBlue;
const Color  kButtonForegroundColor = Colors.white;

/// 💡 ONBOARDING & TIP SETTINGS
const Duration kTipDelay   = Duration(seconds: 6);
const String   kTipMessage = "💡 Not sure? Just pick what feels most like you!";

/// 📌 SPACING CONSTANTS
const double kSpacingXSmall = 4.0;
const double kSpacingSmall  = 8.0;
const double kSpacingMedium = 16.0;
const double kSpacingLarge  = 24.0;
const double kPagePadding   = 16.0;

/// 🧑‍🏫 MENTOR WIDGET SIZES
const double kMentorWidgetSize     = 180.0;
const double kMentorUpperBodySize  = 180.0;
const double kMentorFullBodySize   = 280.0;

/// 🏆 XP & PROGRESS
const String kDailyStreakText        = "Daily Streak";
const String kXPPointsText           = "XP Points";
const int    kLessonCompletionPoints = 100;

/// 🧾 HIVE KEYS
const String kHiveBoxSettings          = 'settingsBox';
const String kHiveKeyLanguage          = 'preferredLanguage';
const String kHiveKeyOnboarding        = 'onboardingComplete';
const String kHiveBoxUserState         = 'user_state';
const String kHiveKeyUserName          = 'user_name';
const String kHiveKeyEmail             = 'email';
const String kHiveKeyGender            = 'gender';
const String kHiveKeyAgeGroup          = 'age_group';
const String kHiveKeyLearningGoal      = 'learning_goal';
const String kHiveKeyUserLevel         = 'user_level';
const String kHiveKeyComfortLevel      = 'comfort_level';
const String kHiveKeyPracticeFrequency = 'practice_frequency';
const String kHiveKeyInterests         = 'interests';
const String kHiveKeyChallenges        = 'challenges';
const String kHiveKeyProficiencyScore  = 'proficiency_score';
const String kHiveKeyLanguagePreference= 'language_preference';
const String kHiveKeyLocale            = 'locale';
const String kHiveBoxCompletedLessons  = 'completed_lessons';
const String kHiveKeyRecommendedCourses = 'recommended_courses'; // ✅ NEW

/// 🏅 AWARDED XP KEYS (to avoid duplicate XP across sessions)
const String kHiveBoxAwardedXP = 'awarded_xp_keys'; // ✅ NEW

/// 📐 GRID SYSTEM
const int    kGridCrossAxisCount   = 2;
const double kGridChildAspectRatio = 3 / 2.2;
const double kGridSpacing          = 16.0;

/// 📎 STYLING CONSTANTS
const Duration kShortAnimationDuration = Duration(milliseconds: 200);
const TextStyle kActivityTitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

/// 🏷 COURSE TAGS
const String kFreeCourseTag  = "FREE";
const String kPaidCourseTag  = "PREMIUM";

/// 🔄 PAGE TRANSITIONS
const Duration kPageTransitionDuration = Duration(milliseconds: 300);
const Curve    kPageTransitionCurve    = Curves.easeInOut;

/// 🔊 AUDIO PATHS
const String kAudioAssetPrefixEn = 'assets/audio/en/';
const String kAudioAssetPrefixHi = 'assets/audio/hi/';

/// 🚀 ROUTE NAMES
const String routeWelcome               = '/';
const String routeRegistration          = '/registration';
const String routeLogin                 = '/login'; // ✅ NEW
const String routeProfilingChat         = '/profiling';
const String routeSkillCheck            = '/skillcheck';
const String routeProfilingResult       = '/profilingresult';
const String routeCourseRecommendations = '/recommendations';

const String routeCoursesDashboard   = '/coursesDashboard';
const String routeAchievements       = '/achievements';
const String routeUserDashboard      = '/userDashboard';
const String routeLeaderboard        = '/leaderboard';
const String routeCommunity          = '/community';
const String routeFriendDetail       = '/friendDetail';
const String routeBadgeDetail        = '/badgeDetail';
const String routeAnalytics          = '/analytics';
const String routeMenu               = '/menu';
const String routeCourseDetail       = '/courseDetail';
const String routeLessonPage         = '/lessonPage';
const String routeLessonComplete     = '/lessonComplete';
const String routeChat               = '/chat';

/// 🌐 API CONFIGURATION
class ApiConfig {
  static const String local      = "http://10.0.2.2:8000"; // ✅ FIXED: Removed trailing /api/v1
  static const String staging    = "https://staging.api.yourdomain.com/api/v1";
  static const String production = "https://api.yourdomain.com/api/v1";
}

/// ------------------------------------------------------------
/// Additional styles used in LessonActivityPage
/// ------------------------------------------------------------

const double kBaseFontSize = 20.0;

const TextStyle kActivityBodyStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.black87,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const Color vibrantPink = Color(0xFFE83E8C);
const Color refinedGreenStart = Color(0xFF388E3C);
const Color refinedGreenEnd   = Color(0xFF66BB6A);

const TextStyle kVibrantCaptionStyle = TextStyle(
  fontSize: kBaseFontSize - 2,
  color: Colors.white,
  fontStyle: FontStyle.italic,
);

const TextStyle kVibrantTitleStyle = TextStyle(
  fontSize: kBaseFontSize + 4,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle kVibrantBodyStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.white,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kVibrantMessageStyle = TextStyle(
  fontSize: kBaseFontSize,
  color: Colors.white,
  height: 1.5,
  fontWeight: FontWeight.w400,
);

const TextStyle kAudioInstructionStyle = TextStyle(
  fontSize: kBaseFontSize + 2,
  fontWeight: FontWeight.w600,
  color: Color(0xFF004D40),
);

const TextStyle kSpeakingPromptTitleStyleNew = TextStyle(
  fontSize: kBaseFontSize + 2,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 2,
      color: Colors.black26,
    )
  ],
);
