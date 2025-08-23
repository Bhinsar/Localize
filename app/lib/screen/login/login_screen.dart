import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:app/api/auth/auth_api.dart';
import 'package:app/widgets/snackbar_utils.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _authApi = AuthApi();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(l10) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (!_formKey.currentState!.validate()) {
        return;
      }
      await _authApi.login(_emailController.text, _passwordController.text);
      context.go('/home');
    } catch (e) {
      print('Login error: $e');
      SnackbarUtils.showError(context, l10.loginError);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle(l10) async {
    try {
      await _authApi.loginWithGoogle();
      context.go('/home');
    } catch (e) {
      print('Login error: $e');
      SnackbarUtils.showError(context, l10.loginError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    final l10 = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: d.width30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/main_logo.png',
                      width: d.width * 0.6,
                      height: d.height * 0.6,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: l10.email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10.pleaseEnterEmail;
                        }
                        if (!value.contains('@')) {
                          return l10.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10.password,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return l10.passwordMustBeAtLeast6Chars;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: d.height10 / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(l10.dontHaveAccount),
                        SizedBox(width: 1),
                        GestureDetector(
                          onTap: () {
                            context.push('/register');
                          },
                          child: Text(l10.register, style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                    SizedBox(height: d.height10),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _login(l10),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(l10.login),
                    ),
                    SizedBox(height: d.height10),
                    Text(l10.or),
                    SizedBox(height: d.height10),
                    Container(
                      width: d.width * 0.8,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 27, 109, 202),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _loginWithGoogle(l10);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              width: d.width20,
                              height: d.height20,
                            ),
                            SizedBox(width: d.width10),
                            Text(
                              l10.loginWithGoogle,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
