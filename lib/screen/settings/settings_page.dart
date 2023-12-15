import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            title: Text(AppLocalizations.of(context)!.settingsPageCommon),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.format_paint),
                title: Text(AppLocalizations.of(context)!
                    .settingsPageDynamicColorEnabled),
                initialValue:
                    context.read<SettingsRepository>().getEnableDynamicColor(),
                onToggle: (value) {
                  setState(() {
                    context
                        .read<SettingsRepository>()
                        .setEnableDynamicColor(value);
                  });
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.color_lens),
                title:
                    Text(AppLocalizations.of(context)!.settingsPageThemeColor),
                trailing: Builder(
                  builder: (context) {
                    final currentColor =
                        context.read<SettingsRepository>().getThemeColorValue();
                    return currentColor == null
                        ? const Icon(Icons.circle_outlined)
                        : Icon(
                            Icons.circle,
                            color: Color(currentColor),
                          );
                  },
                ),
                onPressed: (context) {
                  final currentColor =
                      context.read<SettingsRepository>().getThemeColorValue();
                  var tempColor = currentColor == null
                      ? Color(currentColor!)
                      : Theme.of(context).colorScheme.primary;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: ColorPicker(
                          pickerColor: tempColor,
                          onColorChanged: (color) {
                            tempColor = color;
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.confirm),
                            onPressed: () {
                              setState(() {
                                context
                                    .read<SettingsRepository>()
                                    .setThemeColor(tempColor.value);
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.monitor_heart),
                title:
                    Text(AppLocalizations.of(context)!.settingsPageEnableDebug),
                initialValue:
                    context.read<SettingsRepository>().getEnableDebug(),
                onToggle: (value) {
                  setState(() {
                    context.read<SettingsRepository>().setEnableDebug(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
