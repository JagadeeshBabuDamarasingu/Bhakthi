import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import 'deity_detail_screen.dart';

class DeitiesScreen extends StatefulWidget {
  const DeitiesScreen({super.key});

  @override
  State<DeitiesScreen> createState() => _DeitiesScreenState();
}

class _DeitiesScreenState extends State<DeitiesScreen> {
  List<Deity>? _deities;

  // Deities planned for phase 1 but not yet in the repo — shown as placeholders.
  static const _comingSoon = [
    ('Lakshmi',   'लक्ष्मी',  'Goddess of wealth & fortune',  'lakshmi'),
    ('Saraswati', 'सरस्वती', 'Goddess of wisdom & arts',     'saraswati'),
    ('Shiva',     'शिव',      'The destroyer & transformer',   'shiva'),
    ('Vishnu',    'विष्णु',   'The preserver of the universe', 'vishnu'),
    ('Krishna',   'कृष्ण',    'The divine cowherd & guide',    'krishna'),
    ('Rama',      'राम',      'The righteous king',            'rama'),
    ('Hanuman',   'हनुमान',   'The devoted one',               'hanuman'),
  ];

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .listDeities()
        .then((list) { if (mounted) setState(() => _deities = list); });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final loaded = _deities ?? [];
    final loadedIds = loaded.map((d) => d.id).toSet();
    final placeholders = _comingSoon
        .where((c) => !loadedIds.contains(c.$4))
        .toList();

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        title: Text(l.screenDeities),
      ),
      body: _deities == null
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.80,
              children: [
                ...loaded.map((deity) => _DeityCard(deity: deity)),
                ...placeholders.map((c) => _PlaceholderCard(
                      name: c.$1,
                      sanskrit: c.$2,
                      desc: c.$3,
                      color: deityColors[c.$4] ?? BhakthiColors.rust,
                      l: l,
                    )),
              ],
            ),
    );
  }
}

class _DeityCard extends StatelessWidget {
  final Deity deity;
  const _DeityCard({required this.deity});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[deity.id] ?? BhakthiColors.rust;
    final subtitle = deity.aliases.take(2).join(' · ');

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DeityDetailScreen(deityId: deity.id))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BhakthiColors.line),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Expanded(
              child: ClipRRect(
                child: Image.asset(
                  deity.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _DeityImagePlaceholder(color: color),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deity.name.sanskrit ?? deity.name.english,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: BhakthiColors.deepInk,
                          letterSpacing: -0.3)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11,
                          color: BhakthiColors.textSecondary)),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _capitalize(deity.tradition),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                          letterSpacing: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _DeityImagePlaceholder extends StatelessWidget {
  final Color color;
  const _DeityImagePlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.06),
      child: Center(
        child: Text('ॐ',
            style: TextStyle(
                fontSize: 40,
                color: color.withOpacity(0.3),
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String name;
  final String sanskrit;
  final String desc;
  final Color color;
  final AppLocalizations l;

  const _PlaceholderCard({
    required this.name,
    required this.sanskrit,
    required this.desc,
    required this.color,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Expanded(
            child: Container(
              color: BhakthiColors.parchmentElev,
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('✦',
                          style: TextStyle(
                              fontSize: 20, color: color.withOpacity(0.4))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l.comingSoon,
                      style: const TextStyle(
                          fontSize: 10,
                          color: BhakthiColors.textTertiary)),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sanskrit,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFCCCAC6),
                        letterSpacing: -0.3)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 11,
                        color: BhakthiColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
