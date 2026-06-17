import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/services/favorites_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../festivals/festival_detail_screen.dart';
import '../stotras/stotra_detail_screen.dart';

class DeityDetailScreen extends StatefulWidget {
  final String deityId;
  const DeityDetailScreen({super.key, required this.deityId});

  @override
  State<DeityDetailScreen> createState() => _DeityDetailScreenState();
}

class _DeityDetailScreenState extends State<DeityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  Deity? _deity;
  List<Stotra>? _stotras;
  PujaGuide? _pujaGuide;
  List<Festival>? _festivals;
  bool _isFav = false;

  Color get _deityColor =>
      deityColors[widget.deityId] ?? BhakthiColors.rust;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _isFav = FavoritesService.instance.isDeityFavorited(widget.deityId);
    _loadContent();
  }

  Future<void> _toggleFav() async {
    await FavoritesService.instance.toggleDeity(widget.deityId);
    if (mounted) {
      setState(() => _isFav = FavoritesService.instance.isDeityFavorited(widget.deityId));
    }
  }

  Future<void> _loadContent() async {
    final repo = ContentRepository.instance;
    final id = widget.deityId;

    final deity = await repo.getDeity(id);
    if (!mounted) return;
    setState(() => _deity = deity);

    final stotrasFuture = repo.listStotrasForDeity(id);
    final pujaFuture = repo.getPujaGuideForDeity(id);
    final festsFuture = repo.listFestivalsForDeity(id);

    final stotras = await stotrasFuture;
    final pujaGuide = await pujaFuture;
    final festivals = await festsFuture;

    if (mounted) {
      setState(() {
        _stotras = stotras;
        _pujaGuide = pujaGuide;
        _festivals = festivals;
      });
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_deity == null) {
      return Scaffold(
        backgroundColor: BhakthiColors.parchment,
        appBar: AppBar(backgroundColor: BhakthiColors.deepInk),
        body: Center(
            child: CircularProgressIndicator(color: _deityColor)),
      );
    }

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, _) => [
          _buildHero(ctx),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedTabBar(
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: l.tabStotras),
                  Tab(text: l.tabPuja),
                  Tab(text: l.tabFestivals),
                ],
                indicatorColor: _deityColor,
                labelColor: _deityColor,
              ),
              color: _deityColor,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _StotrasTab(stotras: _stotras, color: _deityColor),
            _PujaTab(pujaGuide: _pujaGuide, color: _deityColor, l: l),
            _FestivalsTab(festivals: _festivals),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildHero(BuildContext context) {
    final deity = _deity!;
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: BhakthiColors.deepInk,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: _toggleFav,
          icon: Icon(
            _isFav ? Icons.favorite : Icons.favorite_border,
            color: _isFav ? BhakthiColors.rust : Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          Image.asset(
            deity.imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: _deityColor.withOpacity(0.15),
              child: Center(
                child: Text('ॐ',
                    style: TextStyle(
                        fontSize: 80,
                        color: _deityColor.withOpacity(0.35),
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  BhakthiColors.deepInk.withOpacity(0.92),
                ],
                stops: const [0.35, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: _deityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                Text(
                  deity.name.sanskrit ?? deity.name.english,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deity.name.english,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Stotras Tab ──────────────────────────────────────────────────────────────

class _StotrasTab extends StatelessWidget {
  final List<Stotra>? stotras;
  final Color color;

  const _StotrasTab({required this.stotras, required this.color});

  @override
  Widget build(BuildContext context) {
    final list = stotras;
    if (list == null) {
      return Center(child: CircularProgressIndicator(color: color));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final s = list[i];
        final verseCount = s.verses.length;
        return _StotraRow(
          index: i + 1,
          sanskrit: s.title.sanskrit ?? s.title.transliteration ?? s.title.english,
          english: s.title.english,
          detail: '$verseCount ${verseCount == 1 ? "verse" : "verses"}',
          color: color,
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(
                  builder: (_) => StotraDetailScreen(stotraId: s.id))),
        );
      },
    );
  }
}

class _StotraRow extends StatelessWidget {
  final int index;
  final String sanskrit;
  final String english;
  final String detail;
  final Color color;
  final VoidCallback onTap;

  const _StotraRow({
    required this.index,
    required this.sanskrit,
    required this.english,
    required this.detail,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          SizedBox(
            width: 28,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sanskrit,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: BhakthiColors.deepInk,
                        fontSize: 15,
                        letterSpacing: -0.2)),
                const SizedBox(height: 3),
                Text(english,
                    style: const TextStyle(
                        color: BhakthiColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 3),
                Text(detail,
                    style: const TextStyle(
                        color: BhakthiColors.textTertiary, fontSize: 11)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 11, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}

// ── Puja Tab ──────────────────────────────────────────────────────────────────

class _PujaTab extends StatelessWidget {
  final PujaGuide? pujaGuide;
  final Color color;
  final AppLocalizations l;
  const _PujaTab(
      {required this.pujaGuide, required this.color, required this.l});

  @override
  Widget build(BuildContext context) {
    final guide = pujaGuide;
    if (guide == null) {
      return Center(child: CircularProgressIndicator(color: color));
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(children: [
          _MetaPill(Icons.timer_outlined, '~${guide.estimatedDuration} min',
              color),
        ]),
        if (guide.bestTiming != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.15)),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.access_time, size: 13, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  guide.bestTiming!,
                  style: TextStyle(
                      fontSize: 12,
                      color: color,
                      height: 1.5,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 20),
        Text(l.keyOfferings,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: BhakthiColors.deepInk,
                fontSize: 15,
                letterSpacing: -0.2)),
        const SizedBox(height: 12),
        ...guide.ingredients.map((ing) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BhakthiColors.line),
              ),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ing.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: BhakthiColors.deepInk)),
                      if ((ing.note ?? '').isNotEmpty)
                        Text(ing.note!,
                            style: const TextStyle(
                                color: BhakthiColors.textSecondary,
                                fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(ing.quantity,
                    style: const TextStyle(
                        color: BhakthiColors.textTertiary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ]),
            )),
        if ((guide.tips ?? []).isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.pujaNote,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: BhakthiColors.deepInk,
                  fontSize: 15,
                  letterSpacing: -0.2)),
          const SizedBox(height: 8),
          ...guide.tips!.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ',
                          style: TextStyle(
                              color: BhakthiColors.textTertiary,
                              fontSize: 13)),
                      Expanded(
                        child: Text(tip,
                            style: const TextStyle(
                                fontSize: 12,
                                color: BhakthiColors.textSecondary,
                                height: 1.55)),
                      ),
                    ]),
              )),
        ],
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaPill(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }
}

