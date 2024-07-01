import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF5C11D4);
 List<Color> _colorThemes = [
  Colors.white,
  Colors.black,

  Colors.blue,
  Colors.orange,
  Colors.green,
  _customColor
];

class AppTheme {
  final int selectColors;

  AppTheme({required this.selectColors})
      : assert(selectColors >= 0 && selectColors <= _colorThemes.length, 'Index Color${_colorThemes.length}');
  ThemeData theme() {
    return ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: _colorThemes[selectColors],
        
        
        );
  }
}
