import 'package:flutter/material.dart';
import 'send_screen.dart';
import 'receive_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final bool demoMode;
  const DashboardScreen({super.key, required this.demoMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SendScreen(demoMode: demoMode))), child: Text('Send')),
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReceiveScreen(demoMode: demoMode))), child: Text('Receive')),
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen())), child: Text('History')),
                ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())), child: Text('Settings')),
              ],
            ),
            SizedBox(height: 20),
            Text('Last Transaction: --', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10),
            Row(children: [Icon(Icons.sync), SizedBox(width: 8), Text('Sync status: Offline (demo)'),]),
            SizedBox(height: 20),
            Expanded(child: Center(child: Text('Main content / quick actions'))),
          ],
        ),
      ),
    );
  }
}
