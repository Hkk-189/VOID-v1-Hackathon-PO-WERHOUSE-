import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final bool demoMode;
  const AuthScreen({super.key, required this.demoMode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _username = '';
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register / Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (v) => _name = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (v) => _username = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onSaved: (v) => _phone = v ?? '',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter phone' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // TODO: trigger OTP flow and registration. For demoMode, skip OTP.
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }
}
