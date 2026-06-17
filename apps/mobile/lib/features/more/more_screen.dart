import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../settings/language_picker_screen.dart';
import 'bhajans_screen.dart';
import 'favorites_screen.dart';
import 'puja_guide_list_screen.dart';
import 'vrat_tracker_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l    = AppLocalizations.of(context);
    final lang = AppLocalizations.languageNames[l.locale.languageCode] ?? 'English';

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
          backgroundColor: BhakthiColors.deepInk,
          title: Text(l.screenMore)),
      body: ListView(
        children: [
          _Section(title: l.sectionDevotional, items: [
            _Item(Icons.favorite_border,        'Favorites',         null,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
            _Item(Icons.music_note_outlined,    l.itemBhajans,       null,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BhajansScreen()))),
            _Item(Icons.brightness_5_outlined,  l.itemPujaGuides,    null,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PujaGuideListScreen()))),
            _Item(Icons.no_food_outlined,        l.itemVratTracker,   null,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VratTrackerScreen()))),
          ]),
          _Section(title: l.sectionSettings, items: [
            _Item(Icons.language_outlined,      l.itemLanguage,      lang,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LanguagePickerScreen()))),
            _Item(Icons.notifications_outlined, l.itemNotifications, null,  () {}),
            _Item(Icons.text_fields_outlined,   l.itemFontSize,      null,  () {}),
          ]),
          const SizedBox(height: 48),
          Center(
            child: Column(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [BhakthiColors.rust, BhakthiColors.amber, BhakthiColors.purple],
                  ),
                ),
                child: const Center(
                  child: Text('ॐ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              const Text('ॐ तत् सत्',
                  style: TextStyle(
                      color: BhakthiColors.textTertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5)),
              const SizedBox(height: 4),
              const Text('Bhakthi v1.0',
                  style: TextStyle(
                      color: BhakthiColors.textTertiary, fontSize: 11)),
              const SizedBox(height: 32),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: BhakthiColors.textTertiary,
                  letterSpacing: 1.1)),
        ),
        Container(
          color: Colors.white,
          child: Column(children: [
            ...items.expand((item) => [
                  item,
                  Container(
                      height: 1,
                      margin: const EdgeInsets.only(left: 56),
                      color: BhakthiColors.line),
                ]).toList()
              ..removeLast(),
          ]),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _Item(this.icon, this.label, this.trailing, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: BhakthiColors.rust, size: 20),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14,
              color: BhakthiColors.deepInk,
              fontWeight: FontWeight.w400)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (trailing != null)
          Text(trailing!,
              style: const TextStyle(
                  color: BhakthiColors.textTertiary, fontSize: 12)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right,
            color: BhakthiColors.textTertiary, size: 16),
      ]),
      onTap: onTap,
    );
  }
}
