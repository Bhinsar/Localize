import 'dart:ui';
import 'package:app/screen/client_screen/home/home_screen.dart';
import 'package:app/screen/login/login_screen.dart';
import 'package:app/screen/provider_screen/bios_screen/bios_screen.dart';
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
    await languageService.setLanguageCode(storedLanguageCode);
  }
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
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.green.shade900),
          bodyMedium: TextStyle(color: Colors.green.shade800),
          headlineLarge: TextStyle(color: Colors.green.shade700),
          headlineMedium: TextStyle(color: Colors.green.shade600),
          headlineSmall: TextStyle(color: Colors.green.shade500),
        ),
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: "/addnumberandrole",
        builder: (context, state) => const NumberAndRole(),
      ),
      GoRoute(
        path: "/client/home",
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/provider/home",
        builder: (context, state) => const ProviderHomeScreen(),
      ),
      GoRoute(
        path: "/provider/bios",
        builder: (context, state) => const BiosScreen(),
      ),
    ],
    redirect: (context, state) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final existNumber = await storage.read(key: 'existNumber');
      final role = await storage.read(key: 'role');
      final bios = await storage.read(key: 'bios');
      final currentPath = state.matchedLocation;

      final bool isPublicRoute = [
        '/login',
        '/register',
        '/splash',
      ].contains(currentPath);

      final bool isClientRoute = currentPath.startsWith('/client');
      final bool isProviderRoute = currentPath.startsWith('/provider');

      final bool isLoggedIn = token != null;

      final bool hasCompletedOnboarding =
          existNumber != null && existNumber != 'false';

      final bool hasCompletedBios = bios != null && bios == 'true';

      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      if (isLoggedIn && isPublicRoute) {
        if (!hasCompletedOnboarding) {
          return '/addnumberandrole';
        }
        if (role == 'provider') {
          return hasCompletedBios ? '/provider/home' : '/provider/bios';
        }
        if (role == 'client') {
          return '/client/home';
        }
      }

      if (isLoggedIn &&
          !hasCompletedOnboarding &&
          currentPath != '/addnumberandrole') {
        return '/addnumberandrole';
      }

      if (isLoggedIn && role == 'provider' && isClientRoute) {
        return hasCompletedBios ? '/provider/home' : '/provider/bios';
      }

      if (isLoggedIn && role == 'client' && isProviderRoute) {
        return '/client/home';
      }

      if (isLoggedIn &&
          role == 'provider' &&
          isProviderRoute &&
          !hasCompletedBios &&
          currentPath != '/provider/bios') {
        return '/provider/bios';
      }

      return null;
    },
  );
}
