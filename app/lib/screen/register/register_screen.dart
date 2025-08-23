import 'package:app/api/auth/auth_api.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/widgets/snackbar_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final _authService = AuthApi();

  Future<void> _createAccount(AppLocalizations l10) async {
    // Check if the form is valid before proceeding
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await _authService.register(
          _emailController.text,
          _passwordController.text,
          _fullNameController.text,
        );
        if (response == null) {
          throw Exception("Registration failed. Please try again.");
        } else if (response.containsKey('error')) {
          throw Exception(response['error']);
        }
        context.push('/addnumberandrole');
      } catch (e) {
        print('Registration error: $e');
        // Use if-else to show only one snackbar per error
        if (e.toString().contains('User already registered')) {
          // Made check more robust
          SnackbarUtils.showError(context, l10.userAlreadyExists);
        } else {
          SnackbarUtils.showError(context, e.toString());
          // SnackbarUtils.showError(context, l10.registrationError);
        }
      } finally {
        // Ensure isLoading is set to false even if the widget is disposed
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // Dispose all controllers to prevent memory leaks
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
          backgroundColor: Colors.transparent,
          title: Image.asset(
            "assets/images/app_bar_logo.PNG",
            width: d.width * 0.30,
            // Using height in AppBar title can be tricky, consider constraints
            // height: d.height * 0.7,
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
                  Text(
                    l10.createAccount,
                    style: TextStyle(
                      fontSize: d.font24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: d.height10),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: l10.fullName,
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
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10.pleaseEnterFullName;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: d.height * 0.02),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10.email,
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
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10.pleaseEnterEmail;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return l10.pleaseEnterValidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: d.height * 0.02),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10.password,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 21, 61, 22),
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color.fromARGB(255, 21, 61, 22),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return l10.pleaseEnterPassword;
                      if (value.length < 6)
                        return l10.passwordMustBeAtLeast6Chars;
                      return null;
                    },
                  ),
                  SizedBox(height: d.height * 0.02), // Consistent spacing
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: l10.confirmPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 21, 61, 22),
                          width: 2.0,
                        ),
                      ),
                      // Suffix icon was duplicated, it should be independent per field
                    ),
                    obscureText: !_isPasswordVisible, // Should also be toggled
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10.pleaseEnterConfirmPassword;
                      }
                      if (value != _passwordController.text) {
                        return l10.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: d.height * 0.04), // Space before button
                  SizedBox(
                    width: double.infinity, // Make button take full width
                    height:
                        d.height * 0.06, // Define a good height for the button
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _createAccount(l10),
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
                              l10.register,
                              style: TextStyle(color: Colors.white),
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
