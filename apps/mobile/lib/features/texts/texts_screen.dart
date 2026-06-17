import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'bhagavad_gita_screen.dart';
import 'stotra_library_screen.dart';

class TextsScreen extends StatelessWidget {
  const TextsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        title: Text(l.screenSacredTexts),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _TextCard(
            index: 1,
            title: 'Bhagavad Gita',
            sanskrit: 'श्रीमद्भगवद्गीता',
            meta: '18 chapters  ·  700 verses',
            color: BhakthiColors.teal,
            available: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const BhagavadGitaScreen())),
          ),
          const SizedBox(height: 12),
          _TextCard(
            index: 2,
            title: 'Stotra Library',
            sanskrit: 'स्तोत्र संग्रह',
            meta: 'All stotras & mantras',
            color: BhakthiColors.rust,
            available: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StotraLibraryScreen())),
          ),
          const SizedBox(height: 12),
          _TextCard(
            index: 3,
            title: 'Vishnu Sahasranama',
            sanskrit: 'विष्णु सहस्रनाम',
            meta: '1 chapter  ·  1000 names',
            color: BhakthiColors.purple,
            available: false,
            onTap: null,
          ),
          const SizedBox(height: 12),
          _TextCard(
            index: 4,
            title: 'Shiva Mahimna Stotram',
            sanskrit: 'शिव महिम्न स्तोत्रम्',
            meta: '43 verses',
            color: BhakthiColors.indigo,
            available: false,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  final int index;
  final String title;
  final String sanskrit;
  final String meta;
  final Color color;
  final bool available;
  final VoidCallback? onTap;

  const _TextCard({
    required this.index,
    required this.title,
    required this.sanskrit,
    required this.meta,
    required this.color,
    required this.available,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Opacity(
        opacity: available ? 1.0 : 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: available ? color.withOpacity(0.25) : BhakthiColors.line,
                width: available ? 1.5 : 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(15)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Text(
                        index.toString().padLeft(2, '0'),
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: color,
                            fontFeatures: const [FontFeature.tabularFigures()]),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sanskrit,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: BhakthiColors.deepInk,
                                    fontSize: 15,
                                    letterSpacing: -0.2)),
                            const SizedBox(height: 2),
                            Text(title,
                                style: const TextStyle(
                                    color: BhakthiColors.textSecondary,
                                    fontSize: 12)),
                            const SizedBox(height: 5),
                            Text(meta,
                                style: const TextStyle(
                                    color: BhakthiColors.textTertiary,
                                    fontSize: 11)),
                          ],
                        ),
                      ),
                      if (available)
                        const Icon(Icons.arrow_forward_ios,
                            size: 11, color: BhakthiColors.textTertiary)
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: BhakthiColors.parchmentElev,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(l.soon,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: BhakthiColors.textTertiary)),
                        ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
