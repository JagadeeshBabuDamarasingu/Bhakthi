import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
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
  Map<String, dynamic>? _deity;

  static const _stotraMeta = {
    'ganesha_vakratunda':    ['वक्रतुण्ड महाकाय',         'Ganesha Invocation',        '1 verse'],
    'ganesha_dvadasha_nama': ['द्वादश नाम',                '12 Names of Ganesha',        '3 verses'],
    'ganesha_aarti':         ['जय गणेश आरती',             'Jai Ganesh Aarti',           '5 verses'],
    'ganesha_ashtottara':    ['अष्टोत्तर शतनामावलि',       '108 Names',                  '50 of 108'],
    'ganesha_pancharatnam':  ['गणेश पञ्चरत्नम्',           'Shankaracharya — 5 verses',  '5 verses'],
  };

  Color get _deityColor =>
      deityColors[widget.deityId] ?? BhakthiColors.rust;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    rootBundle
        .loadString('assets/content/deities/${widget.deityId}.json')
        .then((s) => setState(() => _deity = jsonDecode(s)));
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
            _StotrasTab(deity: _deity!, stotraMeta: _stotraMeta, color: _deityColor),
            _PujaTab(color: _deityColor, l: l),
            const _FestivalsTab(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildHero(BuildContext context) {
    final name = (_deity!['name'] as Map<String, dynamic>);
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: BhakthiColors.deepInk,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          Image.asset(
            _deity!['imageAsset'] as String? ?? 'assets/images/MahaGanapathi.png',
            fit: BoxFit.cover,
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
                  name['sanskrit'] as String? ?? '',
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
                  name['english'] as String? ?? '',
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

class _StotrasTab extends StatelessWidget {
  final Map<String, dynamic> deity;
  final Map<String, List<String>> stotraMeta;
  final Color color;

  const _StotrasTab({
    required this.deity,
    required this.stotraMeta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ids = (deity['stotras'] as List<dynamic>? ?? []).cast<String>();
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: ids.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final id = ids[i];
        final meta = stotraMeta[id];
        return _StotraRow(
          index: i + 1,
          sanskrit: meta?[0] ?? id,
          english: meta?[1] ?? '',
          detail: meta?[2] ?? '',
          color: color,
          onTap: () => Navigator.push(ctx,
              MaterialPageRoute(
                  builder: (_) => StotraDetailScreen(stotraId: id))),
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
                        color: BhakthiColors.textSecondary,
                        fontSize: 12)),
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

class _PujaTab extends StatelessWidget {
  final Color color;
  final AppLocalizations l;
  const _PujaTab({required this.color, required this.l});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(children: [
          _MetaPill(Icons.access_time, l.pujaDay, color),
          const SizedBox(width: 8),
          _MetaPill(Icons.timer_outlined, '~30 min', color),
        ]),
        const SizedBox(height: 20),
        Text(l.keyOfferings,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: BhakthiColors.deepInk,
                fontSize: 15,
                letterSpacing: -0.2)),
        const SizedBox(height: 12),
        ...[
          ('🌿', 'Durva grass',   '21 blades — most beloved offering'),
          ('🌸', 'Red hibiscus',  'Handful of flowers'),
          ('🍬', 'Modak',         '5 or 21 pieces'),
          ('🥥', 'Coconut',       '1 whole'),
          ('🪔', 'Ghee lamp',     'For aarti'),
        ].map((t) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BhakthiColors.line),
              ),
              child: Row(children: [
                Text(t.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.$2,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: BhakthiColors.deepInk)),
                      Text(t.$3,
                          style: const TextStyle(
                              color: BhakthiColors.textSecondary,
                              fontSize: 11)),
                    ],
                  ),
                ),
              ]),
            )),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BhakthiColors.parchmentElev,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BhakthiColors.line),
          ),
          child: Text(
            l.pujaNote,
            style: const TextStyle(
                fontSize: 12,
                color: BhakthiColors.textSecondary,
                height: 1.55),
          ),
        ),
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

class _FestivalsTab extends StatelessWidget {
  const _FestivalsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        _FestivalCard(
          name: 'Ganesh Chaturthi',
          localName: 'Vinayaka Chavithi',
          when: 'Bhadrapada Shukla Chaturthi · Aug–Sep',
          desc: 'The birthday of Lord Ganesha. Celebrated for 10 days across India with the installation and immersion of clay idols.',
        ),
        SizedBox(height: 12),
        _FestivalCard(
          name: 'Sankatahara Chaturthi',
          localName: 'Monthly fast',
          when: 'Every month · Krishna Paksha Chaturthi',
          desc: 'Monthly vrat dedicated to Ganesha. Fast broken after sighting the moon, with modak as offering.',
        ),
      ],
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
          const SizedBox(height: 2),
          Text(localName,
              style: const TextStyle(
                  color: BhakthiColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
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

class _PinnedTabBar extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color color;
  const _PinnedTabBar(this.tabBar, {required this.color});

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
