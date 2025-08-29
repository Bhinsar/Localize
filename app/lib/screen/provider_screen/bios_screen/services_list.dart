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
  final List<Services> _selectedServices = [];
  final List<Services> _availableServices = [];
  final List<Services> _filteredServices = [];

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
        });
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context)!;
    final d = Dimensions(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: d.width10,
        vertical: d.height20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10.whatservicedoyouprovide,
            style: TextStyle(fontSize: d.font24, fontWeight: FontWeight.bold),
          ),
          Text(
            l10.selectThePrimaryServiceYouWantToOfferToCustomers,
            style: TextStyle(fontSize: d.font18),
          ),
          SizedBox(height: d.height20),
          Form(
            key: widget.formKey,
            child: Column(
              children: [
                ..._filteredServices.map((service) {
                  final isSelected = _selectedServices.contains(service);
                  return CheckboxListTile(
                    title: Text(service.name as String),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedServices.add(service);
                        } else {
                          _selectedServices.remove(service);
                        }
                        widget.data.service_id = _selectedServices
                            .map((s) => s.id)
                            .toList()
                            .toString();
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
