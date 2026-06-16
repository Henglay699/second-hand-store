import 'package:clothing_shop/clothing_shop_module/views/about_us.dart';
import 'package:clothing_shop/clothing_shop_module/views/product_screen.dart';
import 'package:clothing_shop/clothing_shop_module/views/seacrh_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: ClothScreen(),
          item: ItemConfig(
            icon: Icon(Icons.home),
            title: "Home",
            activeForegroundColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        PersistentTabConfig(
          screen: ClothSearchScreen(),
          item: ItemConfig(
            icon: Icon(Icons.search),
            title: "Search",
            activeForegroundColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        PersistentTabConfig(
          screen: AboutUsScreen(),
          item: ItemConfig(
            icon: Icon(Icons.info),
            title: "About Us",
            activeForegroundColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        itemAnimationProperties: ItemAnimation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
