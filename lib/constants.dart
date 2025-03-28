import 'package:flutter/material.dart';

/// ✅ FLUENTEDGE UI DESIGN CONSTANTS

// 🔷 Primary Color Shades (Inspired by Paytm but unique)
const Color kPrimaryBlue = Color(0xFF1976D2); // Deep Blue
const Color kSecondaryBlue = Color(0xFF42A5F5); // Light Blue
const Color kAccentBlue = Color(0xFF1565C0); // Button Shade
const Color kBannerBlue = Color(0xFFE3F2FD); // Top Banner Gradient Start
const Color kBannerBlueEnd = Color(0xFFB3E5FC); // Top Banner Gradient End
const Color kPrimaryIconBlue = Color(0xFF0D47A1); // Icon Blue

// ✅ Background Constants
const Color kBackgroundSoftBlue = Color(0xFFF2F6FB); // Soft greyish blue
const Color kBackgroundDark = Color(0xFF1E2A47); // Dark mode background

// 🔘 Backgrounds
const Color kBackgroundLight = Color(0xFFF2F6FB); // Light background for general use
const Color kCardBackground = Colors.white; // Card background color
const Color kCardBorder = Color(0xFFBBDEFB); // Card border color
const Color kCardShadow = Color(0xFF90CAF9); // Card shadow color
const Color kButtonBackground = Color(0xFF1565C0); // Button background color

// 🔤 Font Sizes
const double kFontSmall = 12.0; // Small font size for text
const double kFontMedium = 13.5; // Medium font size for text
const double kFontLarge = 16.0; // Large font size for text
const double kFontXLarge = 18.0; // Extra Large fonts for titles and headers

// 🔠 Font Weights
const FontWeight kWeightRegular = FontWeight.w400; // Regular font weight
const FontWeight kWeightMedium = FontWeight.w500; // Medium font weight
const FontWeight kWeightBold = FontWeight.w600; // Bold font weight
const FontWeight kWeightExtraBold = FontWeight.w700; // Extra bold for primary headings

// 🧱 Spacing
const double kCardPadding = 12.0; // Padding for cards
const double kCardRadius = 12.0; // Card radius for rounded corners
const double kButtonHeight = 34.0; // Height for buttons
const double kButtonRadius = 8.0; // Rounded corners for buttons (kept this one)
const double kGridSpacing = 12.0; // Spacing for grid items
const double kPagePadding = 16.0; // General padding for pages

// 🟦 Shadows
final List<BoxShadow> kCardBoxShadow = [
  BoxShadow(
    color: kCardShadow.withOpacity(0.3), // Shadow color for cards
    blurRadius: 6, // Blur radius for shadow
    offset: const Offset(0, 3), // Shadow offset
  ),
];

// 🔘 Input Field Constants
const double kInputFieldHeight = 48.0; // Height for input fields
const double kInputFieldBorderRadius = 8.0; // Border radius for rounded input fields

// 🔸 Button Constants
const double kButtonPadding = 16.0; // Padding inside buttons
const double kButtonTextSize = 14.0; // Text size inside buttons
const double kButtonElevation = 2.0; // Button elevation for shadow

// 🔹 Gradient Constants (for backgrounds, banners, etc.)
final LinearGradient kPrimaryGradient = LinearGradient(
  colors: [kPrimaryBlue, kSecondaryBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
); // Primary gradient for button or background

final LinearGradient kBannerGradient = LinearGradient(
  colors: [kBannerBlue, kBannerBlueEnd],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
); // Gradient for banners or top sections
