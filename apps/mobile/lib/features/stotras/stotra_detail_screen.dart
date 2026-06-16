import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class StotraDetailScreen extends StatefulWidget {
  final String stotraId;
  const StotraDetailScreen({super.key, required this.stotraId});

  @override
  State<StotraDetailScreen> createState() => _StotraDetailScreenState();
}

class _StotraDetailScreenState extends State<StotraDetailScreen> {
  Map<String, dynamic>? _stotra;
  int _langIndex = 0;

  static const _langs = ['Sanskrit', 'Transliteration', 'English'];
  static const _keys  = ['sanskrit', 'transliteration', 'english'];

  @override
  void initState() {
    super.initState();
    rootBundle
        .loadString('assets/content/stotras/${widget.stotraId}.json')
        .then((s) => setState(() => _stotra = jsonDecode(s)));
  }

  Color get _color => deityColors[_stotra?['deity'] as String? ?? ''] ?? BhakthiColors.rust;

  @override
  Widget build(BuildContext context) {
    if (_stotra == null) {
      return Scaffold(
        backgroundColor: BhakthiColors.parchment,
        appBar: AppBar(backgroundColor: BhakthiColors.deepInk),
        body: const Center(
            child: CircularProgressIndicator(color: BhakthiColors.rust)),
      );
    }

    final title = _stotra!['title'] as Map<String, dynamic>;
    final verses = (_stotra!['verses'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .where((v) => !((v['sanskrit'] as String? ?? '').startsWith('// TODO')))
        .toList();

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title['english'] as String? ?? '',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            if ((title['sanskrit'] as String? ?? '').isNotEmpty)
              Text(title['sanskrit'] as String,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      body: Column(children: [
        _LangBar(
            langs: _langs,
            selected: _langIndex,
            color: _color,
            onSelect: (i) => setState(() => _langIndex = i)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: verses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (_, i) {
              final v = verses[i];
              final isSanskrit = _langIndex == 0;
              return _VerseCard(
                index: v['index'] as int? ?? i + 1,
                text: v[_keys[_langIndex]] as String? ?? '',
                isSanskrit: isSanskrit,
                transliteration:
                    isSanskrit ? (v['transliteration'] as String? ?? '') : '',
                color: _color,
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _LangBar extends StatelessWidget {
  final List<String> langs;
  final int selected;
  final Color color;
  final ValueChanged<int> onSelect;
  const _LangBar(
      {required this.langs,
      required this.selected,
      required this.color,
      required this.onSelect});

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

class _VerseCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isSanskrit;
  final String transliteration;
  final Color color;

  const _VerseCard({
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
            // Left color bar — roadmap weeks block style
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(13)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Zero-padded index
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
                    // Main text
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
                    // Transliteration below Sanskrit
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
