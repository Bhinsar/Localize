import 'package:app/models/provider_details.dart';
import 'package:flutter/material.dart';

class Price extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Price({super.key, required this.data, required this.formKey});

  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Price Screen'),
    );
  }
}
