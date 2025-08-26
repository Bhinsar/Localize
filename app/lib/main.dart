import 'dart:math';
import 'dart:ui';
import 'package:app/screen/client_screen/home/home_screen.dart';
import 'package:app/screen/login/login_screen.dart';
import 'package:app/screen/provider_screen/home/home_screen.dart';
import 'package:app/screen/register/number_and_role.dart';
import 'package:app/screen/splash/splash_screen.dart';
import 'package:app/services/language_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'services/locale_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/screen/register/register_screen.dart';

Future<void> main() async {
  await dotenv.load();
  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
  );
  final languageService = LanguageService();
  final deviceLocale = PlatformDispatcher.instance.locale;
  final languageCode = deviceLocale.languageCode;
  final storedLanguageCode = await languageService.getLanguageCode();
  if (storedLanguageCode == null) {
    await languageService.setLanguageCode(languageCode);
  } else {
    // Use the stored language code if it exists
    await languageService.setLanguageCode(storedLanguageCode);
  }
  await languageService.setLanguageCode(languageCode);
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider()..initializeLocale(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp.router(
      locale: provider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primarySwatch: Colors.green),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: "/addnumberandrole",
        builder: (context, state) {
          return const NumberAndRole();
        },
      ),
      GoRoute(
        path: "/client/home",
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: "/provider/home",
        builder: (context, state) {
          return const ProviderHomeScreen();
        },
      ),
    ],
    redirect: (context, state) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final existNumber = await storage.read(key: 'existNumber');
      final role = await storage.read(key: 'role');

      final bool isLoggedIn = token != null;
      final String currentPath = state.matchedLocation;
      final isPublicRoute =
          currentPath == '/login' ||
          currentPath == '/register' ||
          currentPath == '/splash';

      final bool hasCompletedOnboarding =
          existNumber != null && existNumber != 'false';

      if (isLoggedIn && isPublicRoute) {
        if (role == 'provider') return '/provider/home';
        if (role == 'client') return '/client/home';
      }

      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      if (isLoggedIn &&
          !hasCompletedOnboarding &&
          currentPath != '/addnumberandrole') {
        return '/addnumberandrole';
      }

      return null;
    },
  );
}
