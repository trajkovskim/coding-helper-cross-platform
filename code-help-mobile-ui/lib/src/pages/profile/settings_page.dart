import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/common/dropdown.dart';
import '../../components/common/user_frame.dart';
import '../../components/common/vertical_list_view.dart';
import '../../context/index.dart';
import '../../i18n/i18n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const UserFrame(),
              VerticalListView(
                children: [
                  ListItem(
                    title: t('accentColor'),
                    trailing: Dropdown(
                      value: settings?.accentColor,
                      onChange: (value) {
                        SharedPreferences.getInstance().then((storage) =>
                            storage.setString('accent-color', value!));
                        sharedContext.setAccentColor(value);
                      },
                      items: ACCENT_COLORS
                          .map(
                              (option) => DropdownItem(tColors(option), option))
                          .toList(),
                    ),
                  ),
                  ListItem(
                    title: t('defaultLanguage'),
                    trailing: Dropdown(
                      value: settings?.defaultLanguage,
                      onChange: (value) {
                        SharedPreferences.getInstance().then((storage) =>
                            storage.setString('default-language', value!));
                        sharedContext.setDefaultLanguage(value);
                      },
                      items: DEFAULT_LANGUAGES
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
                      onChange: (value) {
                        SharedPreferences.getInstance().then(
                            (storage) => storage.setString('theme', value!));
                        sharedContext.setTheme(value);
                      },
                      items: THEMES
                          .map(
                              (option) => DropdownItem(tThemes(option), option))
                          .toList(),
                    ),
                  ),
                  ListItem(
                    title: t('applicationLanguage'),
                    trailing: Dropdown(
                      value: settings?.locale,
                      onChange: (value) {
                        SharedPreferences.getInstance().then((storage) =>
                            storage.setString('locale', value!));
                        sharedContext.setLocale(value);
                      },
                      items: APPLICATION_LANGUAGES
                          .map(
                            (option) =>
                                DropdownItem(tLanguages(option), option),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
