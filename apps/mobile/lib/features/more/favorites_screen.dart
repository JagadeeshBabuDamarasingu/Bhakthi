import 'package:flutter/material.dart';
import '../../core/services/favorites_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../deities/deity_detail_screen.dart';
import '../stotras/stotra_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Deity>? _deities;
  List<Stotra>? _stotras;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final fav = FavoritesService.instance;
    final repo = ContentRepository.instance;

    final deityIds = fav.favoritedDeityIds;
    final stotraIds = fav.favoritedStotraIds;

    final deities = await Future.wait(deityIds.map(repo.getDeity));
    final stotras = await Future.wait(stotraIds.map(repo.getStotra));

    if (mounted) {
      setState(() {
        _deities = deities;
        _stotras = stotras;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDeities = (_deities?.isNotEmpty ?? false);
    final hasStotras = (_stotras?.isNotEmpty ?? false);
    final isEmpty = (_deities != null && _stotras != null) && !hasDeities && !hasStotras;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: const Text('Favorites'),
      ),
      body: _deities == null
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : isEmpty
              ? const _EmptyState()
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (hasDeities) ...[
                      _SectionLabel('Deities'),
                      const SizedBox(height: 10),
                      ..._deities!.map((d) => _DeityFavCard(deity: d, onChanged: _load)),
                      const SizedBox(height: 24),
                    ],
                    if (hasStotras) ...[
                      _SectionLabel('Stotras'),
                      const SizedBox(height: 10),
                      ..._stotras!.map((s) => _StotraFavCard(stotra: s, onChanged: _load)),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          color: BhakthiColors.textTertiary),
    );
  }
}

class _DeityFavCard extends StatelessWidget {
  final Deity deity;
  final VoidCallback onChanged;
  const _DeityFavCard({required this.deity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[deity.id] ?? BhakthiColors.rust;
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => DeityDetailScreen(deityId: deity.id)));
        onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.asset(
                deity.imageAsset,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text('ॐ',
                      style: TextStyle(fontSize: 16, color: color.withOpacity(0.5))),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(deity.name.sanskrit ?? deity.name.english,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: BhakthiColors.deepInk)),
              Text(deity.name.english,
                  style: const TextStyle(
                      fontSize: 12, color: BhakthiColors.textSecondary)),
            ]),
          ),
          GestureDetector(
            onTap: () async {
              await FavoritesService.instance.toggleDeity(deity.id);
              onChanged();
            },
            child: const Icon(Icons.favorite, size: 18, color: BhakthiColors.rust),
          ),
        ]),
      ),
    );
  }
}

class _StotraFavCard extends StatelessWidget {
  final Stotra stotra;
  final VoidCallback onChanged;
  const _StotraFavCard({required this.stotra, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[stotra.deity] ?? BhakthiColors.rust;
    final title = stotra.title.sanskrit ??
        stotra.title.transliteration ??
        stotra.title.english;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => StotraDetailScreen(stotraId: stotra.id)));
        onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Icon(Icons.menu_book_outlined, size: 16, color: color.withOpacity(0.7)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: BhakthiColors.deepInk)),
              Text('${stotra.verses.length} verses',
                  style: const TextStyle(
                      fontSize: 11, color: BhakthiColors.textTertiary)),
            ]),
          ),
          GestureDetector(
            onTap: () async {
              await FavoritesService.instance.toggleStotra(stotra.id);
              onChanged();
            },
            child: const Icon(Icons.bookmark, size: 18, color: BhakthiColors.amber),
          ),
        ]),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('🤍', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text('No favorites yet',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BhakthiColors.deepInk)),
          SizedBox(height: 8),
          Text(
            'Tap ♡ on a deity or ⊡ on a stotra to save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: BhakthiColors.textSecondary,
                height: 1.5),
          ),
        ]),
      ),
    );
  }
}
