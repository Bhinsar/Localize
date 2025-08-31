import 'package:app/l10n/app_localizations.dart';
import 'package:app/models/provider_details.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final ProviderDetails data;
  final GlobalKey<FormState> formKey;
  const Profile({super.key, required this.data, required this.formKey});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: d.width10,
          vertical: d.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10.tellUsAboutYourself, style: TextStyle(fontSize: d.font20)),
            SizedBox(height: d.height10,),
            TextFormField(
              decoration: InputDecoration(
                hintText: l10.tellUsAboutYourself,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              initialValue: widget.data.bio,
              maxLines: 5,
              minLines: 3,
              onChanged: (value) => {
                widget.data.bio = value,
              },
              
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10.thisfieldcannotbeempty;
                  }
                  return null;
                },
              ),
            
          ],
        ),
      ),
    );
  }
}
