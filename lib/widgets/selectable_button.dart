import 'package:flutter/material.dart';

class SelectableButton extends StatefulWidget {
  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    this.onPressed,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _SelectedButton();
}

class _SelectedButton extends State<SelectableButton> {
  late final WidgetStatesController _statesController;
  late ButtonStyle _cachedStyle;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController(
        <WidgetState>{if (widget.selected) WidgetState.selected});
    _cachedStyle = _buildButtonStyle();
  }

  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _statesController.update(WidgetState.selected, widget.selected);
      _cachedStyle = _buildButtonStyle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: _statesController,
      style: _cachedStyle,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }

  ButtonStyle _buildButtonStyle() {
    return widget.style ??
        ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return Theme.of(context).textTheme.displayMedium!.color!;
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.12);
              }
              return null; // defer to the defaults
            },
          ),
        );
  }
}
