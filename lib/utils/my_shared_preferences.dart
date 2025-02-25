import 'package:shared_preferences/shared_preferences.dart';
import '../provider/theme_provider.dart';

class MySharedPreferences {
  static late SharedPreferences prefs;

  /// 初始化(最好在main中调用)
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 语言环境
  static const String languageCodeKey = 'language_code';

  // 主题
  static const String themeKey = 'theme_key';

  // 钱包密码
  static const String walletPasswordKey = 'wallet_password';


  static Future<String?> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageCodeKey);
  }

  static Future<bool> setLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(languageCodeKey, languageCode);
  }

  static String? getLanguageCodeSync() {
    return prefs.getString(languageCodeKey);
  }

  static setLanguageCodeSync(String languageCode) {
    prefs.setString(languageCodeKey, languageCode);
  }

  static Future<MyThemeType> getThemeType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (prefs.getString(themeKey)) {
      case 'light':
        return MyThemeType.light;
      case 'dark':
        return MyThemeType.dark;
      default:
        return MyThemeType.system;
    }
  }

  static Future<bool> setThemeType(MyThemeType theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (theme) {
      case MyThemeType.light:
        return prefs.setString(themeKey, 'light');
      case MyThemeType.dark:
        return prefs.setString(themeKey, 'dark');
      default:
        return prefs.setString(themeKey, 'system');
    }
  }

  static MyThemeType getThemeTypeSync() {
    switch (prefs.getString(themeKey)) {
      case 'light':
        return MyThemeType.light;
      case 'dark':
        return MyThemeType.dark;
      default:
        return MyThemeType.system;
    }
  }

  static void setThemeTypeSync(MyThemeType theme) {
    switch (theme) {
      case MyThemeType.light:
        prefs.setString(themeKey, 'light');
      case MyThemeType.dark:
        prefs.setString(themeKey, 'dark');
      default:
        prefs.setString(themeKey, 'system');
    }
  }


  // 获取钱包密码
  static Future<String?> getWalletPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(walletPasswordKey);
  }

  // 设置钱包密码
  static Future<bool> setWalletPassword(String password,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(walletPasswordKey, password);
  }

}
