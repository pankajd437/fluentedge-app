import 'package:flutter/material.dart';

/// ✅ FLUENTEDGE UI DESIGN CONSTANTS (Updated with latest UI changes)

/// 🎨 PRIMARY COLORS
const Color kPrimaryBlue = Color(0xFF1976D2); // Card, AppBar, CTA Background
const Color kAccentGreen = Color(0xFF43A047); // CTA Button Foreground (Green)
const Color kSecondaryBlue = Color(0xFF42A5F5); // Gradient End
const Color kPrimaryIconBlue = Color(0xFF0D47A1); // Default Icon Color

/// 🌈 GRADIENTS
const Color kBannerBlue = Color(0xFFE3F2FD);
const Color kBannerBlueEnd = Color(0xFFB3E5FC);

final LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kPrimaryBlue, kSecondaryBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final LinearGradient kBannerGradient = LinearGradient(
  colors: [kBannerBlue, kBannerBlueEnd],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// 🪄 CARD & CONTAINER BACKGROUND
const Color kBackgroundSoftBlue = Color(0xFFF2F6FB); // Overall App Background
const Color kCardBackground = Colors.white;
const Color kQuestionnaireTopBanner = Color(0xFFB3E5FC);
const Color kCourseResumeBanner = Color(0xFFBBDEFB);
const Color kQuestionnaireShadow = Color(0xFF90CAF9);

/// 🌙 DARK MODE COLORS (Prepared for future implementation)
const Color kDarkBackground = Color(0xFF121212);
const Color kDarkCardBackground = Color(0xFF1E1E1E);
const Color kDarkPrimaryBlue = Color(0xFF90CAF9);
const Color kDarkAccentGreen = Color(0xFF81C784);

/// 🧱 SPACING + RADIUS + SHADOW
const double kCardPadding = 12.0;
const double kCardRadius = 16.0; // Uniform card rounding
const double kGridSpacing = 16.0;
const double kHoverScaleFactor = 1.025;

final List<BoxShadow> kCardBoxShadow = [
  BoxShadow(
    color: Colors.black26,
    blurRadius: 6,
    offset: Offset(0, 4),
  ),
];

final List<BoxShadow> kCardBoxShadowHovered = [
  BoxShadow(
    color: Colors.black26,
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
];

/// 🔤 FONT SIZES
const double kFontSmall = 12.0;
const double kFontMedium = 13.5;
const double kFontLarge = 16.0;
const double kFontXLarge = 18.0;

/// 🔠 FONT WEIGHTS
const FontWeight kWeightRegular = FontWeight.w400;
const FontWeight kWeightMedium = FontWeight.w500;
const FontWeight kWeightBold = FontWeight.w600;
const FontWeight kWeightExtraBold = FontWeight.w700;

/// 🖋️ TEXT THEME FOR CONSISTENT TYPOGRAPHY CONTROL
final TextTheme kAppTextTheme = const TextTheme(
  displayLarge: TextStyle(fontSize: 32.0, fontWeight: kWeightBold),
  displayMedium: TextStyle(fontSize: 24.0, fontWeight: kWeightBold),
  headlineMedium: TextStyle(fontSize: kFontXLarge, fontWeight: kWeightBold),
  titleLarge: TextStyle(fontSize: kFontLarge, fontWeight: kWeightMedium),
  bodyLarge: TextStyle(fontSize: kFontMedium, fontWeight: kWeightRegular),
  bodyMedium: TextStyle(fontSize: kFontSmall, fontWeight: kWeightRegular),
  labelLarge: TextStyle(fontSize: kButtonTextSize, fontWeight: kWeightBold),
);

/// 🧩 BUTTON STYLES
const double kButtonHeight = 34.0;
const double kButtonRadius = 12.0; // Rounded "Start Now" button
const double kButtonPadding = 16.0;
const double kButtonTextSize = 14.0;
const double kButtonElevation = 2.0;
const Color kButtonForegroundGreen = kAccentGreen;
const Color kButtonBackgroundWhite = Colors.white;

/// 🏷 PREMIUM TAG STYLE
const double kTagFontSize = 9.0;
const FontWeight kTagFontWeight = FontWeight.bold;
const Color kPremiumTagColor = Color(0xFFFFC107); // Amber

/// 📐 GRID SYSTEM
const int kGridCrossAxisCount = 2;
const double kGridChildAspectRatio = 3 / 2.2;

/// 🖼 ICON STYLES
const double kIconSize = 20.0;
const double kAvatarRadius = 20.0;
const Color kAvatarBackground = Colors.white;

/// 🧪 QUESTIONNAIRE COLORS
const Color kOptionButtonBorder = Color(0xFF1976D2);
const Color kProgressBarBackground = Color(0xFFBBDEFB);
const double kProgressHeight = 8.0;

/// 🚀 COURSE JSON FILES (Deprecated)
// ✅ Removed JSON dependency (Courses now embedded directly in Dart)
const List<String> kAllCourseJsonAssets = [
  "assets/json/courses_part6.json", // 🚫 Deprecated
  "assets/json/courses_part7.json", // 🚫 Deprecated
  "assets/json/courses_part3.json", // 🚫 Deprecated
  "assets/json/courses_part4.json", // 🚫 Deprecated
  "assets/json/courses_part5.json", // 🚫 Deprecated
];

/// 🔐 COURSE TAGS
const String kFreeCourseTag = "FREE";
const String kPaidCourseTag = "PREMIUM";

/// 🖼 ICON PLACEHOLDERS (Ensure assets exist)
const String kDefaultFreeCourseIcon = "assets/images/free_course_icon.png";
const String kDefaultPaidCourseIcon = "assets/images/premium_course_icon.png";

/// 🎮 GAMIFICATION
const int kDailyStreakPoints = 10;
const int kLessonCompletionPoints = 25;
const int kQuizCorrectAnswerPoints = 5;

const String kDailyStreakText = "Daily Learning Streak 🔥";
const String kXPPointsText = "XP Points";

/// 🎖 BADGE ASSET PATHS (Preparation for visual rewards)
const String kBadgeMasteryPath = "assets/images/badges/mastery_badge.png";
const String kBadgeCompletionPath = "assets/images/badges/completion_badge.png";

/// 🗂️ COURSE CATEGORIES (For personalized recommendations)
const List<String> kCourseCategories = [
  "Speaking & Fluency",
  "Grammar & Vocabulary",
  "Professional & Career",
  "Academic & School",
  "Travel & Social",
  "Emergency & Health",
  "Public Speaking",
  "Creative & Literary",
  "Diplomatic & Official",
];

/// 🌐 API CONFIGURATION (Environment-specific)
class ApiConfig {
  static const String local = "http://10.0.2.2:8000/api/v1"; // Android Emulator
  static const String staging = "https://staging.api.yourdomain.com/api/v1";
  static const String production = "https://api.yourdomain.com/api/v1";
}

// 🚧 Replace placeholder URL below with actual endpoint if APIs are still required elsewhere.
const String kCourseApiEndpoint = ApiConfig.local; // Default to local for development
