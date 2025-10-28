import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool dark = false;
  bool biometric = true;
  int autoLock = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(value: dark, onChanged: (v) => setState(() => dark = v), title: Text('Dark theme')),
            SwitchListTile(value: biometric, onChanged: (v) => setState(() => biometric = v), title: Text('Enable biometric')),
            ListTile(title: Text('Auto-lock'), subtitle: Text('$autoLock min'), onTap: () {}),
            ListTile(title: Text('Language'), subtitle: Text('EN / HI'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
