import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:statistics_app/pages/main_page.dart';

import 'provider/theme_provider.dart';
import 'utils/my_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化绑定
  // 禁止横屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);
  await MySharedPreferences.init();
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader();
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter();

  runApp(MultiProvider(
    providers: [
      //可以多个provider进行分类处理
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: MyApp(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static BuildContext get context => navigatorKey.currentState!.context;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    // 监听系统事件
    WidgetsBinding.instance.addObserver(this);
    // DBHelper.delete(accountDbTableName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final MyThemeType themeType = MySharedPreferences.getThemeTypeSync();
      myThemeProvider(context, listen: false).changeTheme(themeType);
    });
  }

  @override
  void dispose() {
    // 取消监听系统事件
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    debugPrint("主题模式发生改变");
    // 亮度变化（主题模式发生改变也会）时的处理逻辑
    super.didChangePlatformBrightness();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) {
        return;
      }
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      if (provider.type == MyThemeType.system) {
        debugPrint("通知改变系统主题");
        provider.changeTheme(MyThemeType.system);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MyTheme theme = myThemeProvider(context).getTheme(context);
    // 隐藏状态栏背景
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: theme.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        home: const MainPage(),
        locale: Locale('zh', 'CN'), // 简体中文
        builder: (BuildContext context, Widget? child) {
          return FlutterSmartDialog.init().call(context, child);
        },
      ),
    );
  }
}
