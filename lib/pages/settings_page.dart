import 'package:flutter/material.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: "Configurações", children: [
      SwitchSettingsTile(settingKey: 'opc_show_photo', title: 'Exibir foto?'),
      MaterialColorPickerSettingsTile(
          settingKey: 'opc_color', title: 'Cor principal')
    ]);
  }
}
