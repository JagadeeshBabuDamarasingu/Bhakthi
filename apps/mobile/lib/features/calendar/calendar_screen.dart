import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../festivals/festival_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Festival>? _festivals;

  @override
  void initState() {
    super.initState();
    ContentRepository.instance
        .listAllFestivals()
        .then((list) {
          list.sort((a, b) => a.tithiMonth.compareTo(b.tithiMonth));
          if (mounted) setState(() => _festivals = list);
        });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final now = DateTime.now();
    final days = l.daysLong;
    final months = l.monthsLong;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
          backgroundColor: BhakthiColors.deepInk,
          title: Text(l.screenCalendar)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _DateHero(now: now, days: days, months: months),
          const SizedBox(height: 20),
          _PanchangCard(l: l),
          const SizedBox(height: 24),
          _FestivalsSection(festivals: _festivals),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _DateHero extends StatelessWidget {
  final DateTime now;
  final List<String> days;
  final List<String> months;
  const _DateHero({required this.now, required this.days, required this.months});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BhakthiColors.deepInk,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(days[now.weekday % 7],
                    style: const TextStyle(
                        color: BhakthiColors.amberLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text('${now.day}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        height: 1.0,
                        letterSpacing: -2)),
                Text('${months[now.month - 1]} ${now.year}',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [BhakthiColors.rust, BhakthiColors.amber, BhakthiColors.purple],
              ),
            ),
            child: const Center(
              child: Text('ॐ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanchangCard extends StatelessWidget {
  final AppLocalizations l;
  const _PanchangCard({required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('पञ्चाङ्गम्',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: BhakthiColors.deepInk,
                  fontSize: 17,
                  letterSpacing: -0.3)),
          Text(l.panchang,
              style: const TextStyle(
                  fontSize: 12, color: BhakthiColors.textTertiary)),
          const SizedBox(height: 16),
          ...[
            'Tithi',
            'Nakshatra',
            'Yoga',
            'Rahu Kalam',
            'Abhijit Muhurta',
          ].map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(row,
                        style: const TextStyle(
                            color: BhakthiColors.textSecondary, fontSize: 13)),
                    const Text('—',
                        style: TextStyle(
                            color: BhakthiColors.textTertiary, fontSize: 13)),
                  ],
                ),
              )),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BhakthiColors.parchmentElev,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              l.panchangComing,
              style: const TextStyle(
                  fontSize: 12,
                  color: BhakthiColors.textTertiary,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _FestivalsSection extends StatelessWidget {
  final List<Festival>? festivals;
  const _FestivalsSection({required this.festivals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FESTIVALS',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: BhakthiColors.textTertiary),
        ),
        const SizedBox(height: 10),
        if (festivals == null)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(
                color: BhakthiColors.rust, strokeWidth: 2),
          ))
        else if (festivals!.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BhakthiColors.line),
            ),
            child: const Center(
              child: Text('Festival data coming soon',
                  style: TextStyle(
                      color: BhakthiColors.textTertiary, fontSize: 13)),
            ),
          )
        else
          ...festivals!.map((f) => _FestivalRow(festival: f)),
      ],
    );
  }
}

class _FestivalRow extends StatelessWidget {
  final Festival festival;
  const _FestivalRow({required this.festival});

  String _whenLine() {
    final paksha = festival.tithiPaksha == 'shukla' ? 'Shukla' : 'Krishna';
    final parts = ['$paksha Paksha, day ${festival.tithiDay}'];
    if (festival.gregorianApprox != null) parts.add(festival.gregorianApprox!);
    return parts.join(' · ');
  }

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
        padding: const EdgeInsets.all(14),
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
              color: BhakthiColors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('🪔', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(festival.name.forLocale(locale),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: BhakthiColors.deepInk,
                      fontSize: 14,
                      letterSpacing: -0.2)),
              const SizedBox(height: 3),
              Text(_whenLine(),
                  style: const TextStyle(
                      color: BhakthiColors.textSecondary, fontSize: 11)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 11, color: BhakthiColors.textTertiary),
        ]),
      ),
    );
  }
}
