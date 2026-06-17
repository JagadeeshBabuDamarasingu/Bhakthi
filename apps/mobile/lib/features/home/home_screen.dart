import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/services/favorites_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../deities/deity_detail_screen.dart';
import '../festivals/festival_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stotra? _dailyStotra;
  List<Deity>? _deities;
  List<Festival>? _upcoming;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ContentRepository.instance;

    repo.getStotra('ganesha_vakratunda')
        .then((s) { if (mounted) setState(() => _dailyStotra = s); })
        .catchError((_) {});

    repo.listDeities().then((list) {
      if (!mounted) return;
      // Sort: favorited first, then alphabetical by English name
      final favIds = FavoritesService.instance.favoritedDeityIds.toSet();
      list.sort((a, b) {
        final aFav = favIds.contains(a.id) ? 0 : 1;
        final bFav = favIds.contains(b.id) ? 0 : 1;
        if (aFav != bFav) return aFav.compareTo(bFav);
        return a.name.english.compareTo(b.name.english);
      });
      setState(() => _deities = list);
    });

    repo.listAllFestivals().then((list) {
      if (!mounted) return;
      final now = DateTime.now();
      // Simple sort by tithiMonth as proxy for upcoming order
      list.sort((a, b) => a.tithiMonth.compareTo(b.tithiMonth));
      // Take up to 3
      setState(() => _upcoming = list.take(3).toList());
    });
  }

  void _refreshDeityOrder() {
    final deities = _deities;
    if (deities == null) return;
    final favIds = FavoritesService.instance.favoritedDeityIds.toSet();
    deities.sort((a, b) {
      final aFav = favIds.contains(a.id) ? 0 : 1;
      final bFav = favIds.contains(b.id) ? 0 : 1;
      if (aFav != bFav) return aFav.compareTo(bFav);
      return a.name.english.compareTo(b.name.english);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final h = DateTime.now().hour;
    final greeting =
        h < 12 ? 'शुभ प्रभातम्' : h < 17 ? 'शुभ दिनम्' : 'शुभ संध्या';
    final greetingSub = h < 12
        ? l.greetingMorning
        : h < 17
            ? l.greetingAfternoon
            : l.greetingEvening;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      body: CustomScrollView(
        slivers: [
          _BhakthiAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  _GreetingBlock(greeting: greeting, sub: greetingSub, l: l),
                  const SizedBox(height: 32),
                  _Label(l.labelTodaysShloka),
                  const SizedBox(height: 12),
                  _ShlokaCard(stotra: _dailyStotra),
                  const SizedBox(height: 32),
                  _Label(l.labelDeities),
                  const SizedBox(height: 12),
                  _DeityRow(deities: _deities, onFavChanged: _refreshDeityOrder),
                  const SizedBox(height: 32),
                  _Label(l.labelUpcoming),
                  const SizedBox(height: 12),
                  _UpcomingList(festivals: _upcoming),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BhakthiAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: BhakthiColors.deepInk,
      floating: true,
      snap: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BhakthiColors.rust, BhakthiColors.amber, BhakthiColors.purple],
              ),
            ),
            child: const Center(
              child: Text('ॐ',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Bhakthi',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: BhakthiColors.textTertiary,
      ),
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  final String greeting;
  final String sub;
  final AppLocalizations l;
  const _GreetingBlock({required this.greeting, required this.sub, required this.l});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = l.daysShort;
    final months = l.monthsShort;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: BhakthiColors.deepInk,
          ),
        ),
        const SizedBox(height: 4),
        Row(children: [
          Text('$sub  ·  ',
              style: const TextStyle(fontSize: 14, color: BhakthiColors.textSecondary)),
          Text(
            '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}',
            style: const TextStyle(fontSize: 14, color: BhakthiColors.textTertiary),
          ),
        ]),
      ],
    );
  }
}

// ── Shloka Card ───────────────────────────────────────────────────────────────

class _ShlokaCard extends StatelessWidget {
  final Stotra? stotra;
  const _ShlokaCard({required this.stotra});

  @override
  Widget build(BuildContext context) {
    final s = stotra;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BhakthiColors.line),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: s == null
          ? const SizedBox(
              height: 80,
              child: Center(
                  child: CircularProgressIndicator(color: BhakthiColors.rust, strokeWidth: 2)))
          : _ShlokaContent(stotra: s),
    );
  }
}

