import 'package:app/models/provider_details.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Schedule({super.key, required this.data, required this.formKey});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Schedule Screen'),
    );
  }
}