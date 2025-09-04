import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/screen/provider_screen/bios_screen/address.dart';
import 'package:app/screen/provider_screen/bios_screen/price.dart';
import 'package:app/screen/provider_screen/bios_screen/profile.dart';
import 'package:app/screen/provider_screen/bios_screen/schedule.dart';
import 'package:app/screen/provider_screen/bios_screen/services_list.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BiosScreen extends StatefulWidget {
  const BiosScreen({super.key});

  @override
  State<BiosScreen> createState() => _BiosScreenState();
}

class _BiosScreenState extends State<BiosScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final ProviderDetails providerDetails = ProviderDetails();

  // Each key must be attached to a Form widget in the corresponding page.
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<IconData> _icons = [
    Icons.camera_roll_sharp,
    Icons.person,
    Icons.currency_rupee,
    Icons.schedule,
    Icons.location_on,
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ServicesList(data: providerDetails, formKey: _formKeys[0]),
      Profile(data: providerDetails, formKey: _formKeys[1]),
      Price(data: providerDetails, formKey: _formKeys[2]),
      Schedule(data: providerDetails, formKey: _formKeys[3]),
      AddressScreen(data: providerDetails, formKey: _formKeys[4]),
    ];
  }

  // It's important to dispose of controllers to prevent memory leaks.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState?.validate() ?? false) {
      if (_currentPage < _pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
         print(providerDetails.toJson());
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image.asset(
          "assets/images/app_bar_logo.PNG",
          width: d.width * 0.30,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(d.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: (_currentPage + 1) / _pages.length,
                backgroundColor: Colors.grey[300],
                color: const Color.fromARGB(255, 50, 116, 52),
                minHeight: 6,
              ),
              SizedBox(height: d.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_icons.length, (i) {
                  Color circleColor;
                  IconData icon;

                  if (i < _currentPage) {
                    circleColor = const Color.fromARGB(
                      255,
                      50,
                      116,
                      52,
                    ); // Green
                    icon = Icons.check;
                  } else if (i == _currentPage) {
                    circleColor = const Color.fromARGB(
                      255,
                      50,
                      116,
                      52,
                    ); // Green
                    icon = _icons[i];
                  } else {
                    circleColor = const Color.fromARGB(
                      255,
                      197,
                      197,
                      197,
                    ); // Grey
                    icon = _icons[i];
                  }

                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: d.width * 0.05,
                    ),
                  );
                }),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: _pages,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0 ? _previousPage : null,
                    child: Text(
                      l10.back,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: _currentPage < _pages.length - 1
                        ? Text(
                            l10.next,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          )
                        : Text(
                            l10.finish,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
