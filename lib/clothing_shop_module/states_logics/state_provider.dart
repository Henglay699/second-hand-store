import 'package:clothing_shop/clothing_shop_module/states_logics/gridview_logic.dart';
import 'package:clothing_shop/clothing_shop_module/states_logics/theme_logic.dart';
import 'package:clothing_shop/clothing_shop_module/views/state_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget stateProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
      ChangeNotifierProvider(create: (context) => GridviewLogic()),
    ],
    child: StateApp(),
  );
}