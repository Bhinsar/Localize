import 'package:app/screen/home_screen.dart';
import 'package:app/screen/login_screen.dart';
import 'package:app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'services/locale_provider.dart';
import 'package:app/l10n/app_localizations.dart'; // Corrected import path

Future<void> main() async {
  await dotenv.load();
  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: provider.locale,
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
        path: "/home",
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}