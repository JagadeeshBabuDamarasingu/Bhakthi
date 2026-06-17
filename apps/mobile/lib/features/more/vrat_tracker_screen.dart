import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

class VratTrackerScreen extends StatefulWidget {
  const VratTrackerScreen({super.key});

  @override
  State<VratTrackerScreen> createState() => _VratTrackerScreenState();
}

class _VratTrackerScreenState extends State<VratTrackerScreen> {
  List<VratRule>? _vratas;

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .listAllVratRules()
        .then((list) { if (mounted) setState(() => _vratas = list); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: const Text('Vrat Tracker'),
      ),
      body: _vratas == null
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : _vratas!.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _vratas!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _VratCard(vrat: _vratas![i]),
                ),
    );
  }
}

class _VratCard extends StatelessWidget {
  final VratRule vrat;
  const _VratCard({required this.vrat});

  String _recurrenceLabel() {
    switch (vrat.recurrence) {
      case 'monthly': return 'Every month';
      case 'weekly': return 'Every week';
      case 'yearly': return 'Once a year';
      default: return vrat.recurrence;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = deityColors[vrat.deity ?? ''] ?? BhakthiColors.emerald;
    final locale = Localizations.localeOf(context).languageCode;
    final name = vrat.name.forLocale(locale);
    final nameS = vrat.name.sanskrit;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VratDetailScreen(vrat: vrat))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('🌙', style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (nameS != null)
                Text(nameS,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: BhakthiColors.deepInk,
                        fontSize: 15,
                        letterSpacing: -0.2)),
              Text(name,
                  style: TextStyle(
                      color: nameS != null
                          ? BhakthiColors.textSecondary
                          : BhakthiColors.deepInk,
                      fontSize: nameS != null ? 12 : 15,
                      fontWeight: nameS != null ? FontWeight.w400 : FontWeight.w600)),
              const SizedBox(height: 5),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(_recurrenceLabel(),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color)),
                ),
              ]),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 11, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}

// ── Vrat Detail ───────────────────────────────────────────────────────────────

class VratDetailScreen extends StatelessWidget {
  final VratRule vrat;
  const VratDetailScreen({super.key, required this.vrat});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[vrat.deity ?? ''] ?? BhakthiColors.emerald;
    final locale = Localizations.localeOf(context).languageCode;
    final name = vrat.name.forLocale(locale);

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: Text(name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _InfoCard(
            text: vrat.description.forLocale(locale),
            color: color,
          ),
          const SizedBox(height: 20),
          _SignificanceCard(
            text: vrat.significance.forLocale(locale),
          ),
          if (vrat.whatToEat.isNotEmpty) ...[
            const SizedBox(height: 20),
            _ListSection(
              title: 'What to Eat',
              items: vrat.whatToEat,
              icon: Icons.restaurant_outlined,
              color: BhakthiColors.emerald,
            ),
          ],
          if (vrat.whatToAvoid.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ListSection(
              title: 'What to Avoid',
              items: vrat.whatToAvoid,
              icon: Icons.block_outlined,
              color: BhakthiColors.rust,
            ),
          ],
          if (vrat.prayersToRecite.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ListSection(
              title: 'Prayers to Recite',
              items: vrat.prayersToRecite,
              icon: Icons.menu_book_outlined,
              color: color,
            ),
          ],
          if (vrat.howToObserve != null && vrat.howToObserve!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _HowToSection(steps: vrat.howToObserve!),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final Color color;
  const _InfoCard({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14, color: BhakthiColors.textPrimary, height: 1.65)),
    );
  }
}

class _SignificanceCard extends StatelessWidget {
  final String text;
  const _SignificanceCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _Label('Significance'),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 14, color: BhakthiColors.textPrimary, height: 1.65)),
      ),
    ]);
  }
}

class _ListSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;
  const _ListSection(
      {required this.title,
      required this.items,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Label(title),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final isLast = i == items.length - 1;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                child: Row(children: [
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(items[i],
                        style: const TextStyle(
                            fontSize: 13, color: BhakthiColors.textPrimary)),
                  ),
                ]),
              ),
              if (!isLast)
                Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 38),
                    color: BhakthiColors.line),
            ]);
          }),
        ),
      ),
    ]);
  }
}

class _HowToSection extends StatelessWidget {
  final Map<String, List<String>> steps;
  const _HowToSection({required this.steps});

  @override
  Widget build(BuildContext context) {
    final allSteps = steps.values.expand((list) => list).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _Label('How to Observe'),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: Column(
          children: List.generate(allSteps.length, (i) {
            final isLast = i == allSteps.length - 1;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: BhakthiColors.emerald.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: BhakthiColors.emerald)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(allSteps[i],
                        style: const TextStyle(
                            fontSize: 13,
                            color: BhakthiColors.textPrimary,
                            height: 1.5)),
                  ),
                ]),
              ),
              if (!isLast)
                Container(
                    height: 1,
                    margin: const EdgeInsets.only(left: 46),
                    color: BhakthiColors.line),
            ]);
          }),
        ),
      ),
    ]);
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('🌙', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text('Vrat rules coming soon',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: BhakthiColors.textSecondary)),
        ]),
      ),
    );
  }
}
