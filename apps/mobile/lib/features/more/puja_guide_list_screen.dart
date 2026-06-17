import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

class PujaGuideListScreen extends StatefulWidget {
  const PujaGuideListScreen({super.key});

  @override
  State<PujaGuideListScreen> createState() => _PujaGuideListScreenState();
}

class _PujaGuideListScreenState extends State<PujaGuideListScreen> {
  List<PujaGuide>? _guides;

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .listAllPujaGuides()
        .then((list) { if (mounted) setState(() => _guides = list); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: const Text('Puja Guides'),
      ),
      body: _guides == null
          ? const Center(child: CircularProgressIndicator(color: BhakthiColors.rust))
          : _guides!.isEmpty
              ? const _EmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _guides!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => _PujaGuideCard(guide: _guides![i]),
                ),
    );
  }
}

class _PujaGuideCard extends StatelessWidget {
  final PujaGuide guide;
  const _PujaGuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[guide.deity] ?? BhakthiColors.rust;
    final locale = Localizations.localeOf(context).languageCode;
    final title = guide.title.forLocale(locale);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PujaGuideDetailScreen(guide: guide))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BhakthiColors.line),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(15)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text('🪔', style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: BhakthiColors.deepInk,
                                  fontSize: 15,
                                  letterSpacing: -0.2)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                guide.deity.isEmpty
                                    ? ''
                                    : guide.deity[0].toUpperCase() +
                                        guide.deity.substring(1),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: color),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.timer_outlined,
                                size: 11,
                                color: BhakthiColors.textTertiary),
                            const SizedBox(width: 3),
                            Text('~${guide.estimatedDuration} min',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: BhakthiColors.textTertiary)),
                            const SizedBox(width: 8),
                            Text('${guide.steps.length} steps',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: BhakthiColors.textTertiary)),
                          ]),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 11, color: BhakthiColors.textTertiary),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Puja Guide Detail ─────────────────────────────────────────────────────────

class PujaGuideDetailScreen extends StatelessWidget {
  final PujaGuide guide;
  const PujaGuideDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final color = deityColors[guide.deity] ?? BhakthiColors.rust;
    final locale = Localizations.localeOf(context).languageCode;
    final title = guide.title.forLocale(locale);

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Text(
              '~${guide.estimatedDuration} min  ·  ${guide.steps.length} steps',
              style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (guide.bestTiming != null)
            _InfoBanner(icon: Icons.access_time, text: guide.bestTiming!, color: color),
          if (guide.steps.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionHeader('Steps'),
            const SizedBox(height: 10),
            ...List.generate(guide.steps.length, (i) {
              final step = guide.steps[i];
              final stepTitle = step.title.forLocale(locale);
              final stepDesc = step.description.forLocale(locale);
              final isLast = i == guide.steps.length - 1;
              return _StepCard(
                index: i + 1,
                title: stepTitle,
                description: stepDesc,
                mantra: step.mantra,
                duration: step.durationMinutes,
                color: color,
                isLast: isLast,
              );
            }),
          ],
          if (guide.ingredients.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionHeader('Ingredients'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BhakthiColors.line),
              ),
              child: Column(
                children: List.generate(guide.ingredients.length, (i) {
                  final ing = guide.ingredients[i];
                  final isLast = i == guide.ingredients.length - 1;
                  return Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ing.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
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
                        Text(ing.quantity,
                            style: const TextStyle(
                                color: BhakthiColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ]),
                    ),
                    if (!isLast)
                      Container(
                          height: 1,
                          margin: const EdgeInsets.only(left: 16),
                          color: BhakthiColors.line),
                  ]);
                }),
              ),
            ),
          ],
          if ((guide.tips ?? []).isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionHeader('Notes'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: guide.tips!.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ',
                                style: TextStyle(
                                    color: color,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Text(tip,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: BhakthiColors.textPrimary,
                                      height: 1.55)),
                            ),
                          ]),
                    )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoBanner({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                  height: 1.4)),
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

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

class _StepCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final String? mantra;
  final int? duration;
  final Color color;
  final bool isLast;
  const _StepCard({
    required this.index,
    required this.title,
    required this.description,
    required this.mantra,
    required this.duration,
    required this.color,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: color.withOpacity(0.2),
            ),
        ]),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BhakthiColors.line),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: BhakthiColors.deepInk)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        fontSize: 13,
                        color: BhakthiColors.textSecondary,
                        height: 1.55)),
                if (mantra != null && mantra!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(mantra!,
                        style: TextStyle(
                            fontSize: 13,
                            color: color,
                            fontWeight: FontWeight.w600,
                            height: 1.6)),
                  ),
                ],
                if (duration != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.timer_outlined, size: 11, color: color.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text('~$duration min',
                        style: TextStyle(
                            fontSize: 11,
                            color: color.withOpacity(0.7),
                            fontWeight: FontWeight.w500)),
                  ]),
                ],
              ]),
            ),
          ),
        ),
      ],
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
          Text('🪔', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text('Puja guides coming soon',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: BhakthiColors.textSecondary)),
        ]),
      ),
    );
  }
}
