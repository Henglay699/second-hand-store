import 'package:clothing_shop/clothing_shop_module/states_logics/theme_logic.dart';
import 'package:clothing_shop/clothing_shop_module/views/product_detail_screen.dart';
import 'package:clothing_shop/clothing_shop_module/views/main_screen.dart';
import 'package:clothing_shop/clothing_shop_module/views/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class StateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color seedColor = Colors.black;
    Color secondColor = Colors.purple;

    final appBarTheme = AppBarTheme(
      backgroundColor: seedColor,
      foregroundColor: Colors.white,
    );

    final floatingTheme = FloatingActionButtonThemeData(
      backgroundColor: secondColor,
      foregroundColor: Colors.white,
    );

    bool isDark = context.watch<ThemeLogic>().isDark;

    return MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: .fromSeed(seedColor: seedColor),
        appBarTheme: appBarTheme,
        floatingActionButtonTheme: floatingTheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: .fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: appBarTheme,
        floatingActionButtonTheme: floatingTheme,
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => MainScreen());
          case "detail":
            return PageTransition(
              type: PageTransitionType.rightToLeft,
              childCurrent: this as Widget,
              fullscreenDialog: true,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: ClothDetailScreen(),
            );
          case "settings":
            return PageTransition(
              type: PageTransitionType.rightToLeft,
              childCurrent: this as Widget,
              fullscreenDialog: true,
              settings: settings,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: SettingScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  Scaffold(body: Center(child: Text("No Page Found"))),
            );
        }
      },
    );
  }
}
