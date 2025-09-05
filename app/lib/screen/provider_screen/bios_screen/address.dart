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
  late final CameraPosition _kInitialPosition;

  LatLng? _currentMapCenter;
  final TextEditingController _addressDisplayController =
      TextEditingController();
  bool _isFetchingAddress = false;

  @override
  void initState() {
    super.initState();

    bool hasInitialLocation =
        widget.data.location.latitude != 0.0 &&
        widget.data.location.longitude != 0.0;

    _kInitialPosition = CameraPosition(
      target: hasInitialLocation
          ? LatLng(
              widget.data.location.latitude,
              widget.data.location.longitude,
            )
          : const LatLng(26.9124, 75.7873),
      zoom: hasInitialLocation ? 16.0 : 12.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
      _getAddressFromLatLng(_kInitialPosition.target);
    });
  }

  @override
  void dispose() {
    _addressDisplayController.dispose();
    super.dispose();
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Location Services Disabled"),
        content: const Text("Please enable location services in settings."),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Open Settings"),
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
    final serviceStatus = await Permission.location.serviceStatus;
    if (!serviceStatus.isEnabled) {
      debugPrint("Location services are disabled.");
      _showEnableLocationDialog();
      return;
    }

    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPosition = LatLng(position.latitude, position.longitude);
      _moveCameraToPosition(newPosition);
    } catch (e) {
      debugPrint("Error getting current location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not get current location.")),
      );
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
    if (!mounted) return;

    setState(() {
      _isFetchingAddress = true;
      _currentMapCenter = position;
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
          _addressDisplayController.text = address;
        }
      }
    } catch (e) {
      if (mounted) {
        _addressDisplayController.text = "Could not fetch address";
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingAddress = false;
        });
      }
    }
  }

  void _onCameraIdle() {
    if (_currentMapCenter != null) {
      _getAddressFromLatLng(_currentMapCenter!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Form(
        key: widget.formKey,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (c) => _controller.complete(c),
              onCameraMove: (position) => _currentMapCenter = position.target,
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
              child: _buildConfirmationContainer(),
            ),
            Positioned(
              bottom: 200, // Adjust as needed
              right: 10,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationContainer() {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SELECT YOUR WORKING LOCATION",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressDisplayController,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                ),
                border: InputBorder.none,
                hintText: 'Select a location on the map',
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              validator: (value) {
                if (widget.data.location.latitude == null ||
                    widget.data.location.longitude == null ||
                    widget.data.location.address == null) {
                  return 'Please select a valid location on the map.';
                }
                return null;
              },
              onSaved: (value) {
                if (_currentMapCenter != null) {
                  widget.data.location.latitude = _currentMapCenter!.latitude;
                  widget.data.location.longitude = _currentMapCenter!.longitude;
                  widget.data.location.address = value;
                }
              },
            ),
            if (_isFetchingAddress)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.formKey.currentState!.validate()) {
                    widget.formKey.currentState!.save();
                  }
                },
                child: const Text("Confirm Location"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
