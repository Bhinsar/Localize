import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/utils/dimensions.dart';
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
  void initState() {
    super.initState();
    widget.data.price = 0.0;
    widget.data.price_unit = widget.data.service?.name == 'Milk'
        ? "perLiter"
        : widget.data.service?.name == 'Newspaper'
        ? "permonth"
        : "perHours";
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: d.width10,
          vertical: d.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10.setYourPrice,
              style: TextStyle(fontSize: d.font18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  width: d.width * 0.1,
                  child: Icon(Icons.currency_rupee),
                ),
                Container(
                  width: d.width * 0.55,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '100',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    onChanged: (value) {
                      widget.data.price = double.tryParse(value) ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10.enterPrice;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: d.width10),
                Container(
                  width: d.width * 0.15,
                  child: Text(
                    widget.data.service?.name == 'Milk'
                        ? l10.perLiter
                        : widget.data.service?.name == 'Newspaper'
                        ? l10.permonth
                        : l10.perHours,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
