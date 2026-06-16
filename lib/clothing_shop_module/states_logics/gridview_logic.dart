import 'package:flutter/material.dart';

class GridviewLogic extends ChangeNotifier {
  bool _isGridView = true;

  bool get isGridView => _isGridView;

  void toggleGridView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

}