import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../deities/deity_detail_screen.dart';
import '../festivals/festival_detail_screen.dart';
import '../stotras/stotra_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _loading = false;

  List<Deity> _deities = [];
  List<Stotra> _stotras = [];
  List<Festival> _festivals = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final repo = ContentRepository.instance;
    final results = await Future.wait([
      repo.listDeities(),
      repo.listAllStotras(),
      repo.listAllFestivals(),
    ]);
    if (mounted) {
      setState(() {
        _deities = results[0] as List<Deity>;
        _stotras = results[1] as List<Stotra>;
        _festivals = results[2] as List<Festival>;
        _loading = false;
        _loaded = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Deity> get _matchedDeities {
    final q = _query.toLowerCase();
    if (q.isEmpty) return [];
    return _deities.where((d) =>
        d.name.english.toLowerCase().contains(q) ||
        (d.name.sanskrit ?? '').contains(q) ||
        d.aliases.any((a) => a.toLowerCase().contains(q))).toList();
  }

  List<Stotra> get _matchedStotras {
    final q = _query.toLowerCase();
    if (q.isEmpty) return [];
    return _stotras.where((s) =>
        s.title.english.toLowerCase().contains(q) ||
        (s.title.transliteration ?? '').toLowerCase().contains(q) ||
        (s.title.sanskrit ?? '').contains(q) ||
        s.deity.toLowerCase().contains(q)).toList();
  }

  List<Festival> get _matchedFestivals {
    final q = _query.toLowerCase();
    if (q.isEmpty) return [];
    return _festivals.where((f) =>
        f.name.english.toLowerCase().contains(q) ||
        (f.name.sanskrit ?? '').contains(q) ||
        (f.gregorianApprox ?? '').toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final deities = _matchedDeities;
    final stotras = _matchedStotras;
    final festivals = _matchedFestivals;
    final hasResults = deities.isNotEmpty || stotras.isNotEmpty || festivals.isNotEmpty;
    final showEmpty = _query.length >= 2 && _loaded && !hasResults;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search deities, stotras, festivals…',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                    child: const Icon(Icons.close, color: Colors.white38, size: 18))
                : null,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : _query.isEmpty
              ? const _Suggestions()
              : showEmpty
                  ? const _NoResults()
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (deities.isNotEmpty) ...[
                          _SectionLabel('Deities'),
                          const SizedBox(height: 8),
                          ...deities.map((d) => _DeityResult(deity: d)),
                          const SizedBox(height: 20),
                        ],
                        if (stotras.isNotEmpty) ...[
                          _SectionLabel('Stotras'),
                          const SizedBox(height: 8),
                          ...stotras.map((s) => _StotraResult(stotra: s)),
                          const SizedBox(height: 20),
                        ],
                        if (festivals.isNotEmpty) ...[
                          _SectionLabel('Festivals'),
                          const SizedBox(height: 8),
                          ...festivals.map((f) => _FestivalResult(festival: f)),
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

class _ResultTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ResultTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: BhakthiColors.deepInk)),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: BhakthiColors.textTertiary)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 10, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}

class _DeityResult extends StatelessWidget {
  final Deity deity;
  const _DeityResult({required this.deity});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[deity.id] ?? BhakthiColors.rust;
    return _ResultTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text('✦', style: TextStyle(fontSize: 12, color: color.withOpacity(0.6))),
        ),
      ),
      title: deity.name.sanskrit ?? deity.name.english,
      subtitle: deity.name.english,
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DeityDetailScreen(deityId: deity.id))),
    );
  }
}

class _StotraResult extends StatelessWidget {
  final Stotra stotra;
  const _StotraResult({required this.stotra});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[stotra.deity] ?? BhakthiColors.rust;
    final title = stotra.title.sanskrit ??
        stotra.title.transliteration ??
        stotra.title.english;
    final deityLabel = stotra.deity.isEmpty
        ? 'Stotra'
        : '${stotra.deity[0].toUpperCase()}${stotra.deity.substring(1)}';

    return _ResultTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(Icons.menu_book_outlined,
              size: 14, color: color.withOpacity(0.7)),
        ),
      ),
      title: title,
      subtitle: '$deityLabel · ${stotra.verses.length} verses',
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => StotraDetailScreen(stotraId: stotra.id))),
    );
  }
}

class _FestivalResult extends StatelessWidget {
  final Festival festival;
  const _FestivalResult({required this.festival});

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: BhakthiColors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('🪔', style: TextStyle(fontSize: 14))),
      ),
      title: festival.name.sanskrit ?? festival.name.english,
      subtitle: festival.gregorianApprox ?? festival.name.english,
      onTap: () => Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => FestivalDetailScreen(festivalId: festival.id))),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('🔍', style: TextStyle(fontSize: 40)),
          SizedBox(height: 12),
          Text('Search for deities, stotras, or festivals',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: BhakthiColors.textSecondary,
                  height: 1.5)),
        ]),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('😔', style: TextStyle(fontSize: 40)),
          SizedBox(height: 12),
          Text('No results found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: BhakthiColors.textSecondary)),
          SizedBox(height: 6),
          Text('Try a different keyword',
              style: TextStyle(fontSize: 13, color: BhakthiColors.textTertiary)),
        ]),
      ),
    );
  }
}
