import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
    return BlocBuilder<SettingsCubit, DateTime>(builder: (context, _) {
      final enableDynamicColor =
          context.read<SettingsRepository>().getEnableDynamicColor();
      final currentColorValue =
          context.read<SettingsRepository>().getThemeColorValue();
      var currentColor = currentColorValue == null
          ? Theme.of(context).colorScheme.primary
          : Color(currentColorValue);

      return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.homePageDrawerListTileSettings),
        ),
        body: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: colorScheme.surface,
            settingsSectionBackground: colorScheme.surfaceContainerHighest,
            dividerColor: colorScheme.surface,
            titleTextColor: colorScheme.secondary,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: colorScheme.surface,
            settingsSectionBackground: colorScheme.surfaceContainerHighest,
            dividerColor: colorScheme.surface,
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
                  initialValue: enableDynamicColor,
                  onToggle: (value) {
                    setState(() {
                      context
                          .read<SettingsRepository>()
                          .setEnableDynamicColor(value);
                    });
                  },
                ),
                if (!enableDynamicColor)
                  SettingsTile.navigation(
                    leading: const Icon(Icons.color_lens),
                    title: Text(
                        AppLocalizations.of(context)!.settingsPageThemeColor),
                    trailing: Builder(
                      builder: (context) {
                        return Material(
                          shape: const CircleBorder(),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: currentColor,
                          ),
                        );
                      },
                    ),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: MaterialColorPicker(
                              colors: Colors.primaries,
                              allowShades: false,
                              selectedColor: currentColor,
                              onMainColorChange: (color) {
                                setState(() {
                                  currentColor = color as Color;
                                });
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                child:
                                    Text(AppLocalizations.of(context)!.confirm),
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<SettingsRepository>()
                                        .setThemeColor(currentColor.value);
                                    Navigator.of(context).pop();
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
                SettingsTile.navigation(
                  leading: const Icon(Icons.library_books),
                  title: Text(AppLocalizations.of(context)!.settingsPageLog),
                  onPressed: (context) {
                    Navigator.of(context).pushNamed('/log');
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.info),
                  title: Text(AppLocalizations.of(context)!.settingsPageAbout),
                  onPressed: (context) {
                    Navigator.of(context).pushNamed('/about');
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
