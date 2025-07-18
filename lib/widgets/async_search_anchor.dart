import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keylol_flutter/config/logger.dart';

class AsyncSearchAnchor extends StatefulWidget {
  final SearchAnchorChildBuilder searchAnchorChildBuilder;
  final bool allowEmpty;
  final SuggestionsBuilder suggestionsBuilder;

  const AsyncSearchAnchor({
    super.key,
    this.allowEmpty = false,
    required this.searchAnchorChildBuilder,
    required this.suggestionsBuilder,
  });

  @override
  State<StatefulWidget> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<AsyncSearchAnchor> {
  late final SearchController _controller;
  Timer? _timer;

  @override
  void initState() {
    _controller = SearchController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _controller,
      builder: widget.searchAnchorChildBuilder,
      suggestionsBuilder: (context, controller) async {
        final text = controller.text;

        if (text.isEmpty && !widget.allowEmpty) {
          return [];
        }

        if (_timer != null) {
          _timer!.cancel();
        }

        final suggestionsCompleter = Completer<Iterable<Widget>>();
        _timer = Timer(const Duration(milliseconds: 300), () async {
          try {
            final suggestions =
                await widget.suggestionsBuilder(context, controller);
            suggestionsCompleter.complete(suggestions);
          } catch (error, stackTrace) {
            talker.error('SearchAnchor error', error, stackTrace);
            suggestionsCompleter.completeError(error);
          }
        });

        try {
          return await suggestionsCompleter.future;
        } catch (_) {
          return [];
        }
      },
    );
  }
}
