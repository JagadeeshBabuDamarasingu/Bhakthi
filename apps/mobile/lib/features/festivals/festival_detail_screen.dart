import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../stotras/stotra_detail_screen.dart';

class FestivalDetailScreen extends StatefulWidget {
  final String festivalId;
  const FestivalDetailScreen({super.key, required this.festivalId});

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreenState();
}

class _FestivalDetailScreenState extends State<FestivalDetailScreen> {
  Festival? _festival;

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .getFestival(widget.festivalId)
        .then((f) { if (mounted) setState(() => _festival = f); });
  }

  @override
  Widget build(BuildContext context) {
    final f = _festival;
    if (f == null) {
      return Scaffold(
        backgroundColor: BhakthiColors.parchment,
        appBar: AppBar(backgroundColor: BhakthiColors.deepInk),
        body: const Center(child: CircularProgressIndicator(color: BhakthiColors.rust)),
      );
    }
    return _FestivalDetailView(festival: f);
  }
}

class _FestivalDetailView extends StatelessWidget {
  final Festival festival;
  const _FestivalDetailView({required this.festival});

  String _tithiLine() {
    final paksha = festival.tithiPaksha == 'shukla' ? 'Shukla' : 'Krishna';
    final parts = ['$paksha Paksha, Day ${festival.tithiDay}'];
    if (festival.gregorianApprox != null) parts.add(festival.gregorianApprox!);
    if (festival.durationDays != null && festival.durationDays! > 1) {
      parts.add('${festival.durationDays} days');
    }
    return parts.join('  ·  ');
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final name = festival.name.forLocale(locale);
    final sanskrit = festival.name.sanskrit;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      body: CustomScrollView(
        slivers: [
          _FestivalHero(name: name, sanskrit: sanskrit, tithiLine: _tithiLine()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionBlock(
                    title: 'Significance',
                    body: festival.significance.forLocale(locale),
                  ),
                  if (festival.mythology != null) ...[
                    const SizedBox(height: 24),
                    _SectionBlock(
                      title: 'Mythology',
                      body: festival.mythology!.forLocale(locale),
                    ),
                  ],
                  if ((festival.howToObserve?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 24),
                    _HowToObserveSection(steps: festival.howToObserve!),
                  ],
                  if (festival.foodGuidelines != null) ...[
                    const SizedBox(height: 24),
                    _SectionBlock(
                      title: 'Food Guidelines',
                      body: festival.foodGuidelines!.forLocale(locale),
                    ),
                  ],
                  if (festival.associatedStotras.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _AssociatedStotrasSection(stotraIds: festival.associatedStotras),
                  ],
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

class _FestivalHero extends StatelessWidget {
  final String name;
  final String? sanskrit;
  final String tithiLine;
  const _FestivalHero({required this.name, required this.sanskrit, required this.tithiLine});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
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
                colors: [Color(0xFF2A1F10), BhakthiColors.deepInk],
              ),
            ),
            child: Center(
              child: Text('🪔',
                  style: const TextStyle(fontSize: 72)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, BhakthiColors.deepInk.withOpacity(0.9)],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 56,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: BhakthiColors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (sanskrit != null)
                  Text(sanskrit!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          height: 1.2)),
                Text(name,
                    style: TextStyle(
                        color: Colors.white.withOpacity(sanskrit != null ? 0.65 : 1),
                        fontSize: sanskrit != null ? 14 : 26,
                        fontWeight: sanskrit != null ? FontWeight.w400 : FontWeight.w700)),
                const SizedBox(height: 6),
                Text(tithiLine,
                    style: const TextStyle(
                        color: BhakthiColors.amberLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String body;
  const _SectionBlock({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BhakthiColors.line),
          ),
          child: Text(
            body,
            style: const TextStyle(
                fontSize: 14,
                color: BhakthiColors.textPrimary,
                height: 1.65),
          ),
        ),
      ],
    );
  }
}

class _HowToObserveSection extends StatelessWidget {
  final Map<String, List<String>> steps;
  const _HowToObserveSection({required this.steps});

  @override
  Widget build(BuildContext context) {
    final allSteps = steps.values.expand((list) => list).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('How to Observe'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BhakthiColors.line),
          ),
          child: Column(
            children: List.generate(allSteps.length, (i) {
              final isLast = i == allSteps.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: BhakthiColors.rust.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: BhakthiColors.rust),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            allSteps[i],
                            style: const TextStyle(
                                fontSize: 13,
                                color: BhakthiColors.textPrimary,
                                height: 1.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                        height: 1,
                        margin: const EdgeInsets.only(left: 52),
                        color: BhakthiColors.line),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AssociatedStotrasSection extends StatelessWidget {
  final List<String> stotraIds;
  const _AssociatedStotrasSection({required this.stotraIds});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Associated Stotras'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: stotraIds.map((id) {
            final label = id
                .replaceAll('_', ' ')
                .split(' ')
                .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
                .join(' ');
            return GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => StotraDetailScreen(stotraId: id))),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: BhakthiColors.rust.withOpacity(0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.menu_book_outlined, size: 13, color: BhakthiColors.rust),
                  const SizedBox(width: 6),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: BhakthiColors.rust)),
                ]),
              ),
            );
          }).toList(),
        ),
      ],
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
