
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../provider/theme_provider.dart';

class MyToast {
  static Future<void> show(
    String msg, {
    ToastType? toastType = ToastType.defaultType,
  }) {
    return SmartDialog.showToast(
      '',
      displayType: SmartToastType.onlyRefresh,
      builder: (_) => CustomToast(
        msg,
        toastType: toastType,
      ),
    );
  }
}

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {super.key, this.toastType});

  final String msg;

  final ToastType? toastType;

  @override
  Widget build(BuildContext context) {
    return defaultBuild(context);
  }


  defaultBuild(BuildContext context) {
    final theme = myListenTheme(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 20,
          maxWidth: MediaQuery.of(context).size.width - 80,
          maxHeight: 200,
        ),
        child: Container(
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: theme.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            // 阴影
            boxShadow: [
              BoxShadow(
                color: theme.white.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Text(msg, textAlign: TextAlign.center, softWrap: true, maxLines: 3, style: TextStyle(fontSize: 13, color: theme.white),),
        ),
      ),
    ).margin(const EdgeInsets.only(bottom: 100, top: 100));
  }
}

enum ToastType {
  defaultType,
  success,
  fail,
}
