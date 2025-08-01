import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppAboutPage extends StatefulWidget {
  const AppAboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppAboutPageState();
}

class _AppAboutPageState extends State<AppAboutPage> {
  late Future<PackageInfo> _future;

  @override
  void initState() {
    _future = PackageInfo.fromPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapShot) {
        if (!snapShot.hasData || snapShot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final packageInfo = snapShot.data!;

        return AboutPage(
          title: Text(AppLocalizations.of(context)!.aboutPageTitle),
          applicationName: AppLocalizations.of(context)!.title,
          applicationVersion: packageInfo.version,
          applicationIcon: Image.asset(
            'images/launcher_icon.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          applicationDescription:
              Text(AppLocalizations.of(context)!.aboutPageDescription),
          children: [
            LicensesPageListTile(
              title: Text(AppLocalizations.of(context)!.aboutPageLicense),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.aboutPageGithub),
              onTap: () {
                launchUrlString('https://github.com/keylol-flutter/keylol_app');
              },
            )
          ],
        );
      },
    );
  }
}
