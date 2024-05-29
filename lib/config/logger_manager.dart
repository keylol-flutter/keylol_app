import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerManager {
  final Logger _logger;

  LoggerManager._(this._logger);

  static LoggerManager? _instance;

  static LoggerManager getInstance() {
    assert(_instance != null);
    return _instance!;
  }

  static Future<void> initial() async {
    var directory = await getApplicationDocumentsDirectory();
    directory = Directory('${directory.path}/log');

    /// 删除7天之前文件
    final deletedDateInt = int.parse(formatDate(
        DateTime.now().subtract(const Duration(days: 7)), [yyyy, mm, dd]));
    final logFiles = directory.listSync();
    for (final file in logFiles) {
      final fileDateInt =
          int.parse(file.path.split('/').last.replaceFirst('.log', ''));
      if (fileDateInt < deletedDateInt) {
        await file.delete();
      }
    }

    final fileName = '${formatDate(DateTime.now(), [yyyy, mm, dd])}.log';
    var file = File('${directory.path}/$fileName');
    if (!(await file.exists())) {
      await file.create();
    }

    final ilogger = Logger(
      printer: HybridPrinter(PrettyPrinter()),
      output: MultiOutput([
        FileOutput(file: file),
        ConsoleOutput(),
      ]),
    );

    _instance = LoggerManager._(ilogger);
  }

  static void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.t(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }

  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.d(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }

  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.i(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }

  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.w(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }

  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.e(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }

  static void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    getInstance()._logger.f(
          message,
          time: time,
          error: error,
          stackTrace: stackTrace,
        );
  }
}
