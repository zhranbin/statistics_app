import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/my_shared_preferences.dart';

MyTheme myListenTheme(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen).theme;
}

MyTheme myTheme() {
  return Provider.of<ThemeProvider>(MyApp.context, listen: false).theme;
}

ThemeProvider myThemeProvider(BuildContext context, {bool listen = true}) {
  return Provider.of<ThemeProvider>(context, listen: listen);
}

ThemeProvider getMyThemeProvide() {
  return Provider.of<ThemeProvider>(MyApp.context, listen: false);
}


class ThemeProvider extends ChangeNotifier {
  final MyTheme _lightTheme = const MyTheme(id: "light");
  final MyTheme _darkTheme = const MyTheme(
    id: "dark",
    primaryColor: Color(0xFF06B3F3),
    secondaryColor: Color(0xFF067DF3),
    backgroundColor: Color(0xFF252525),
    backgroundColorWhite: Color(0xFF1A1A1A),
    textColor: Colors.white,
    white: Colors.black,
    black: Colors.white,
    textGrey: Color(0xFF5C5B5B),
    inputFillColor: Color(0xFF0B0B0B),
    appbarBgColor: Color(0xFF0a0a0a),
    appbarTextColor: Colors.white,
    f4f4f4: Color(0xFF0B0B0B),
    text999 : Color(0xFF777777),
    e9e9e9 : Color(0xFF171717),
    d7d7d7 : Color(0xFF292929),
    text282109 : Color(0XFFd8def7),
    textFFD867 : Color(0xff0028a9),
    textFB8B04 : Color(0xFF0585fc),
  );

  MyTheme get theme => _getTheme();

  MyThemeType _type = MyThemeType.system;
  MyThemeType get type => _type;

  String _themeId = "light";
  String get themeId => _themeId;

  bool get isDark => _themeId == "dark";

  void changeTheme(MyThemeType type) {
    _type = type;
    switch (type) {
      case MyThemeType.light:
        _themeId = "light";
        break;
      case MyThemeType.dark:
        _themeId = "dark";
        break;
      default:
        final brightness = MediaQuery.platformBrightnessOf(MyApp.context);
        bool isDarkMode = brightness == Brightness.dark;
        _themeId = isDarkMode ? "dark" : "light";
        break;
    }
    MySharedPreferences.setThemeType(type);
    notifyListeners();
  }

  MyTheme getTheme(BuildContext context) {
    switch (_type) {
      case MyThemeType.light:
        return _lightTheme;
      case MyThemeType.dark:
        return _darkTheme;
      default:
        final brightness = MediaQuery.platformBrightnessOf(context);
        bool isDarkMode = brightness == Brightness.dark;
        return isDarkMode ? _darkTheme : _lightTheme;
    }
  }

  MyTheme _getTheme() {
    switch (_type) {
      case MyThemeType.light:
        return _lightTheme;
      case MyThemeType.dark:
        return _darkTheme;
      default:
        final brightness = MediaQuery.platformBrightnessOf(MyApp.context);
        bool isDarkMode = brightness == Brightness.dark;
        return isDarkMode ? _darkTheme : _lightTheme;
    }
  }
}

enum MyThemeType { light, dark, system }

class MyTheme {
  const MyTheme({
    // id
    this.id = 'default',
    /// 应用主色
    this.primaryColor = const Color(0xFF06B3F3),
    /// 应用次色
    this.secondaryColor = const Color(0xFF067DF3),
    /// 背景颜色
    this.backgroundColor = const Color(0xFFFBFBFB),
    /// 背景颜色纯白
    this.backgroundColorWhite = const Color(0xFFFFFFFF),
    /// 灰色
    this.grey = const Color(0xFFE2E2E2),
    /// 字色
    this.textColor = const Color(0xFF333333),
    /// 灰色文本
    this.textGrey = const Color(0xFFB4B5B5),
    /// 输入框背景色
    this.inputFillColor = const Color(0xFFF4F4F4),
    this.white = Colors.white,
    this.black = Colors.black,
    /// Appbar 背景颜色
    this.appbarBgColor = const Color(0xFFF2F3F5),
    /// Appbar 文字颜色
    this.appbarTextColor = const Color(0xFF010000),
    /// 错误颜色
    this.errorColor = const Color(0xFFEB5757),
    this.f4f4f4 = const Color(0xFFF4F4F4),
    this.text999 = const Color(0xFF999999),
    this.e9e9e9 = const Color(0xFFe9e9e9),
    this.d7d7d7 = const Color(0xFFd7d7d7),
    this.text282109 = const Color(0XFF282109),
    this.textFFD867 = const Color(0xffFFD867),
    this.textFB8B04 = const Color(0xFFFB8b04),
  });

  final String id;
  /// 应用主色
  final Color primaryColor;
  /// 应用次色
  final Color secondaryColor;
  /// 背景颜色
  final Color backgroundColor;
  /// 背景颜色纯白
  final Color backgroundColorWhite;
  /// 灰色
  final Color grey;
  /// 字色
  final Color textColor;
  /// 灰色文本
  final Color textGrey;
  /// 输入框背景色
  final Color inputFillColor;
  /// 白色
  final Color white;
  /// 黑色
  final Color black;
  /// Appbar 背景颜色
  final Color appbarBgColor;
  /// Appbar 文字颜色
  final Color appbarTextColor;
  /// 错误颜色
  final Color errorColor;
  /// f4f4f4
  final Color f4f4f4;
  /// text999
  final Color text999;
  /// e9e9e9
  final Color e9e9e9;
  final Color d7d7d7;
  final Color text282109;
  final Color textFFD867;
  final Color textFB8B04;
}


