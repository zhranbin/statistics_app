import 'package:flutter/material.dart';

import '../main.dart';

class MyRoute {
  static final List<String> pageHistory = [];

  /// 跳转到指定界面
  /// page: 跳转的页面
  /// context: 是用于执行导航的BuildContext。如果未提供，则使用MyApp的上下文。
  /// argument: 传递的参数
  /// tag: 跳转的页面的tag
  /// maintainState: 默认true
  /// fullscreenDialog: 默认false，类似iOS中的模态视图
  /// allowSnapshotting: 默认true
  /// barrierDismissible: 默认false
  static Future<T?> push<T>(
    Widget page, {
    BuildContext? context,
    Object? argument,
    String? tag,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) {
    RouteSettings settings;
    if (tag != null) {
      settings = RouteSettings(name: "${page.routerName()}#$tag", arguments: argument);
    } else {
      settings = RouteSettings(name: page.routerName(), arguments: argument);
    }
    return Navigator.push<T>(
      context ?? MyApp.context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible),
    );
  }

  /// 跳转到指定界面
  /// page: 跳转的页面
  /// context: 是用于执行导航的BuildContext。如果未提供，则使用MyApp的上下文。
  /// argument: 传递的参数
  /// tag: 跳转的页面的tag
  /// maintainState: 默认true
  /// fullscreenDialog: 默认false，类似iOS中的模态视图
  /// allowSnapshotting: 默认true
  /// barrierDismissible: 默认false
  static Future<T?> pushNotRepeat<T>(
    Widget page, {
    required BuildContext context,
    Object? argument,
    String? tag,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) async {
    RouteSettings settings;
    if (tag != null) {
      settings = RouteSettings(name: "${page.routerName()}#$tag", arguments: argument);
    } else {
      settings = RouteSettings(name: page.routerName(), arguments: argument);
    }
    // return popToRouteName(page.routerName());
    // return pushReplacement(page);

    if (pageHistory.contains(page.routerName())) {
      final ModalRoute<Object?>? route = ModalRoute.of(context);
      final String? currentRouteName = route?.settings.name;
      pageHistory.contains(currentRouteName) ? pageHistory.remove(currentRouteName) : null;

      Navigator.popUntil(context, (route) {
        return route.settings.routerName() == page.routerName();
      });

      Future.delayed(const Duration(milliseconds: 100),(){
        pageHistory.contains(page.routerName()) ? null : pageHistory.add(page.routerName());
      });
      var result = await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => page,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            allowSnapshotting: allowSnapshotting,
            barrierDismissible: barrierDismissible),
      );
      pageHistory.contains(page.routerName()) ? pageHistory.remove(page.routerName()) : null;
      return result;
    } else {
      pageHistory.contains(page.routerName()) ? null : pageHistory.add(page.routerName());
      var pushResult = await Navigator.push<T>(
        context,
        MaterialPageRoute(
            builder: (context) => page,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            allowSnapshotting: allowSnapshotting,
            barrierDismissible: barrierDismissible),
      );
      pageHistory.contains(page.routerName()) ? pageHistory.remove(page.routerName()) : null;
      return pushResult;
    }
  }

  /// 使用指定的页面替换当前页面，并导航到新页面。
  static pushReplacement(
    Widget page, {
    BuildContext? context,
    Object? argument,
    String? tag,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) {
    RouteSettings settings;
    if (tag != null) {
      settings = RouteSettings(name: "${page.routerName()}#$tag", arguments: argument);
    } else {
      settings = RouteSettings(name: page.routerName(), arguments: argument);
    }
    Navigator.pushReplacement(
      context ?? MyApp.context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          allowSnapshotting: allowSnapshotting,
          barrierDismissible: barrierDismissible),
    );
  }

  /// 跳转到指定页面
  /// routeName: 跳转的页面的routeName
  static Future<T?> pushNamed<T>(
    String routeName, {
    BuildContext? context,
    Object? argument,
  }) {
    return Navigator.pushNamed<T>(
      context ?? MyApp.context,
      routeName,
      arguments: argument,
    );
  }

  /// 返回上一个页面
  static pop<T extends Object?>({BuildContext? context, T? result}) {
    Navigator.pop(context ?? MyApp.context, result);
  }

  /// 返回上一个页面并携带数据
  /// data: 返回的数据
  static popWithData<T extends Object?>(T? result, {BuildContext? context}) {
    Navigator.pop(context ?? MyApp.context, result);
  }

  /// 返回到根页面
  static popToRoot({BuildContext? context}) {
    Navigator.popUntil(context ?? MyApp.context, (route) {
      // print("tag - ${route.settings.tag()} - isFirst - ${route.isFirst}");
      // print("${(route as MaterialPageRoute).builder}");
      return route.isFirst;
    });
  }

  /// 返回到指定页面
  static popUntil(BuildContext? context, bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(context ?? MyApp.context, predicate);
  }

  /// 返回到指定页面(routeName)x
  static popToRouteName(String routeName, {BuildContext? context}) {
    Navigator.popUntil(context ?? MyApp.context, (route) {
      return route.settings.routerName() == routeName;
    });
  }

  /// 返回到指定页面(tag)
  static popToTag({required String tag, BuildContext? context}) {
    Navigator.popUntil(context ?? MyApp.context, (route) {
      return route.settings.tag() == tag;
    });
  }

  /// 返回到指定页面(routeName)和(tag)
  static popToRouteNameWithTag(String routeName, String tag, {BuildContext? context}) {
    Navigator.popUntil(context ?? MyApp.context, (route) {
      return route.settings.routerName() == routeName && route.settings.tag() == tag;
    });
  }
}

extension ABWidget on Widget {
  String routerName() {
    return (this).toString();
  }
}

extension ABRouteSettings on RouteSettings {
  String routerName() {
    return name?.split("#").first ?? "";
  }

  String tag() {
    final data = name?.split("#") ?? [];
    if (data.length > 1) {
      return data[1];
    }
    return "";
  }
}
