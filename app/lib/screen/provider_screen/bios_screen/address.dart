import 'dart:async';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressScreen extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const AddressScreen({super.key, required this.data, required this.formKey});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(26.9124, 75.7873), // Jaipur, Rajasthan
    zoom: 14.0,
  );

  LatLng? _currentMapCenter;
  String _currentAddress = "Select a location...";
  final TextEditingController _addressDisplayController =
      TextEditingController();
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();
    // It's safer to wait for the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  @override
  void dispose() {
    _addressDisplayController.dispose();
    super.dispose();
  }

  void _showEnableLocationDialog() {
    final l10 = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10.locationServicesDisabled),
        content: Text(l10.pleaseEnableLocationServices),
        actions: <Widget>[
          TextButton(
            child: Text(l10.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10.openSettings),
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    final l10 = AppLocalizations.of(context)!;

    final serviceStatus = await Permission.location.serviceStatus;
    if (!serviceStatus.isEnabled) {
      debugPrint("Location services are disabled.");
      setState(() => _currentAddress = l10.locationServicesDisabled);
      _showEnableLocationDialog();
      return;
    }

    var status = await Permission.location.status;
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      if (await Permission.location.request().isGranted) {
        _getCurrentLocation();
      } else {
        setState(() => _currentAddress = l10.locationPermissionDenied);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final l10 = AppLocalizations.of(context)!;
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPosition = LatLng(position.latitude, position.longitude);
      _moveCameraToPosition(newPosition);
    } catch (e) {
      debugPrint("Error getting current location: $e");
      setState(() => _currentAddress = l10.couldNotGetCurrentLocation);
    }
  }

  Future<void> _moveCameraToPosition(
    LatLng position, {
    double zoom = 16.0,
  }) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (_isFetchingAddress) return;
    setState(() {
      _isFetchingAddress = true;
    });

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final Placemark p = placemarks[0];
        final address =
            "${p.name}, ${p.subLocality}, ${p.locality}, ${p.postalCode}";
        if (mounted) {
          setState(() {
            _currentAddress = address;
            _addressDisplayController.text = address; // Sync display field
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _currentAddress = "Could not fetch address");
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingAddress = false;
        });
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapCenter = position.target;
     // Clear the text field while moving to indicate a new selection is in progress
    if (_addressDisplayController.text != 'Fetching address...') {
       _addressDisplayController.text = 'Fetching address...';
    }
  }

  void _onCameraIdle() {
    if (_currentMapCenter != null) {
      _getAddressFromLatLng(_currentMapCenter!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: d.width10,
        vertical: d.height20,
      ),
      // We wrap the entire map and confirmation box with the Form
      child: Form(
        key: widget.formKey,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (c) => _controller.complete(c),
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Icon(Icons.location_pin, size: 40.0, color: Colors.red),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildConfirmationContainer(d, l10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationContainer(Dimensions d, AppLocalizations l10) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          d.width20,
          d.height20,
          d.width20,
          d.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10.selectyourworkinglocation.toUpperCase(),
              style: TextStyle(
                fontSize: d.font12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: d.height10),
            TextFormField(
              controller: _addressDisplayController,
              readOnly: true, 
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on, color: const Color.fromARGB(255, 58, 117, 60)),
                border: InputBorder.none,
                hintText: 'Select a location on the map',
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              validator: (value) {
                if (_currentMapCenter == null || value == null || value.isEmpty) {
                  return 'Please select a location on the map.';
                }
                return null;
              },
              onSaved: (value) {
                if (_currentMapCenter != null) {
                  widget.data.location.latitude = _currentMapCenter!.latitude;
                  widget.data.location.longitude = _currentMapCenter!.longitude;
                  widget.data.location.address = _currentAddress;
                }
              },
            ),
            if (_isFetchingAddress)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(),
                ),
            SizedBox(height: d.height20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // **FIXED: Button now validates and saves the form**
                  if (widget.formKey.currentState!.validate()) {
                    widget.formKey.currentState!.save();
                    // You can add navigation or a success message here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Location Saved: Lat: ${widget.data.location.latitude}, Lng: ${widget.data.location.longitude}',
                        ),
                      ),
                    );
                    print('Confirmed Address: ${_currentAddress}');
                    print('Confirmed LatLng: ${_currentMapCenter}');
                  }
                },
                child: Text(l10.confirmlocation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}