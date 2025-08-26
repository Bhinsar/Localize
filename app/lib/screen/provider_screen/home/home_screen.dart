import 'package:app/api/auth/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {

  final _authService = AuthApi();

  Future<void> _logout() async {
    await _authService.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Provider Screen'),
      ),
    );
  }
}