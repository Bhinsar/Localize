import 'dart:developer';

import 'package:app/api/services/service_api.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/models/services.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ServicesList extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;

  const ServicesList({super.key, required this.data, required this.formKey});

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  Services _selectedServices = Services();
  final List<Services> _availableServices = [];
  final List<Services> _filteredServices = [];
  bool _isLoading = true;

  final _serviceApi = ServiceApi();

  @override
  void initState() {
    super.initState();
    _fetchAvailableServices();
  }

  Future<void> _fetchAvailableServices() async {
    try {
      final services = await _serviceApi.fetchServices();
      if (services != null && !services.containsKey('error')) {
        setState(() {
          _availableServices.addAll(
            (services['services'] as List)
                .map((e) => Services.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
          _filteredServices.addAll(_availableServices);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      log('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context)!;
    final d = Dimensions(context);
    // FIX 1: Wrap the content in a Form widget and attach the formKey.
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: d.width10,
          vertical: d.height20,
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10.whatservicedoyouprovide,
                    style: TextStyle(
                      fontSize: d.font24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10.selectThePrimaryServiceYouWantToOfferToCustomers,
                    style: TextStyle(fontSize: d.font18),
                  ),
                  SizedBox(height: d.height20),
                  Expanded(
                    child: FormField<Services>(
                      initialValue: widget.data.service != null
                          ? _availableServices.firstWhere(
                              (service) =>
                                  service.id.toString() ==
                                  widget.data.service,
                              orElse: () => Services(),
                            )
                          : null,
                      validator: (value) {
                        if (value == null ||
                            value.id == null ||
                            value.id!.isEmpty) {
                          return l10.pleaseEnterServiceName;
                        }
                        return null;
                      },
                      builder: (FormFieldState<Services> field) {
                        // FIX 2: Display the error text from the validator.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 12,
                                ),
                                child: Text(
                                  l10.pleaseSelectAService,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: d.font15,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: _filteredServices.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 8.0),
                                itemBuilder: (context, index) {
                                  final service = _filteredServices[index];
                                  final isSelected =
                                      widget.data.service == service;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color ??
                                                Colors.blue
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: RadioListTile<String?>(
                                      title: Semantics(
                                        label: '${service.name} service',
                                        child: Text(
                                          service.name as String,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color ??
                                                      Colors.black,
                                          ),
                                        ),
                                      ),
                                      value: service.id.toString(),
                                      groupValue: widget.data.service?.id,
                                      activeColor:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color ??
                                          Colors.blue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedServices = value != null
                                              ? service
                                              : Services();
                                          widget.data.service = _selectedServices;
                                        });
                                        field.didChange(_selectedServices);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
