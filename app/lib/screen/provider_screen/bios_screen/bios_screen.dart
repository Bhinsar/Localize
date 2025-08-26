import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BiosScreen extends StatefulWidget {
  const BiosScreen({super.key});

  @override
  State<BiosScreen> createState() => _BiosScreenState();
}

class _BiosScreenState extends State<BiosScreen> {
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
            
          )
        ),
      ),
    );
  }
}
