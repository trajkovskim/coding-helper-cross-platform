import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../components/common/dropdown.dart';
import '../../components/common/user_frame.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final accentColorOptions = ['purple', 'blue', 'red'];
  final applicationLanguageOptions = ['en', 'de', 'mk'];
  final themesOptions = ['light', 'dark'];
  final defaultLanguageOptions = ['java', 'javascript'];

  @override
  Widget build(BuildContext context) {
    final sharedContext = Provider.of<SharedContext>(context);
    final settings = sharedContext.appSettings;

    final tColors = getTranslation(context, 'colors');
    final tLanguages = getTranslation(context, 'languages');
    final tThemes = getTranslation(context, 'themes');
    final t = getTranslation(context, 'profile.settings');

    return Scaffold(
      appBar: AppBar(
        title: Text(t('title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserFrame(),
            VerticalListView(
              children: [
                ListItem(
                  title: t('accentColor'),
                  trailing: Dropdown(
                    value: settings?.accentColor,
                    onChange: sharedContext.setAccentColor,
                    items: accentColorOptions
                        .map((option) => DropdownItem(tColors(option), option))
                        .toList(),
                  ),
                ),
                ListItem(
                  title: t('defaultLanguage'),
                  trailing: Dropdown(
                    value: settings?.defaultLanguage,
                    onChange: sharedContext.setDefaultLanguage,
                    items: defaultLanguageOptions
                        .map(
                          (option) => DropdownItem(
                            option[0].toUpperCase() + option.substring(1),
                            option,
                          ),
                        )
                        .toList(),
                  ),
                ),
                ListItem(
                  title: t('theme'),
                  trailing: Dropdown(
                    value: settings?.theme,
                    onChange: sharedContext.setTheme,
                    items: themesOptions
                        .map((option) => DropdownItem(tThemes(option), option))
                        .toList(),
                  ),
                ),
                ListItem(
                  title: t('applicationLanguage'),
                  trailing: Dropdown(
                    value: settings?.locale,
                    onChange: sharedContext.setLocale,
                    items: applicationLanguageOptions
                        .map(
                          (option) => DropdownItem(tLanguages(option), option),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
