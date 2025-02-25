import 'package:flutter/cupertino.dart';

import '../provider/theme_provider.dart';

const String imageAssets = "assets/images/";

class MyAssets {

  // 空数据
  static String emptyIcon(BuildContext context, {bool listen = false}) {
    final provider = myThemeProvider(context, listen: listen);
    if (provider.isDark) {
      return "${imageAssets}common/empty_data.png";
    }
    return "${imageAssets}common/empty_data.png";
  }

  // logo
  static String logo(BuildContext context, {bool listen = false}) {
    final provider = myThemeProvider(context, listen: listen);
    if (provider.isDark) {
      return "${imageAssets}common/logo.png";
    }
    return "${imageAssets}common/logo.png";
  }


}

