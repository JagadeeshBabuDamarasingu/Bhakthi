import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../deities/deity_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final h = DateTime.now().hour;
    final greeting     = h < 12 ? 'शुभ प्रभातम्' : h < 17 ? 'शुभ दिनम्' : 'शुभ संध्या';
    final greetingSub  = h < 12 ? l.greetingMorning : h < 17 ? l.greetingAfternoon : l.greetingEvening;

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
                  const _ShlokaCard(),
                  const SizedBox(height: 32),
                  _Label(l.labelDeities),
                  const SizedBox(height: 12),
                  _DeityRow(l: l),
                  const SizedBox(height: 32),
                  _Label(l.labelUpcoming),
                  const SizedBox(height: 12),
                  const _UpcomingItem(),
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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
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
    final days   = l.daysShort;
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
              style: const TextStyle(
                  fontSize: 14,
                  color: BhakthiColors.textSecondary)),
          Text(
            '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}',
            style: const TextStyle(
                fontSize: 14,
                color: BhakthiColors.textTertiary),
          ),
        ]),
      ],
    );
  }
}

class _ShlokaCard extends StatelessWidget {
  const _ShlokaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BhakthiColors.line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: BhakthiColors.rust.withOpacity(0.08),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: BhakthiColors.rust.withOpacity(0.25)),
            ),
            child: const Text('Ganesha',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: BhakthiColors.rust,
                    letterSpacing: 0.2)),
          ),
          const SizedBox(height: 16),
          const Text(
            'वक्रतुण्ड महाकाय\nसूर्यकोटि समप्रभ ।',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: BhakthiColors.deepInk,
              height: 1.7,
              letterSpacing: -0.2,
            ),
          ),
          const Text(
            'निर्विघ्नं कुरु मे देव\nसर्वकार्येषु सर्वदा ।।',
            style: TextStyle(
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
          const Text(
            'Vakratuṇḍa Mahākāya Sūryakoṭi Samaprabha\nNirvighnaṃ Kuru Me Deva Sarvakāryeṣu Sarvadā',
            style: TextStyle(
              fontSize: 12,
              color: BhakthiColors.textSecondary,
              height: 1.7,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'O Lord with a curved trunk and massive body, who shines with the brilliance of a million suns — please remove all obstacles from all my endeavours, always.',
            style: TextStyle(
              fontSize: 13,
              color: BhakthiColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeityRow extends StatelessWidget {
  final AppLocalizations l;
  const _DeityRow({required this.l});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _DeityChip(
            sanskrit: 'गणेश',
            color: BhakthiColors.rust,
            imagePath: 'assets/images/MahaGanapathi.png',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) =>
                        const DeityDetailScreen(deityId: 'ganesha'))),
          ),
          _comingSoon('लक्ष्मी',  BhakthiColors.mustard, l),
          _comingSoon('सरस्वती', BhakthiColors.teal,    l),
          _comingSoon('शिव',      BhakthiColors.indigo,  l),
          _comingSoon('विष्णु',   BhakthiColors.purple,  l),
        ],
      ),
    );
  }

  Widget _comingSoon(String name, Color color, AppLocalizations l) {
    return Container(
      width: 84,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('✦',
                style: TextStyle(
                    fontSize: 16, color: color.withOpacity(0.4))),
          ),
        ),
        const SizedBox(height: 6),
        Text(name,
            style: TextStyle(
                color: BhakthiColors.textPrimary.withOpacity(0.3),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _DeityChip extends StatelessWidget {
  final String sanskrit;
  final Color color;
  final String imagePath;
  final VoidCallback onTap;
  const _DeityChip(
      {required this.sanskrit,
      required this.color,
      required this.imagePath,
      required this.onTap});

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
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(imagePath,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(sanskrit,
              style: const TextStyle(
                  color: BhakthiColors.deepInk,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2)),
        ]),
      ),
    );
  }
}

class _UpcomingItem extends StatelessWidget {
  const _UpcomingItem();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: const Center(
            child: Text('🌙', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sankatahara Chaturthi',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: BhakthiColors.deepInk,
                      fontSize: 14,
                      letterSpacing: -0.2)),
              SizedBox(height: 3),
              Text('Monthly Ganesha fast — Krishna Paksha Chaturthi',
                  style: TextStyle(
                      color: BhakthiColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios,
            size: 12, color: BhakthiColors.textTertiary),
      ]),
    );
  }
}
