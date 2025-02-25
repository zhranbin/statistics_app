import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton {

  /// 渐变色按钮
  static Widget gradientColorButton({
    String text = "",
    required List<Color> colors,
    // 渐变开始方向
    AlignmentGeometry begin = Alignment.centerLeft,
    // 渐变结束方向
    AlignmentGeometry end = Alignment.centerRight,
    // 渐变颜色占比
    List<double>? stops,
    Widget? icon,
    Color? textColor,
    FontWeight? fontWeight,
    double? borderWidth,
    Color? borderColor,
    double? fontSize,
    double? cornerRadius,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
          stops: stops,
        ),
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        // 边框
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        padding: EdgeInsets.zero,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: icon,
                ),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 纯色按钮
  static Widget colorButton({
    String text = "",
    required Color color,
    Widget? icon,
    Color? textColor,
    FontWeight? fontWeight,
    double? borderWidth,
    Color? borderColor,
    double? fontSize,
    double? cornerRadius,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        // 边框
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
      ),
      child: CupertinoButton(
        onPressed: onPressed,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cornerRadius ?? 6),
        padding: EdgeInsets.zero,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: icon,
                ),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




  // 文字按钮
  static Widget textButton({
    String text = "",
    Color? textColor,
    FontWeight? fontWeight,
    double? fontSize,
    AlignmentGeometry alignment = Alignment.center,
    double? height,
    double? width,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: alignment,
        color: Colors.transparent,
        height: height,
        width: width ?? double.infinity,
        child: Text(text, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight,)),
      ),
    );
  }

}
