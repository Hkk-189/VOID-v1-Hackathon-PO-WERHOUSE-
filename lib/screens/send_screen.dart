import 'package:flutter/material.dart';
import '../widgets/custom_keypad.dart';

class SendScreen extends StatefulWidget {
  final bool demoMode;
  const SendScreen({super.key, required this.demoMode});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  String _amount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send')),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Amount: $_amount', style: TextStyle(fontSize: 24)),
          Expanded(child: CustomKeypad(onChange: (s) => setState(() => _amount = s))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirm,
              child: Text('Confirm'),
            ),
          )
        ],
      ),
    );
  }

  void _confirm() {
    // TODO: show biometric + PIN flow before proceeding
    showDialog(context: context, builder: (_) => AlertDialog(title: Text('Confirm'), content: Text('Proceed to send $_amount?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')), TextButton(onPressed: () => Navigator.pop(context), child: Text('Send'))]));
  }
}
