
import 'package:flutter/cupertino.dart';

extension WidgetExtension on Widget {
  Widget addPadding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget margin(EdgeInsetsGeometry margin) {
    return Container(
      margin: margin,
      child: this,
    );
  }

  Widget width(double width) {
    return SizedBox(
      width: width,
      child: this,
    );
  }

  Widget height(double height) {
    return SizedBox(
      height: height,
      child: this,
    );
  }

  Widget size(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget onTap(Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }



}



class _KeepAliveWrapper extends StatefulWidget {
  const _KeepAliveWrapper({
    required this.child,
  });
  final Widget child;

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(covariant _KeepAliveWrapper oldWidget) {
    if (oldWidget.keepAlive != widget.keepAlive) {
      // keepAlive 状态需要更新，实现在 AutomaticKeepAliveClientMixin 中
      updateKeepAlive();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool get wantKeepAlive => true;
}

extension WidgetKeepAlive on Widget {
  Widget get keepAlive {
    return _KeepAliveWrapper(child: this);
  }
}