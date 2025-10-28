import 'package:flutter/material.dart';

class ReceiveScreen extends StatelessWidget {
  final bool demoMode;
  const ReceiveScreen({super.key, required this.demoMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receive')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.nfc, size: 64), SizedBox(height: 12), Text('Waiting for incoming payment... (demo)')])),
    );
  }
}
