import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/stotra.dart';
import '../../data/repositories/content_repository.dart';
import '../../shared/widgets/verse_display.dart';

class _GitaChapterMeta {
  final int number;
  final String sanskrit;
  final String english;
  final String theme;
  final int verseCount;
  const _GitaChapterMeta(this.number, this.sanskrit, this.english, this.theme, this.verseCount);
}

const _chapters = [
  _GitaChapterMeta(1,  'अर्जुनविषादयोग',            'Arjuna\'s Grief',        'The crisis of Arjuna on the battlefield',       47),
  _GitaChapterMeta(2,  'सांख्ययोग',                  'Sankhya Yoga',           'The eternal nature of the soul',                72),
  _GitaChapterMeta(3,  'कर्मयोग',                    'Karma Yoga',             'The yoga of selfless action',                   43),
  _GitaChapterMeta(4,  'ज्ञानकर्मसन्यासयोग',        'Knowledge & Renunciation','Divine knowledge and renunciation of action',  42),
  _GitaChapterMeta(5,  'कर्मसन्यासयोग',              'Renunciation',           'True renunciation through action',              29),
  _GitaChapterMeta(6,  'आत्मसंयमयोग',               'Self-Control',           'Meditation and the mastery of the mind',        47),
  _GitaChapterMeta(7,  'ज्ञानविज्ञानयोग',            'Knowledge & Wisdom',     'Knowledge of the absolute and the relative',    30),
  _GitaChapterMeta(8,  'अक्षरब्रह्मयोग',             'Imperishable Brahman',   'The path to the imperishable Brahman',          28),
  _GitaChapterMeta(9,  'राजविद्याराजगुह्ययोग',      'Royal Knowledge',        'The sovereign secret of devotion',              34),
  _GitaChapterMeta(10, 'विभूतियोग',                  'Divine Glories',         'Krishna\'s infinite divine manifestations',     42),
  _GitaChapterMeta(11, 'विश्वरूपदर्शनयोग',          'The Universal Form',     'The vision of Krishna\'s cosmic form',          55),
  _GitaChapterMeta(12, 'भक्तियोग',                   'Bhakti Yoga',            'The yoga of devotion',                          20),
  _GitaChapterMeta(13, 'क्षेत्रक्षेत्रज्ञविभागयोग', 'Field & Its Knower',     'The body and the knowing self',                 35),
  _GitaChapterMeta(14, 'गुणत्रयविभागयोग',            'Three Qualities',        'The three gunas — tamas, rajas, sattva',       27),
  _GitaChapterMeta(15, 'पुरुषोत्तमयोग',              'Supreme Person',         'The cosmic tree and the supreme self',          20),
  _GitaChapterMeta(16, 'दैवासुरसम्पद्विभागयोग',     'Divine & Demonic',       'Divine qualities versus demonic nature',        24),
  _GitaChapterMeta(17, 'श्रद्धात्रयविभागयोग',        'Three Kinds of Faith',   'Faith and its three forms',                     28),
  _GitaChapterMeta(18, 'मोक्षसन्यासयोग',             'Liberation',             'The yoga of liberation and renunciation',       78),
];

