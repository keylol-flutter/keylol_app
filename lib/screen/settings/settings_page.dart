import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/repository/config_repository.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.homePageDrawerListTileSettings),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile.switchTile(
                initialValue: context.read<ConfigRepository>().getEnableDebug(),
                onToggle: (value) {
                  context.read<ConfigRepository>().setEnableDebug(value);
                },
                leading: const Icon(Icons.monitor_heart),
                title:
                    Text(AppLocalizations.of(context)!.settingsPageEnableDebug),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
