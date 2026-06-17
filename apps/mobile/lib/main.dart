import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/preferences/app_preferences.dart';
import 'core/services/favorites_service.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    AppPreferences.init(),
    FavoritesService.instance.init(),
  ]);
  runApp(BhakthiApp(initialLocale: Locale(AppPreferences.languageCode)));
}

class BhakthiApp extends StatefulWidget {
  final Locale initialLocale;
  const BhakthiApp({super.key, required this.initialLocale});

  static _BhakthiAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BhakthiAppState>();

  @override
  State<BhakthiApp> createState() => _BhakthiAppState();
}

class _BhakthiAppState extends State<BhakthiApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

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
