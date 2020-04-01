import 'package:flutter/material.dart';

class PageModel {
  final Color backgroundColor;
  final String heroAssetPath;
  final Color heroAssetColor;
  final Widget title;
  final Widget body;
  final String iconAssetPath;
  final Color iconAssetColor;
  final Color bubbleColor;

  PageModel({
    @required this.backgroundColor,
    @required this.heroAssetPath,
    this.heroAssetColor,
    this.title,
    this.body,
    @required this.iconAssetPath,
    this.iconAssetColor,
    this.bubbleColor = const Color(0x88FFFFFF),
  })  : assert(title != null),
        assert(body != null),
        assert(backgroundColor != null),
        assert(heroAssetPath != null),
        assert(iconAssetPath != null);
}
