import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LangBar extends StatelessWidget {
  final List<String> langs;
  final int selected;
  final Color color;
  final ValueChanged<int> onSelect;
  const LangBar({
    super.key,
    required this.langs,
    required this.selected,
    required this.color,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(langs.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: EdgeInsets.only(right: i < langs.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: active ? color : BhakthiColors.lineStrong),
                ),
                child: Text(langs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: active ? Colors.white : BhakthiColors.textSecondary,
                        letterSpacing: 0.1)),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VerseCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isSanskrit;
  final String transliteration;
  final Color color;

  const VerseCard({
    super.key,
    required this.index,
    required this.text,
    required this.isSanskrit,
    required this.transliteration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(13)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.5,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: isSanskrit ? 19 : 15,
                        color: BhakthiColors.deepInk,
                        height: 1.8,
                        fontWeight: isSanskrit ? FontWeight.w600 : FontWeight.w400,
                        letterSpacing: isSanskrit ? -0.2 : 0.1,
                      ),
                    ),
                    if (isSanskrit && transliteration.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(height: 1, color: BhakthiColors.line),
                      const SizedBox(height: 12),
                      Text(
                        transliteration,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BhakthiColors.textSecondary,
                          height: 1.75,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
