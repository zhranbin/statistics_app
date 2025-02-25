import 'package:flutter/material.dart';
import 'package:statistics_app/utils/extensions/widget_extensions.dart';

import '../provider/theme_provider.dart';

class MyBottomSelectDialog extends StatelessWidget {
  final String? title;
  final TextStyle? titleTextStyle;
  final String? content;
  final TextStyle? contentTextStyle;
  final bool isShowCancel;
  final String? cancelText;
  final TextStyle? cancelTextStyle;
  final List<MyBottomSelectDialogAction> actions;

  const MyBottomSelectDialog({
    super.key,
    this.title,
    this.titleTextStyle,
    this.content,
    this.contentTextStyle,
    this.isShowCancel = true,
    this.cancelText,
    this.cancelTextStyle,
    required this.actions,
  });

  static Future show(
      BuildContext context, {
        String? title,
        TextStyle? titleTextStyle,
        String? content,
        TextStyle? contentTextStyle,
        bool? isShowCancel,
        String? cancelText,
        TextStyle? cancelTextStyle,
        required List<MyBottomSelectDialogAction> actions,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return MyBottomSelectDialog(
          title: title,
          titleTextStyle: titleTextStyle,
          content: content,
          contentTextStyle: contentTextStyle,
          isShowCancel: isShowCancel ?? true,
          cancelText: cancelText,
          cancelTextStyle: cancelTextStyle,
          actions: actions,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = myListenTheme(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getTitleAndContent(context),
          if (title != null || content != null)  Divider(color: theme.backgroundColor, height: 1,),
          ...actions.map((action) {
            return _getActionItem(context, action);
          }),
          if (isShowCancel) Container(color: theme.backgroundColor, height: 6,),
          if (isShowCancel) GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 48,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
                  color: theme.white,
                  child: Text(cancelText ?? '取消',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: cancelTextStyle ??
                        const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.normal,
                        ),
                  )
              )
          ),
          Container(color: theme.white, height: MediaQuery.of(context).padding.bottom,)
        ],
      ),
    );
  }

  Widget _getTitleAndContent(BuildContext context) {
    final theme = myListenTheme(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null) Text(title!,
              textAlign: TextAlign.center,
              style: titleTextStyle ??
                  TextStyle(
                    fontSize: 16,
                    color: theme.textColor,
                    fontWeight: FontWeight.w600,
                  )),
          if (content != null && title != null) const SizedBox(height: 10,),
          if (content != null) Text(content!,
              textAlign: TextAlign.center,
              style: contentTextStyle ??
                  TextStyle(
                    fontSize: 14,
                    color: theme.textGrey,
                    fontWeight: FontWeight.normal,
                  )),
        ],
      ),
    );
  }


  Widget _getActionItem(BuildContext context, MyBottomSelectDialogAction action) {
    final theme = myListenTheme(context);
    return GestureDetector(
        onTap: (){
          Navigator.pop(context);
          action.onTap?.call();
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.only(left: 16, right: 16),
          color: theme.white,
          child: Column(
            children: [
              Expanded(
                child: Text(action.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: action.textStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: theme.textColor,
                          fontWeight: FontWeight.normal,
                        )).center(),
              ),
              Divider(color: theme.backgroundColor, height: 1,),
            ],
          ),
        )
    );
  }
}

class MyBottomSelectDialogAction {
  final String title;
  final TextStyle? textStyle;
  final VoidCallback? onTap;

  const MyBottomSelectDialogAction({
    required this.title,
    this.textStyle,
    this.onTap,
  });
}
