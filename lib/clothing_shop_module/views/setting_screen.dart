import 'package:clothing_shop/clothing_shop_module/states_logics/gridview_logic.dart';
import 'package:clothing_shop/clothing_shop_module/states_logics/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final logo =
        "https://tse1.mm.bing.net/th/id/OIP.xKKJpZJfIPIFXx2dIKph5QHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3";
    bool isDark = context.watch<ThemeLogic>().isDark;
    bool isGridView = context.watch<GridviewLogic>().isGridView;

    return Scaffold(
      appBar: AppBar(title: Text("Setting Screen")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Image.network(logo, height: 200),
          Divider(),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text("Switch to ${isDark ? "Light" : "Dark"} Mode"),
              trailing: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              onTap: () => context.read<ThemeLogic>().changeTheme(),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.style),
              title: Text("Switch to ${isGridView ? "List" : "Grid"} View"),
              trailing: Icon(isGridView ? Icons.view_list : Icons.grid_view),
              onTap: () => context.read<GridviewLogic>().toggleGridView(),
            ),
          ),
        ],
      ),
    );
  }
}
