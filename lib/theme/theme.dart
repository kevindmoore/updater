
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme.freezed.dart';

const themeKey = 'ThemeKey';
enum Themes { seaFoam, softBlue, sunset, deepBlue, dark }

@freezed
class ThemeColors with _$ThemeColors {
  const factory ThemeColors(
      {required Color startGradientColor,
      required Color endGradientColor,
      required Color textColor,
      required Color inverseTextColor,
      }) = _ThemeColors;
}

class ThemeManager extends StateNotifier<ThemeColors> {
  final SharedPreferences prefs;

  ThemeManager(this.prefs) : super(seafoamTheme) {
    if (prefs.containsKey(themeKey)) {
      final themeName = prefs.getString(themeKey);
      final theme =
          Themes.values.firstWhereOrNull((theme) => theme.name == themeName);
      if (theme != null) {
        setTheme(theme);
      }
    }
  }

  void setThemeColor(ThemeColors theme) {
    state = theme;
    var themeName = Themes.seaFoam.name;
    if (theme == softBlueTheme) {
      themeName = Themes.softBlue.name;
    } else if (theme == sunsetTheme) {
      themeName = Themes.sunset.name;
    } else if (theme == deepBlueTheme) {
      themeName = Themes.deepBlue.name;
    } else if (theme == darkTheme) {
      themeName = Themes.dark.name;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: state.startGradientColor,
    ));
    prefs.setString(themeKey, themeName);
  }

  void setTheme(Themes theme) {
    switch (theme) {
      case Themes.seaFoam:
        state = seafoamTheme;
        break;
      case Themes.softBlue:
        state = softBlueTheme;
        break;
      case Themes.sunset:
        state = sunsetTheme;
        break;
      case Themes.deepBlue:
        state = deepBlueTheme;
        break;
      case Themes.dark:
        state = darkTheme;
        break;
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: state.startGradientColor,
    ));
    prefs.setString(themeKey, theme.name);
  }
}

var smallGreyText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color(0xFFBDBDBD),
);

var smallBlackText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color(0xFF353535),
);

var mediumBlackText = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: Color(0xFF353535),
);

var smallBlueText = const TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color(0xFF524FEC),
);

var titleBlackText = const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
var titleText = TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: blackBorderColor);
var largeBlackText = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

TextStyle getMediumTextStyle(Color textColor) {
  return TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor);
}
TextStyle getSmallTextStyle(Color textColor) {
  return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor);
}
Color dividerColor = const Color(0xFFE4E4E4);
Color lightBlueColor = const Color(0xFF524FEC);
Color lightGreyColor = const Color(0xFF797979);
Color blackBorderColor = const Color(0xFF353535);

ThemeColors seafoamTheme = const ThemeColors(
    startGradientColor: Color(0xFFACD7FE), endGradientColor: Color(0xFFCEF5C7), textColor: Colors.white, inverseTextColor: Colors.black);

ThemeColors deepBlueTheme = const ThemeColors(
    startGradientColor: Color(0xFF2C93F1), endGradientColor: Color(0xFF1465AE), textColor: Colors.white, inverseTextColor: Colors.black);

ThemeColors softBlueTheme = const ThemeColors(
    startGradientColor: Color(0xFFC7D3F3), endGradientColor: Color(0xFFA1BAF6), textColor: Colors.white, inverseTextColor: Colors.black);
ThemeColors sunsetTheme = const ThemeColors(
    startGradientColor: Color(0xFFF9B9B9), endGradientColor: Color(0xFFFDC27D), textColor: Colors.white, inverseTextColor: Colors.black);
ThemeColors darkTheme = const ThemeColors(
    startGradientColor: Color(0xFF545454), endGradientColor: Color(0xFF232323), textColor: Colors.white, inverseTextColor: Colors.black);



BoxDecoration createGradient(ThemeColors theme) {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [theme.startGradientColor, theme.endGradientColor]),
  );
}

BoxDecoration createSimiRoundedBorder() {
  return const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0),
      topRight: Radius.circular(6.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(4.0),
    ),
  );
}


BoxDecoration createWhiteBorder() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
            blurRadius: 16.0,
            offset: const Offset(0.0, 4.0),
            color: Colors.black.withOpacity(0.1))
      ]);
}

BoxDecoration createBlackBorderedBox() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(6.0),
    border: Border.all(color: blackBorderColor),
  );
}

RoundedRectangleBorder createWhiteRoundedBorder() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
    side: const BorderSide(width: 1, color: Color(0xFFE0E0E0)),
  );
}

InputDecoration createTextBorder(String hint, IconButton? endingButton) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: endingButton
  );
}
