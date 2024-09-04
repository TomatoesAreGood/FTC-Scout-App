import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static late double defaultFontSize;
  static late double defaultTitleSize;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;

  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static bool isMobileLandscape = false;
  static bool isMobile = true;


  static void init(BoxConstraints constraints, Orientation orientation) {
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;
    
    if (orientation == Orientation.portrait) {
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      if(screenHeight < 450){
        isMobileLandscape = true;
      }
      isPortrait = false;
      isMobilePortrait = false;
    }

    isMobile = isMobileLandscape || isMobilePortrait;

    _blockWidth = screenWidth / 100;
    _blockHeight = screenHeight / 100;

    defaultTitleSize = isMobile ? 20 : _blockWidth * _blockHeight * 0.45;
    defaultFontSize = isMobile ? 15: _blockWidth * _blockHeight * 0.35;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    print("$screenHeight   $screenWidth");
  }
}