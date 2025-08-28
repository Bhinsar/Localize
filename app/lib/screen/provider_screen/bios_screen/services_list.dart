import 'package:app/models/provider_details.dart';
import 'package:flutter/material.dart';

class ServicesList extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;

  const ServicesList({super.key, required this.data, required this.formKey});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Services List Screen'),
    );
  }
}