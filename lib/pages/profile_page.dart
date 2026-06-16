import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFEF),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1E6A68),
      ),
      body: const Center(child: Text('Profile Page')),
    );
  }
}
