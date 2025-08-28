import 'package:app/models/provider_details.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Address({super.key, required this.data, required this.formKey});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Address Screen'),
    );
  }
}