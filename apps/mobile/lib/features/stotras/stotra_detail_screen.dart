import 'package:flutter/material.dart';
import '../../core/services/favorites_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/verse_display.dart';

class StotraDetailScreen extends StatefulWidget {
  final String stotraId;
  const StotraDetailScreen({super.key, required this.stotraId});

  @override
  State<StotraDetailScreen> createState() => _StotraDetailScreenState();
}

class _StotraDetailScreenState extends State<StotraDetailScreen> {
  Stotra? _stotra;
  int _langIndex = 0;
  bool _isFav = false;

  static const _langs = ['Sanskrit', 'Transliteration', 'English'];

  @override
  void initState() {
    super.initState();
    _isFav = FavoritesService.instance.isStotraFavorited(widget.stotraId);
    ContentRepository.instance
        .getStotra(widget.stotraId)
        .then((s) { if (mounted) setState(() => _stotra = s); });
  }

  Future<void> _toggleFav() async {
    await FavoritesService.instance.toggleStotra(widget.stotraId);
    if (mounted) {
      setState(() => _isFav = FavoritesService.instance.isStotraFavorited(widget.stotraId));
    }
  }

  Color get _color =>
      deityColors[_stotra?.deity ?? ''] ?? BhakthiColors.rust;

  String _verseText(Verse v) {
    switch (_langIndex) {
      case 1: return v.transliteration;
      case 2: return v.english;
      default: return v.sanskrit;
    }
  }

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

    final stotra = _stotra!;
    final verses = stotra.verses
        .where((v) => !v.sanskrit.startsWith('// TODO'))
        .toList();

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stotra.title.english,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            if ((stotra.title.sanskrit ?? '').isNotEmpty)
              Text(stotra.title.sanskrit!,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white54,
                      fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _toggleFav,
            icon: Icon(
              _isFav ? Icons.bookmark : Icons.bookmark_border,
              color: _isFav ? BhakthiColors.amber : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(children: [
        LangBar(
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
              return VerseCard(
                index: v.index,
                text: _verseText(v),
                isSanskrit: isSanskrit,
                transliteration: isSanskrit ? v.transliteration : '',
                color: _color,
              );
            },
          ),
        ),
      ]),
    );
  }
}

