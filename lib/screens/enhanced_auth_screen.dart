import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../providers/app_state.dart';
import '../utils/localization.dart';

class EnhancedAuthScreen extends StatefulWidget {
  final bool demoMode;
  const EnhancedAuthScreen({super.key, required this.demoMode});

  @override
  State<EnhancedAuthScreen> createState() => _EnhancedAuthScreenState();
}

class _EnhancedAuthScreenState extends State<EnhancedAuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isRegistering = true;
  bool _otpSent = false;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.sender;
  String? _generatedOtp; // For demo mode
  int _resendTimer = 0;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
    _animController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final otp = await AuthService.sendOtp(_phoneController.text);
      if (widget.demoMode) {
        _generatedOtp = otp;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demo OTP: $otp'), duration: Duration(seconds: 5)),
        );
      }
      
      setState(() {
        _otpSent = true;
        _isLoading = false;
      });
      _startResendTimer();
      
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.speak('OTP sent successfully');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to send OTP: $e');
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!AuthService.verifyOtp(_otpController.text)) {
      _showError('Invalid or expired OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await AuthService.register(
        name: _nameController.text,
        username: _usernameController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        role: _selectedRole,
      );

      final appState = Provider.of<AppState>(context, listen: false);
      appState.setUser(user);
      await appState.speak('Registration successful');

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Registration failed: $e');
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthService.loginOffline(
        _usernameController.text,
        _passwordController.text,
      );

      if (user == null) {
        _showError('Invalid credentials');
        setState(() => _isLoading = false);
        return;
      }

      final appState = Provider.of<AppState>(context, listen: false);
      appState.setUser(user);
      await appState.speak('Login successful');

      Navigator.of(context).pushReplacementNamed('/dashboard');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Login failed: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.language;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering 
          ? AppLocalizations.translate('register', lang)
          : AppLocalizations.translate('login', lang)),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              appState.setLanguage(lang == 'en' ? 'hi' : 'en');
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isRegistering) ..._buildRegistrationFields(lang)
                else ..._buildLoginFields(lang),
                
                SizedBox(height: 24),
                
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  _buildActionButton(lang),
                
                SizedBox(height: 16),
                
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegistering = !_isRegistering;
                      _otpSent = false;
                      _formKey.currentState?.reset();
                    });
                  },
                  child: Text(_isRegistering
                    ? 'Already have an account? ${AppLocalizations.translate('login', lang)}'
                    : 'Don\'t have an account? ${AppLocalizations.translate('register', lang)}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRegistrationFields(String lang) {
    return [
      // Role selection
      Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.translate('select_role', lang),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<UserRole>(
                      title: Text(AppLocalizations.translate('sender', lang)),
                      value: UserRole.sender,
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<UserRole>(
                      title: Text(AppLocalizations.translate('receiver', lang)),
                      value: UserRole.receiver,
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 16),
      
      // Name field
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('name', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
        enabled: !_otpSent,
      ),
      SizedBox(height: 16),
      
      // Username field
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('username', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.account_circle),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
        enabled: !_otpSent,
      ),
      SizedBox(height: 16),
      
      // Phone field
      TextFormField(
        controller: _phoneController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('phone', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.phone),
        ),
        keyboardType: TextInputType.phone,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Enter phone';
          if (v.length != 10) return 'Enter valid 10-digit phone';
          return null;
        },
        enabled: !_otpSent,
      ),
      SizedBox(height: 16),
      
      // Password field
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('password', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        ),
        obscureText: true,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Enter password';
          if (v.length < 6) return 'Password must be at least 6 characters';
          return null;
        },
        enabled: !_otpSent,
      ),
      SizedBox(height: 16),
      
      // Confirm password field
      TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('confirm_password', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Confirm password';
          if (v != _passwordController.text) return 'Passwords do not match';
          return null;
        },
        enabled: !_otpSent,
      ),
      
      if (_otpSent) ...[
        SizedBox(height: 16),
        TextFormField(
          controller: _otpController,
          decoration: InputDecoration(
            labelText: AppLocalizations.translate('otp', lang),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.sms),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: (v) => (v == null || v.length != 6) ? 'Enter 6-digit OTP' : null,
        ),
        if (_resendTimer > 0)
          Text('Resend OTP in $_resendTimer seconds', textAlign: TextAlign.center)
        else
          TextButton(
            onPressed: _sendOtp,
            child: Text(AppLocalizations.translate('resend_otp', lang)),
          ),
      ],
    ];
  }

  List<Widget> _buildLoginFields(String lang) {
    return [
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('username', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.account_circle),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Enter username' : null,
      ),
      SizedBox(height: 16),
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: AppLocalizations.translate('password', lang),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        ),
        obscureText: true,
        validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
      ),
    ];
  }

  Widget _buildActionButton(String lang) {
    if (_isRegistering) {
      if (!_otpSent) {
        return ElevatedButton.icon(
          onPressed: _sendOtp,
          icon: Icon(Icons.send),
          label: Text(AppLocalizations.translate('send_otp', lang)),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            textStyle: TextStyle(fontSize: 16),
          ),
        );
      } else {
        return ElevatedButton.icon(
          onPressed: _register,
          icon: Icon(Icons.check),
          label: Text(AppLocalizations.translate('register', lang)),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            textStyle: TextStyle(fontSize: 16),
          ),
        );
      }
    } else {
      return ElevatedButton.icon(
        onPressed: _login,
        icon: Icon(Icons.login),
        label: Text(AppLocalizations.translate('login', lang)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
          textStyle: TextStyle(fontSize: 16),
        ),
      );
    }
  }
}
