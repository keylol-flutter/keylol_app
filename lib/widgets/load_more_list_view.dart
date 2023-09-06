import 'package:flutter/material.dart';

class LoadMoreListView extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final NullableIndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final int itemCount;
  final Function callback;

  const LoadMoreListView({
    super.key,
    this.padding,
    this.physics,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
    required this.callback,
  });

  @override
  State<StatefulWidget> createState() => _LoadMoreListViewState();
}

class _LoadMoreListViewState extends State<LoadMoreListView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final pixels = _controller.position.pixels;

      if (maxScroll == pixels) {
        widget.callback();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: widget.padding,
      physics: widget.physics,
      controller: _controller,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: widget.separatorBuilder,
      itemCount: widget.itemCount,
    );
  }
}
