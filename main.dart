import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Auth System',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Initialize the official authentication tool
  final LocalAuthentication auth = LocalAuthentication();
  String _statusMessage = 'Please log in to continue';
  bool _isAuthenticating = false;

  // 2. The Core Hardware Function
  Future<void> _authenticate() async {
    bool authenticated = false;
    
    setState(() {
      _isAuthenticating = true;
      _statusMessage = 'Checking scanner...';
    });

    try {
      // 3. Ask the device: Do you even have a scanner?
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _statusMessage = 'Hardware Error: Scanner not found on this device.';
          _isAuthenticating = false;
        });
        return;
      }

      // 4. Trigger the native popup
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your face or fingerprint to log in',
      );
      
    } catch (e) { 
      // 5. Catch ANY errors (including the web browser crash)
      setState(() {
        _statusMessage = "System Error: Cannot activate scanner here.";
        _isAuthenticating = false;
      });
      return;
    }

    if (!mounted) return;

    // 6. Update the screen based on the result
    setState(() {
      _isAuthenticating = false;
      if (authenticated) {
        _statusMessage = 'Unlock Successful! Welcome.';
      } else {
        _statusMessage = 'Scan Failed or Canceled.';
      }
    });
  }

  // 7. The Visual Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 100,
              color: _statusMessage.contains('Welcome') ? Colors.green : Colors.blueAccent,
            ),
            const SizedBox(height: 30),
            
            const Text(
              'Face Auth System',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _statusMessage.contains('Error') 
                    ? Colors.redAccent 
                    : (_statusMessage.contains('Welcome') ? Colors.green : Colors.grey),
              ),
            ),
            const SizedBox(height: 50),
            
            ElevatedButton.icon(
              onPressed: _isAuthenticating ? null : _authenticate,
              icon: _isAuthenticating 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.face, size: 24),
              label: Text(_isAuthenticating ? 'Scanning...' : 'Scan Face', style: const TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}