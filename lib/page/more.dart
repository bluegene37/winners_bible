import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:winners_bible/page/notes_hl_page.dart';
import 'package:winners_bible/page/settings_page.dart';
import '../main.dart';

class MoreMenu extends StatefulWidget {
  const MoreMenu({Key? key}) : super(key: key);

  @override
  MoreMenuState createState() => MoreMenuState();
}

class MoreMenuState extends State<MoreMenu> {
  bool status = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Menu'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                value: const Text('All settings'),
                onPressed: (context){
                  // Get.to(const SettingsLocalPage());
                  barTitle.value = 'Settings';
                  pages[0] = const SettingsLocalPage();
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.brush_outlined),
                title: const Text('Highlights'),
                value: const Text('All Highlights'),
                onPressed: (context){
                  // Get.to(const HiLightPage());
                  barTitle.value = 'Highlights';
                  pages[0] = const NotesHLScreen();
                },
              ),
            ],
          ),
        ],
      ),
      ),
    // ),
  );
}

