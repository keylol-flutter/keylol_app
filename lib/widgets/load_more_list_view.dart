import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keylol_flutter/config/logger_manager.dart';

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
  late final ScrollController _controller;
  bool _isLoading = false;
  Timer? _loadMoreTimer;

  @override
  void initState() {
    _controller = ScrollController();

    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final pixels = _controller.position.pixels;

      if (maxScroll == pixels && !_isLoading) {
        _isLoading = true;

        _loadMoreTimer = Timer(const Duration(milliseconds: 300), () {
          try {
            widget.callback();
          } catch (error, stackTrace) {
            talker.error('List load more error', error, stackTrace);
          } finally {
            _isLoading = false;
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _loadMoreTimer?.cancel();
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
