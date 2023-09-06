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
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  void didUpdateWidget(SelectableButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style ??
          ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Theme.of(context).textTheme.displayMedium!.color!;
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.12);
                }
                return null; // defer to the defaults
              },
            ),
          ),
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}
