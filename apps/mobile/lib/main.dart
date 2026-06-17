import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const BhakthiApp());
}

class BhakthiApp extends StatefulWidget {
  const BhakthiApp({super.key});

  static _BhakthiAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BhakthiAppState>();

  @override
  State<BhakthiApp> createState() => _BhakthiAppState();
}

class _BhakthiAppState extends State<BhakthiApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhakthi',
      debugShowCheckedModeBanner: false,
      theme: BhakthiTheme.light,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
