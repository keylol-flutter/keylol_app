import 'dart:async';

import 'package:flutter/material.dart';

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
  final SearchController _controller = SearchController();
  Timer? _timer;

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
          suggestionsCompleter
              .complete(await widget.suggestionsBuilder(context, controller));
        });

        final suggestions = await suggestionsCompleter.future;
        return suggestions;
      },
    );
  }
}