class BhagavadGitaScreen extends StatelessWidget {
  const BhagavadGitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: BhakthiColors.deepInk,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0D3D2E), BhakthiColors.deepInk],
                    ),
                  ),
                  child: const Center(
                    child: Text('श्रीमद्\nभगवद्गीता',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0x305CB88C),
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 1.2)),
                  ),
                ),
                Positioned(
                  bottom: 52,
                  left: 20,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 32,
                      height: 3,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: BhakthiColors.teal,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Text('श्रीमद्भगवद्गीता',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3)),
                    const Text('Bhagavad Gita  ·  18 chapters  ·  700 verses',
                        style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ]),
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: BhakthiColors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BhakthiColors.teal.withOpacity(0.2)),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline, size: 13, color: BhakthiColors.teal),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Verses will be added soon. Tap any chapter to explore.',
                    style: TextStyle(fontSize: 12, color: BhakthiColors.teal, height: 1.4),
                  ),
                ),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _ChapterRow(chapter: _chapters[i]),
              childCount: _chapters.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  final _GitaChapterMeta chapter;
  const _ChapterRow({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _GitaChapterScreen(chapter: chapter))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          SizedBox(
            width: 32,
            child: Text(
              chapter.number.toString().padLeft(2, '0'),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BhakthiColors.teal,
                  fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(chapter.sanskrit,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: BhakthiColors.deepInk,
                      fontSize: 15,
                      letterSpacing: -0.2)),
              const SizedBox(height: 2),
              Text(chapter.english,
                  style: const TextStyle(color: BhakthiColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 3),
              Text('${chapter.verseCount} verses  ·  ${chapter.theme}',
                  style: const TextStyle(color: BhakthiColors.textTertiary, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios, size: 11, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}

// ── Chapter Detail ────────────────────────────────────────────────────────────

class _GitaChapterScreen extends StatefulWidget {
  final _GitaChapterMeta chapter;
  const _GitaChapterScreen({super.key, required this.chapter});

  @override
  State<_GitaChapterScreen> createState() => _GitaChapterScreenState();
}

class _GitaChapterScreenState extends State<_GitaChapterScreen> {
  List<Verse>? _verses;
  int _langIndex = 0;
  bool _error = false;

  static const _langs = ['Sanskrit', 'Transliteration', 'English'];

  @override
  void initState() {
    super.initState();
    final chId = 'gita_chapter_${widget.chapter.number.toString().padLeft(2, '0')}';
    ContentRepository.instance.getStotra(chId).then((s) {
      if (mounted) setState(() => _verses = s.verses);
    }).catchError((_) {
      if (mounted) setState(() => _error = true);
    });
  }

  String _verseText(Verse v) {
    switch (_langIndex) {
      case 1: return v.transliteration;
      case 2: return v.english;
      default: return v.sanskrit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ch = widget.chapter;
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Chapter ${ch.number}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Text(ch.english,
              style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ]),
      ),
      body: Column(children: [
        LangBar(
          langs: _langs,
          selected: _langIndex,
          color: BhakthiColors.teal,
          onSelect: (i) => setState(() => _langIndex = i),
        ),
        Expanded(child: _body(ch)),
      ]),
    );
  }

  Widget _body(_GitaChapterMeta ch) {
    if (_error || (_verses != null && _verses!.isEmpty)) {
      return _EmptyChapter(chapter: ch);
    }
    if (_verses == null) {
      return const Center(child: CircularProgressIndicator(color: BhakthiColors.teal));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _verses!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) {
        final v = _verses![i];
        final isSanskrit = _langIndex == 0;
        return VerseCard(
          index: v.index,
          text: _verseText(v),
          isSanskrit: isSanskrit,
          transliteration: isSanskrit ? v.transliteration : '',
          color: BhakthiColors.teal,
        );
      },
    );
  }
}

class _EmptyChapter extends StatelessWidget {
  final _GitaChapterMeta chapter;
  const _EmptyChapter({required this.chapter});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BhakthiColors.line),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(chapter.sanskrit,
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: BhakthiColors.deepInk,
                    height: 1.2)),
            const SizedBox(height: 6),
            Text(chapter.english,
                style: const TextStyle(fontSize: 14, color: BhakthiColors.textSecondary)),
            const SizedBox(height: 12),
            Text('${chapter.verseCount} verses  ·  ${chapter.theme}',
                style: const TextStyle(fontSize: 12, color: BhakthiColors.textTertiary, height: 1.5)),
          ]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BhakthiColors.teal.withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BhakthiColors.teal.withOpacity(0.2)),
          ),
          child: const Row(children: [
            Text('🕉️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Verse content for this chapter is being prepared and will be available in the next update.',
                style: TextStyle(fontSize: 13, color: BhakthiColors.teal, height: 1.5),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
