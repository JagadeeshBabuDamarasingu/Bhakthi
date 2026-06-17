import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/home_screen.dart';
import '../../features/deities/deities_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/texts/texts_screen.dart';
import '../../features/more/more_screen.dart';
import '../../features/search/search_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    DeitiesScreen(),
    CalendarScreen(),
    TextsScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SearchScreen())),
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        elevation: 2,
        mini: true,
        child: const Icon(Icons.search, size: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: BhakthiColors.line)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: l.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_outlined),
              activeIcon: const Icon(Icons.auto_awesome),
              label: l.navDeities,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: l.navCalendar,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_outlined),
              activeIcon: const Icon(Icons.menu_book),
              label: l.navTexts,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz),
              label: l.navMore,
            ),
          ],
        ),
      ),
    );
  }
}
