import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../provider/theme_provider.dart';

class MyAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.backgroundColor,
    this.title = '',
    this.leftWidget,
    this.rightWidget,
    this.backgroundWidget,
    this.customTitle,
    this.navigationBarHeight = 44,
    this.backIconCenter = false,
    this.elevation = 1,
    this.customTitleAlignment = Alignment.center,
    this.hasTop = true,
  });

  final Color? backgroundColor;
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Widget? backgroundWidget;
  final Widget? customTitle;
  final double navigationBarHeight;
  final bool backIconCenter;
  // 阴影
  final double elevation;
  final Alignment? customTitleAlignment;
  // 是否留出顶部（状态栏的高度）
  final bool hasTop;

  @override
  Widget build(BuildContext context) {
    final bool isBack = ModalRoute.of(context)?.canPop ?? false;
    final double statusBarHeight = hasTop ? MediaQuery.of(context).padding.top : 10;
    final double width = MediaQuery.of(context).size.width;
    final brightness = MediaQuery.platformBrightnessOf(context);
    bool isDarkMode = brightness == Brightness.dark;
    final themeType = myThemeProvider(context).type;
    if (themeType == MyThemeType.light) {
      isDarkMode = false;
    } else if (themeType == MyThemeType.dark) {
      isDarkMode = true;
    }
    final Color bgColor =
        backgroundColor ?? (isDarkMode ? Colors.black : Colors.white);
    final Color titleColor = isDarkMode ? Colors.white : Colors.black;
    const backBtnW = 24.0 + 16;

    final Widget back = leftWidget??(isBack
        ? Container(
          width: backBtnW,
          height: 44.0,
          color: Colors.transparent,
          child: IconButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final isBack = await Navigator.maybePop(context);
                if (!isBack) {
                  await SystemNavigator.pop();
                }
              },
              tooltip: 'Back',
              padding: const EdgeInsets.only(left: 16),
              icon: Icon(CupertinoIcons.arrow_left, color: titleColor,),
            ),
        )
        : Container());

    return Container(
      height: statusBarHeight + navigationBarHeight,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: elevation==0?[]:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: elevation,
            blurRadius: 10,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          if (backgroundWidget != null) Positioned.fill(child: backgroundWidget!),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(
                  height: statusBarHeight,
                ),
                Container(
                  color: Colors.transparent,
                  height: navigationBarHeight,
                  width: width,
                  child: Stack(
                    children: [
                      (customTitle != null) ? Align(alignment:customTitleAlignment??Alignment.center,child:
                      customTitle!,) : Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: width - backBtnW*2,
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(left: 0, top: 0,bottom: backIconCenter?0:null, child: back),
                      Positioned(right: 0, top: 0, bottom: 0, child: rightWidget ?? Container()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(navigationBarHeight);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor =
        CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ??
            CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}
