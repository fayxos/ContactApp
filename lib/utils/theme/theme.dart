import 'package:contact_app/utils/theme/widget_themes/appbar_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/chip_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:contact_app/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: CustomColors.grey,
    brightness: Brightness.light,
    primaryColor: CustomColors.primary,
    textTheme: CustomTextTheme.lightTextTheme,
    chipTheme: CustomChipTheme.lightChipTheme,
    scaffoldBackgroundColor: CustomColors.white,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: CustomColors.grey,
    brightness: Brightness.dark,
    primaryColor: CustomColors.primary,
    textTheme: CustomTextTheme.darkTextTheme,
    chipTheme: CustomChipTheme.darkChipTheme,
    scaffoldBackgroundColor: CustomColors.black,
    appBarTheme: CustomAppBarTheme.darkAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: CustomBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
  );
}
