import 'package:app/models/provider_details.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Profile({super.key, required this.data, required this.formKey});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}