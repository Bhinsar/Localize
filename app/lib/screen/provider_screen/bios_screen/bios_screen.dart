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
  final pageController = PageController();
  int currentPage = 0;
  final ProviderDetails providerDetails = ProviderDetails();

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
    Icons.attach_money,
    Icons.schedule,
    Icons.location_on
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
      Address(data: providerDetails, formKey: _formKeys[4])
    ];
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
                value: (currentPage+1) / _pages.length,
                backgroundColor: Colors.grey[300],
                color: const Color.fromARGB(255, 50, 116, 52),
              ),
              SizedBox(height: d.height10/2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < _icons.length; i++)
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage < i+1 ? const Color.fromARGB(255, 197, 197, 197) : Color.fromARGB(255, 50, 116, 52),
                      ),
                      child: Icon(
                        currentPage < i+1
                            ? _icons[i]
                            : Icons.check, color:Colors.white,
                        size: d.width * 0.05,
                      ),
                    )
                ],
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: _pages,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text("Back", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),),
                    onPressed: currentPage > 0
                        ? () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    child: currentPage < _pages.length - 1 ? Text("Next", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),) : Text("Finish", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), ),
                    onPressed: currentPage < _pages.length - 1
                        ? () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
