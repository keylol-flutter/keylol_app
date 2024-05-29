import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.logPageTitle),
      ),
      body: FutureBuilder<List<String>>(
        future: _loadLogFiles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final logFiles = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, index) {
              final logFile = logFiles[index];
              return ListTile(
                title: Text(logFile),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/log',
                    arguments: {'logFile': logFile},
                  );
                },
              );
            },
            itemCount: logFiles.length,
          );
        },
      ),
    );
  }

  Future<List<String>> _loadLogFiles() async {
    var directory = await getApplicationDocumentsDirectory();
    directory = Directory('${directory.path}/log');

    final logFiles = directory.listSync();
    return logFiles.map((file) => file.path.split('/').last).toList();
  }
}

class LogFilePage extends StatefulWidget {
  final String fileName;

  const LogFilePage({super.key, required this.fileName});

  @override
  State<StatefulWidget> createState() => _LogFilePageState();
}

class _LogFilePageState extends State<LogFilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: FutureBuilder<String>(
        future: _loadLogContent(widget.fileName),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return Text(snapshot.data!);
        },
      ),
    );
  }

  Future<String> _loadLogContent(String logFileName) async {
    var directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/log/$logFileName');
    if (!(await file.exists())) {
      return '';
    }

    return await file.readAsString();
  }
}
