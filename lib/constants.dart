import 'package:flutter/material.dart';

/// ✅ FLUENTEDGE UI DESIGN CONSTANTS (Updated with latest UI changes)

/// 🎨 PRIMARY COLORS
const Color kPrimaryBlue = Color(0xFF1976D2); // Deep Blue - Card, AppBar, CTA Background
const Color kAccentGreen = Color(0xFF43A047); // CTA Button Foreground (Green)
const Color kSecondaryBlue = Color(0xFF42A5F5); // Gradient end
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

/// 🧱 SPACING + RADIUS + SHADOW
const double kCardPadding = 12.0;
const double kCardRadius = 16.0; // Updated from 12 to 16 for uniform card rounding
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

/// 🧩 BUTTON STYLES
const double kButtonHeight = 34.0;
const double kButtonRadius = 12.0; // Updated for rounded "Start Now" button
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

/// 🚀 COURSE JSON FILES
// ✅ REMOVED JSON DEPENDENCY: Course lessons now embedded directly in Dart code.
// Old JSON file references kept here temporarily for reference, but NO LONGER USED.
const String kCourseDataPart1 = "assets/json/courses_part6.json"; // 🚫 Deprecated
const String kCourseDataPart2 = "assets/json/courses_part7.json"; // 🚫 Deprecated
const String kCourseDataPart3 = "assets/json/courses_part3.json"; // 🚫 Deprecated
const String kCourseDataPart4 = "assets/json/courses_part4.json"; // 🚫 Deprecated
const String kCourseDataPart5 = "assets/json/courses_part5.json"; // 🚫 Deprecated

// 🚫 DEPRECATED: This list is no longer used as courses and lessons are directly embedded.
const List<String> kAllCourseJsonAssets = [
  kCourseDataPart1,
  kCourseDataPart2,
  kCourseDataPart3,
  kCourseDataPart4,
  kCourseDataPart5,
];

/// 🔐 COURSE TAGS
const String kFreeCourseTag = "FREE";
const String kPaidCourseTag = "PREMIUM";

/// 🖼 ICON PLACEHOLDERS
const String kDefaultFreeCourseIcon = "assets/images/free_course_icon.png";
const String kDefaultPaidCourseIcon = "assets/images/premium_course_icon.png";

/// 🎮 GAMIFICATION
const int kDailyStreakPoints = 10;
const int kLessonCompletionPoints = 25;
const int kQuizCorrectAnswerPoints = 5;

const String kDailyStreakText = "Daily Learning Streak 🔥";
const String kXPPointsText = "XP Points";

/// 🌐 API CONFIG
const String kCourseApiEndpoint = "https://your.api.endpoint.com/api/v1/courses"; // ✅ Still valid if APIs are used elsewhere.
