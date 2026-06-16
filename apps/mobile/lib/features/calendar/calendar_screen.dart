import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
    final months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
          backgroundColor: BhakthiColors.deepInk,
          title: const Text('Calendar')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Date hero block
          Container(
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
                      Text(
                        '${now.day}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.w300,
                            height: 1.0,
                            letterSpacing: -2),
                      ),
                      Text(
                        '${months[now.month - 1]} ${now.year}',
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                // Gradient OM mark
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
          ),
          const SizedBox(height: 20),
          Container(
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
                const Text('Panchang',
                    style: TextStyle(
                        fontSize: 12,
                        color: BhakthiColors.textTertiary)),
                const SizedBox(height: 16),
                ...[
                  ('Tithi',            '—'),
                  ('Nakshatra',         '—'),
                  ('Yoga',             '—'),
                  ('Rahu Kalam',       '—'),
                  ('Abhijit Muhurta',  '—'),
                ].map((row) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(row.$1,
                              style: const TextStyle(
                                  color: BhakthiColors.textSecondary,
                                  fontSize: 13)),
                          Text(row.$2,
                              style: const TextStyle(
                                  color: BhakthiColors.textTertiary,
                                  fontSize: 13)),
                        ],
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BhakthiColors.parchmentElev,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Panchang calculations coming in the next update.',
                    style: TextStyle(
                        fontSize: 12,
                        color: BhakthiColors.textTertiary,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
