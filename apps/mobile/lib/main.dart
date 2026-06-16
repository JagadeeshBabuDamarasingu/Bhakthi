import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/main_scaffold.dart';

void main() {
  runApp(const BhakthiApp());
}

class BhakthiApp extends StatelessWidget {
  const BhakthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhakthi',
      debugShowCheckedModeBanner: false,
      theme: BhakthiTheme.light,
      home: const MainScaffold(),
    );
  }
}