class _ShlokaContent extends StatelessWidget {
  final Stotra stotra;
  const _ShlokaContent({required this.stotra});

  @override
  Widget build(BuildContext context) {
    final verse = stotra.verses.isNotEmpty ? stotra.verses.first : null;
    final deityName = stotra.deity.isEmpty
        ? ''
        : stotra.deity[0].toUpperCase() + stotra.deity.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: BhakthiColors.rust.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: BhakthiColors.rust.withOpacity(0.25)),
          ),
          child: Text(deityName,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: BhakthiColors.rust,
                  letterSpacing: 0.2)),
        ),
        if (verse != null) ...[
          const SizedBox(height: 16),
          Text(
            verse.sanskrit,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: BhakthiColors.deepInk,
              height: 1.7,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: BhakthiColors.line),
          const SizedBox(height: 14),
          Text(
            verse.transliteration,
            style: const TextStyle(
              fontSize: 12,
              color: BhakthiColors.textSecondary,
              height: 1.7,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            verse.english,
            style: const TextStyle(fontSize: 13, color: BhakthiColors.textSecondary, height: 1.6),
          ),
        ],
      ],
    );
  }
}

// ── Deity Row ─────────────────────────────────────────────────────────────────

class _DeityRow extends StatelessWidget {
  final List<Deity>? deities;
  final VoidCallback onFavChanged;
  const _DeityRow({required this.deities, required this.onFavChanged});

  @override
  Widget build(BuildContext context) {
    final list = deities;
    if (list == null) {
      return const SizedBox(
        height: 108,
        child: Center(child: CircularProgressIndicator(color: BhakthiColors.rust, strokeWidth: 2)),
      );
    }

    return SizedBox(
      height: 108,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (ctx, i) {
          final deity = list[i];
          final color = deityColors[deity.id] ?? BhakthiColors.rust;
          final isFav = FavoritesService.instance.isDeityFavorited(deity.id);
          return _DeityChip(
            sanskrit: deity.name.sanskrit ?? deity.name.english,
            color: color,
            imagePath: deity.imageAsset,
            isFav: isFav,
            onTap: () async {
              await Navigator.push(
                  ctx,
                  MaterialPageRoute(
                      builder: (_) => DeityDetailScreen(deityId: deity.id)));
              onFavChanged();
            },
          );
        },
      ),
    );
  }
}

class _DeityChip extends StatelessWidget {
  final String sanskrit;
  final Color color;
  final String imagePath;
  final bool isFav;
  final VoidCallback onTap;
  const _DeityChip({
    required this.sanskrit,
    required this.color,
    required this.imagePath,
    required this.isFav,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 84,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isFav ? color : color.withOpacity(0.3),
              width: isFav ? 2 : 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text('ॐ',
                          style: TextStyle(
                              fontSize: 20, color: color.withOpacity(0.5))),
                    ),
                  ),
                ),
              ),
              if (isFav)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: BhakthiColors.rust,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.favorite, size: 8, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(sanskrit,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: BhakthiColors.deepInk,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

// ── Upcoming Festivals ────────────────────────────────────────────────────────

class _UpcomingList extends StatelessWidget {
  final List<Festival>? festivals;
  const _UpcomingList({required this.festivals});

  @override
  Widget build(BuildContext context) {
    final list = festivals;
    if (list == null) {
      return const SizedBox(
        height: 60,
        child: Center(
            child: CircularProgressIndicator(color: BhakthiColors.rust, strokeWidth: 2)),
      );
    }
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: list.map((f) => _UpcomingItem(festival: f)).toList(),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  final Festival festival;
  const _UpcomingItem({required this.festival});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FestivalDetailScreen(festivalId: festival.id))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: BhakthiColors.emerald.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('🪔', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(festival.name.forLocale(locale),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: BhakthiColors.deepInk,
                        fontSize: 14,
                        letterSpacing: -0.2)),
                const SizedBox(height: 3),
                Text(
                  festival.gregorianApprox ??
                      '${festival.tithiPaksha == 'shukla' ? 'Shukla' : 'Krishna'} Paksha, day ${festival.tithiDay}',
                  style: const TextStyle(color: BhakthiColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}
