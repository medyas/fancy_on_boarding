import 'dart:ui';
import 'package:fancy_on_boarding/src/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;
  final bool isRtl;

  PagerIndicator({
    this.viewModel,
    this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel.pages.length; ++i) {
      final page = viewModel.pages[i];

      var percentActive;
      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        PageBubble(
          viewModel: PageBubbleViewModel(
            page.iconAssetPath,
            page.backgroundColor,
            isHollow,
            percentActive,
            bubbleColor: page.bubbleColor,
            iconColor: page.iconAssetColor,
          ),
        ),
      );
    }

    final bubbleWidth = 55.0;
    final width = MediaQuery
        .of(context)
        .size
        .width / 2;
    var translation =
        width - (viewModel.activeIndex * bubbleWidth) - (bubbleWidth / 2);
    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += bubbleWidth * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= bubbleWidth * viewModel.slidePercent;
    }

    return Transform(
      transform: Matrix4.translationValues(
          isRtl ? -translation : translation, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bubbles,
      ),
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(this.pages,
      this.activeIndex,
      this.slideDirection,
      this.slidePercent,);
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({
    this.viewModel,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 65.0,
      child: Center(
        child: Container(
          width: lerpDouble(20.0, 45.0, viewModel.activePercent),
          height: lerpDouble(20.0, 45.0, viewModel.activePercent),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? viewModel.bubbleColor
                .withAlpha((0x88 * viewModel.activePercent).round())
                : viewModel.bubbleColor,
            border: Border.all(
              color: viewModel.isHollow
                  ? viewModel.bubbleColor.withAlpha(
                  (0x88 * (1.0 - viewModel.activePercent)).round())
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: Opacity(
              opacity: viewModel.activePercent,
              child: _renderImageAsset(viewModel.iconAssetPath,
                  color: viewModel.iconColor ?? viewModel.color)),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;
  final Color iconColor;
  final Color bubbleColor;

  PageBubbleViewModel(this.iconAssetPath,
      this.color,
      this.isHollow,
      this.activePercent,
      {this.iconColor, this.bubbleColor});
}

Widget _renderImageAsset(String assetPath,
    {double width = 24, double height = 24, Color color = Colors.white}) {
  if (assetPath.toLowerCase().endsWith(".svg")) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        color: color,
        fit: BoxFit.contain,
      ),
    );
  } else {
    return Image.asset(
      assetPath,
      color: color,
      width: width,
      height: height,
    );
  }
}