// ── Festivals Tab ─────────────────────────────────────────────────────────────

class _FestivalsTab extends StatelessWidget {
  final List<Festival>? festivals;
  const _FestivalsTab({required this.festivals});

  String _whenLine(Festival f) {
    final paksha = f.tithiPaksha == 'shukla' ? 'Shukla' : 'Krishna';
    final parts = ['$paksha Paksha, day ${f.tithiDay}'];
    if (f.gregorianApprox != null) parts.add(f.gregorianApprox!);
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final list = festivals;
    if (list == null) {
      return const Center(
          child: CircularProgressIndicator(color: BhakthiColors.rust));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final f = list[i];
        final localName = f.regionalNames?.isNotEmpty == true
            ? f.regionalNames!.first['localName'] ?? ''
            : '';
        return GestureDetector(
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(
                  builder: (_) => FestivalDetailScreen(festivalId: f.id))),
          child: _FestivalCard(
            name: f.name.english,
            localName: localName,
            when: _whenLine(f),
            desc: f.significance.english,
          ),
        );
      },
    );
  }
}

class _FestivalCard extends StatelessWidget {
  final String name;
  final String localName;
  final String when;
  final String desc;
  const _FestivalCard(
      {required this.name,
      required this.localName,
      required this.when,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: BhakthiColors.deepInk,
                  fontSize: 14,
                  letterSpacing: -0.2)),
          if (localName.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(localName,
                style: const TextStyle(
                    color: BhakthiColors.textTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
          const SizedBox(height: 8),
          Text(when,
              style: const TextStyle(
                  color: BhakthiColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Text(desc,
              style: const TextStyle(
                  color: BhakthiColors.textSecondary,
                  fontSize: 12,
                  height: 1.55)),
        ],
      ),
    );
  }
}

// ── Pinned Tab Bar ────────────────────────────────────────────────────────────

class _PinnedTabBar extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color color;
  const _PinnedTabBar(this.tabBar, {required this.color});

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          tabBar,
          Container(height: 1, color: BhakthiColors.line),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBar old) => old.color != color;
}
