import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../stotras/stotra_detail_screen.dart';

class StotraLibraryScreen extends StatefulWidget {
  const StotraLibraryScreen({super.key});

  @override
  State<StotraLibraryScreen> createState() => _StotraLibraryScreenState();
}

class _StotraLibraryScreenState extends State<StotraLibraryScreen> {
  List<Stotra>? _all;
  String _filterDeity = 'all';
  String _query = '';
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .listAllStotras()
        .then((list) {
          list.sort((a, b) =>
              (a.title.transliteration ?? a.title.english)
                  .compareTo(b.title.transliteration ?? b.title.english));
          if (mounted) setState(() => _all = list);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Stotra> get _filtered {
    final list = _all ?? [];
    return list.where((s) {
      final matchesDeity = _filterDeity == 'all' || s.deity == _filterDeity;
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          s.title.english.toLowerCase().contains(q) ||
          (s.title.transliteration ?? '').toLowerCase().contains(q) ||
          s.deity.toLowerCase().contains(q);
      return matchesDeity && matchesQuery;
    }).toList();
  }

  List<String> get _deities {
    final all = _all ?? [];
    final seen = <String>{'all'};
    for (final s in all) {
      seen.add(s.deity);
    }
    return seen.toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: const Text('Stotra Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search stotras…',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                suffixIcon: _query.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        child: const Icon(Icons.close, color: Colors.white38, size: 18))
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _all == null
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : Column(children: [
              if (_deities.length > 2) _DeityFilterBar(
                deities: _deities,
                selected: _filterDeity,
                onSelect: (d) => setState(() => _filterDeity = d),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final s = filtered[i];
                          return _StotraCard(stotra: s);
                        },
                      ),
              ),
            ]),
    );
  }
}

class _DeityFilterBar extends StatelessWidget {
  final List<String> deities;
  final String selected;
  final ValueChanged<String> onSelect;
  const _DeityFilterBar({required this.deities, required this.selected, required this.onSelect});

  String _label(String d) {
    if (d == 'all') return 'All';
    return d.isEmpty ? d : d[0].toUpperCase() + d.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: deities.map((d) {
            final active = d == selected;
            final color = deityColors[d] ?? BhakthiColors.rust;
            return GestureDetector(
              onTap: () => onSelect(d),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: active ? color : BhakthiColors.lineStrong),
                ),
                child: Text(_label(d),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color: active ? Colors.white : BhakthiColors.textSecondary)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StotraCard extends StatelessWidget {
  final Stotra stotra;
  const _StotraCard({required this.stotra});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[stotra.deity] ?? BhakthiColors.rust;
    final sanskrit = stotra.title.sanskrit ?? stotra.title.transliteration;
    final deityLabel = stotra.deity.isEmpty
        ? ''
        : stotra.deity[0].toUpperCase() + stotra.deity.substring(1);

    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => StotraDetailScreen(stotraId: stotra.id))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              child: Text('ॐ', style: TextStyle(fontSize: 14, color: color.withOpacity(0.6))),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (sanskrit != null)
                Text(sanskrit,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: BhakthiColors.deepInk,
                        fontSize: 15,
                        letterSpacing: -0.2)),
              Text(stotra.title.english,
                  style: TextStyle(
                      color: sanskrit != null ? BhakthiColors.textSecondary : BhakthiColors.deepInk,
                      fontSize: sanskrit != null ? 12 : 15,
                      fontWeight: sanskrit != null ? FontWeight.w400 : FontWeight.w600)),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(deityLabel,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color)),
                ),
                const SizedBox(width: 6),
                Text('${stotra.verses.length} verses',
                    style: const TextStyle(
                        fontSize: 10, color: BhakthiColors.textTertiary)),
              ]),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios, size: 11, color: BhakthiColors.textTertiary),
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
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('🔍', style: TextStyle(fontSize: 40)),
        SizedBox(height: 12),
        Text('No stotras found',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: BhakthiColors.textSecondary)),
      ]),
    );
  }
}
