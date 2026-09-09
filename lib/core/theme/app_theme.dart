import 'package:flutter/material.dart';

class AppTheme {
static const Color primaryOrange = Color(0xFFFF6B00);
static const Color darkOrange = Color(0xFFE65100);
static const Color lightOrange = Color(0xFFFFF3E8);

static ThemeData theme = ThemeData(
    useMaterial3: true,

colorScheme: ColorScheme.fromSeed(
      seedColor: primaryOrange,
brightness: Brightness.light,
    ),

scaffoldBackgroundColor: const Color(0xFFF9FAFB),

fontFamily: 'Roboto',

appBarTheme: const AppBarTheme(
      centerTitle: false,
elevation: 0,
scrolledUnderElevation: 0,
backgroundColor: Colors.white,
foregroundColor: Colors.black,
surfaceTintColor: Colors.transparent,
titleTextStyle: TextStyle(
        fontSize: 20,
fontWeight: FontWeight.w800,
color: Colors.black,
fontFamily: 'Roboto',
      ),
    ),

elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
foregroundColor: Colors.white,
minimumSize: const Size(double.infinity, 52),
elevation: 0,
shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
textStyle: const TextStyle(
          fontSize: 16,
fontWeight: FontWeight.w700,
        ),
      ),
    ),

inputDecorationTheme: InputDecorationTheme(
      filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
vertical: 16,
      ),
border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
          color: Colors.grey.shade300,
width: 1.2,
        ),
      ),
enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
          color: Colors.grey.shade300,
width: 1.2,
        ),
      ),
focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
          color: primaryOrange,
width: 2,
        ),
      ),
errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
          color: Colors.red.shade400,
width: 1.2,
        ),
      ),
focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
borderSide: BorderSide(
          color: Colors.red.shade700,
width: 2,
        ),
      ),
prefixIconColor: primaryOrange,
suffixIconColor: Colors.grey.shade600,
labelStyle: TextStyle(
        color: Colors.grey.shade700,
fontSize: 14,
fontWeight: FontWeight.w500,
      ),
floatingLabelStyle: const TextStyle(
        color: primaryOrange,
fontWeight: FontWeight.w600,
      ),
hintStyle: TextStyle(
        color: Colors.grey.shade400,
fontSize: 14,
      ),
    ),

floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
foregroundColor: Colors.white,
    ),

navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
indicatorColor: lightOrange,
labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

cardTheme: CardThemeData(
      color: Colors.white,
elevation: 0,
margin: EdgeInsets.zero,
shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
side: BorderSide(
          color: Colors.grey.shade200,
width: 1,
        ),
      ),
    ),

chipTheme: ChipThemeData(
      backgroundColor: lightOrange,
selectedColor: primaryOrange,
labelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
