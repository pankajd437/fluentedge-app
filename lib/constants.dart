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
final LinearGradient kBannerGradient = LinearGradient(
  colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// 🧱 CARD & CONTAINER STYLING
const double kCardPadding = 12.0;
const double kCardRadius  = 16.0;

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

const FontWeight kWeightRegular    = FontWeight.w400;
const FontWeight kWeightMedium     = FontWeight.w500;
const FontWeight kWeightBold       = FontWeight.w600;
const FontWeight kWeightExtraBold  = FontWeight.w700;

final TextTheme kAppTextTheme = const TextTheme(
  displayLarge:   TextStyle(fontSize: 32.0, fontWeight: kWeightBold),
  displayMedium:  TextStyle(fontSize: 24.0, fontWeight: kWeightBold),
  headlineMedium: TextStyle(fontSize: kFontXLarge, fontWeight: kWeightBold),
  titleLarge:     TextStyle(fontSize: kFontLarge, fontWeight: kWeightMedium),
  bodyLarge:      TextStyle(fontSize: kFontMedium, fontWeight: kWeightRegular),
  bodyMedium:     TextStyle(fontSize: kFontSmall, fontWeight: kWeightRegular),
  labelLarge:     TextStyle(fontSize: kFontLarge, fontWeight: kWeightBold),
);

/// 🧩 BUTTON STYLES
const double kButtonHeight           = 48.0;
const double kButtonRadius           = 12.0;
const double kButtonTextSize         = 14.0;
const double kButtonElevation        = 2.0;
const Color  kButtonBackgroundColor  = kPrimaryBlue;
const Color  kButtonForegroundColor  = Colors.white;

/// 💡 ONBOARDING & TIP SETTINGS
const Duration kTipDelay = Duration(seconds: 6);
const String   kTipMessage = "💡 Not sure? Just pick what feels most like you!";

/// 🧑‍🏫 MENTOR WIDGET
const double kMentorWidgetSize = 180.0;

/// 📐 GRID SYSTEM
const int    kGridCrossAxisCount  = 2;
const double kGridChildAspectRatio = 3 / 2.2;
const double kGridSpacing         = 16.0;

/// 🏷 COURSE TAGS
const String kFreeCourseTag = "FREE";
const String kPaidCourseTag = "PREMIUM";

/// 🌐 API CONFIGURATION
class ApiConfig {
  static const String local      = "http://10.0.2.2:8000/api/v1";
  static const String staging    = "https://staging.api.yourdomain.com/api/v1";
  static const String production = "https://api.yourdomain.com/api/v1";
}
