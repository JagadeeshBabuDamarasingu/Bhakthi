import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TextsScreen extends StatelessWidget {
  const TextsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
          backgroundColor: BhakthiColors.deepInk,
          title: const Text('Sacred Texts')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _TextCard(
            index: 1,
            title: 'Bhagavad Gita',
            sanskrit: 'श्रीमद्भगवद्गीता',
            meta: '18 chapters  ·  700 verses',
            color: BhakthiColors.teal,
          ),
          SizedBox(height: 12),
          _TextCard(
            index: 2,
            title: 'Vishnu Sahasranama',
            sanskrit: 'विष्णु सहस्रनाम',
            meta: '1 chapter  ·  1000 names',
            color: BhakthiColors.purple,
          ),
          SizedBox(height: 12),
          _TextCard(
            index: 3,
            title: 'Shiva Mahimna Stotram',
            sanskrit: 'शिव महिम्न स्तोत्रम्',
            meta: '43 verses',
            color: BhakthiColors.indigo,
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

  const _TextCard({
    required this.index,
    required this.title,
    required this.sanskrit,
    required this.meta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BhakthiColors.line),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: BhakthiColors.parchmentElev,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('Soon',
                          style: TextStyle(
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
    );
  }
}
