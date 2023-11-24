import 'dart:async';

import 'package:flutter/material.dart';

class AsyncSearchAnchor extends StatefulWidget {
  final Widget? barLeading;
  final Iterable<Widget>? barTrailing;

  final bool allowEmpty;
  final SuggestionsBuilder suggestionsBuilder;

  const AsyncSearchAnchor({
    super.key,
    this.barLeading,
    this.barTrailing,
    this.allowEmpty = false,
    required this.suggestionsBuilder,
  });

  @override
  State<StatefulWidget> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<AsyncSearchAnchor> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barLeading: widget.barLeading,
      barTrailing: widget.barTrailing,
      barBackgroundColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
      ),
      barPadding: const MaterialStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
      barElevation: MaterialStateProperty.all(0),
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
