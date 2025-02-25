
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../provider/theme_provider.dart';
import '../utils/my_assets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = myThemeProvider(context);
    return AnnotatedRegion(
      value: provider.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark, // 设置状态栏字体颜色为亮色,
      child: Scaffold(
        body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            // physics: (_currentIndex == 0 ? const NeverScrollableScrollPhysics() : null), // 禁止滑动
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Container(),
              Container(),
            ]),
        bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ), child: getNavigationBar()),
      ),
    );
  }

  BottomNavigationBar getNavigationBar({int totalUnReadCount = 0}) {
    final theme = myListenTheme(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      backgroundColor: theme.white,
      // selectedItemColor: theme.secondaryColor,
      // unselectedItemColor: theme.primaryColor,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: theme.grey,
      selectedFontSize: 13,
      unselectedFontSize: 13,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _currentPage,
      onTap: (int index) {
        setState(() {
          print("index = $index , current = $_currentPage");
          _currentPage = index;
          _pageController.jumpToPage(index);
        });
      },
      items: getNavigationBarItems(totalUnReadCount: totalUnReadCount),
    );
  }

  List<BottomNavigationBarItem> getNavigationBarItems(
      {int totalUnReadCount = 0}) {
    final theme = myListenTheme(context);
    final unreadWidget = totalUnReadCount > 0
        ? Container(
      width: 14,
      height: 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "${totalUnReadCount > 99 ? "99+" : "$totalUnReadCount"}",
        style: TextStyle(color: Colors.white, fontSize: 6),
      ),
    )
        : null;
    final List<Map> barDataList = [
      {
        "title": "员工",
        "selectImage": _getBarIcon(
            icon: Icons.list_alt,
            iconColor: theme.primaryColor,
            badge: unreadWidget),
        "image": _getBarIcon(
            icon: Icons.list_alt,
            iconColor: theme.grey,
            badge: unreadWidget),
      },
      {
        "title": "记录",
        "selectImage": _getBarIcon(
            icon: Icons.perm_contact_calendar_outlined,
            iconColor: theme.primaryColor,
            badge: unreadWidget),
        "image": _getBarIcon(
            icon: Icons.perm_contact_calendar_outlined,
            iconColor: theme.grey,
            badge: unreadWidget),
      },
    ];
    return barDataList
        .map((item) => BottomNavigationBarItem(
      icon: item["image"],
      activeIcon: item["selectImage"],
      label: item["title"],
    )).toList();
  }


  Widget _getBarIcon({IconData? icon, Color iconColor = Colors.black, double imageSize = 24, Widget? badge}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: (32 - imageSize) / 2,
            child: Icon(icon, size: imageSize, color: iconColor,),
          ),
          if (badge != null)
            Positioned(
              right: 0,
              top: 0,
              child: badge,
            ),
        ],
      ),
    );
  }


}
