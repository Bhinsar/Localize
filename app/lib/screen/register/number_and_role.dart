import 'package:app/api/auth/auth_api.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/dimensions.dart';
import 'package:app/widgets/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NumberAndRole extends StatefulWidget {
  const NumberAndRole({super.key});

  @override
  State<NumberAndRole> createState() => _NumberAndRoleState();
}

class _NumberAndRoleState extends State<NumberAndRole> {
  final _numberController = TextEditingController();
  // Using a simple String for the dropdown's state is more conventional
  String _selectedRole = "client";
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _authService = AuthApi();

  Future<void> _submitForm(AppLocalizations l10) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.addNumberAndRole(
        _numberController.text,
        _selectedRole,
      );
      if (response != null) {
        if (response['error'] != null) {
          throw Exception(response['error']);
        }
        context.go('/${_selectedRole}/home');
      } else {
        SnackbarUtils.showError(context, l10.somethingWentWrongPlease);
      }
    } catch (e) {
      print("Error on editing number and role: $e");
      final errorMessage = e.toString();

      if (errorMessage.contains(
        'Phone number is already in use by another user',
      )) {
        SnackbarUtils.showError(context, l10.phoneNumberAlreadyInUse);
      } else {
        SnackbarUtils.showError(context, l10.somethingWentWrongPlease);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Image.asset(
            "assets/images/app_bar_logo.PNG",
            width: d.width * 0.30,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: d.width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: d.height * 0.02),
                  TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      labelText: l10.phoneNumber,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 21, 61, 22),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone, // Use phone keyboard
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10.pleaseEnterPhoneNumber;
                      }
                      // Basic validation for digits only
                      if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value) ||
                          value.length < 10 ||
                          value.length > 10) {
                        return l10.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: d.height * 0.02),
                  // --- REPLACED: Using DropdownButtonFormField for better integration ---
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 21, 61, 22),
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        value: "client",
                        child: Text(l10.client),
                      ),
                      DropdownMenuItem(
                        value: "provider",
                        child: Text(l10.provider),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: d.height * 0.04),
                  // --- IMPROVED: Button and Loading Indicator ---
                  SizedBox(
                    width: double.infinity,
                    height: d.height * 0.06,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _submitForm(l10),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 21, 61, 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10.submit,
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
