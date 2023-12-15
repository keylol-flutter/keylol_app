import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/bloc/settings/settings_cubit.dart';
import 'package:keylol_flutter/repository/settings_repository.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.homePageDrawerListTileSettings),
      ),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: colorScheme.background,
          settingsSectionBackground: colorScheme.surfaceVariant,
          dividerColor: colorScheme.background,
          titleTextColor: colorScheme.secondary,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: colorScheme.background,
          settingsSectionBackground: colorScheme.surfaceVariant,
          dividerColor: colorScheme.background,
          titleTextColor: colorScheme.secondary,
        ),
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile.switchTile(
                initialValue:
                    context.read<SettingsRepository>().getEnableDebug(),
                onToggle: (value) {
                  setState(() {
                    context.read<SettingsRepository>().setEnableDebug(value);
                    context.read<SettingsCubit>().update();
                  });
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
