import 'package:flutter/material.dart';

Size boundingTextSize(String text, TextStyle style,
    {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
  final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines)
    ..layout(maxWidth: maxWidth);
  return textPainter.size;
}

class ThreadAppBar extends SliverPersistentHeaderDelegate {
  final String title;
  final TextStyle textStyle;
  final double width;

  final double titleHeight;
  final double topPadding;

  ThreadAppBar({
    required this.title,
    required this.textStyle,
    required this.width,
    required this.topPadding,
  }) : titleHeight =
            boundingTextSize(title, textStyle, maxWidth: width - 32.0).height;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    double toolbarOpacity = maxExtent == minExtent
        ? 0.0
        : ((maxExtent - minExtent - shrinkOffset) / (maxExtent - minExtent))
            .clamp(0.0, 1.0);

    final title = toolbarOpacity == 0.0 ? Text(this.title) : null;
    return AppBar(
      title: title,
      flexibleSpace: Container(
        margin: EdgeInsets.only(top: kToolbarHeight + topPadding),
        child: Stack(
          children: [
            Positioned(
              top: -shrinkOffset,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 20),
                width: width,
                child: Text(this.title, style: textStyle),
              ),
            )
          ],
        ),
      ),
      actions: const [],
    );
  }

  @override
  double get maxExtent => kToolbarHeight + topPadding + titleHeight + 20;

  @override
  double get minExtent => kToolbarHeight + topPadding;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
