import 'package:flutter_ume_kit_console/console/console_manager.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

class FlutterUmeConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final message = event.lines.join('\n');
    ConsoleManager.streamController?.add(message);
  }
}
