import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import 'deity_detail_screen.dart';

class DeitiesScreen extends StatelessWidget {
  const DeitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        title: Text(l.screenDeities),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.80,
        children: [
          _DeityCard(
            name: 'Ganesha',
            sanskrit: 'गणेश',
            description: 'Remover of obstacles',
            tradition: 'Smarta',
            imagePath: 'assets/images/MahaGanapathi.png',
            deityId: 'ganesha',
            color: BhakthiColors.rust,
          ),
          _PlaceholderCard(name: 'Lakshmi',   sanskrit: 'लक्ष्मी',  desc: 'Goddess of wealth',  color: BhakthiColors.mustard, l: l),
          _PlaceholderCard(name: 'Saraswati', sanskrit: 'सरस्वती', desc: 'Goddess of wisdom',   color: BhakthiColors.teal,    l: l),
          _PlaceholderCard(name: 'Shiva',     sanskrit: 'शिव',      desc: 'The destroyer',       color: BhakthiColors.indigo,  l: l),
          _PlaceholderCard(name: 'Vishnu',    sanskrit: 'विष्णु',   desc: 'The preserver',       color: BhakthiColors.purple,  l: l),
        ],
      ),
    );
  }
}

class _DeityCard extends StatelessWidget {
  final String name;
  final String sanskrit;
  final String description;
  final String tradition;
  final String imagePath;
  final String deityId;
  final Color color;

  const _DeityCard({
    required this.name,
    required this.sanskrit,
    required this.description,
    required this.tradition,
    required this.imagePath,
    required this.deityId,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(
              builder: (_) => DeityDetailScreen(deityId: deityId))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BhakthiColors.line),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            Expanded(
              child: ClipRRect(
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sanskrit,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: BhakthiColors.deepInk,
                          letterSpacing: -0.3)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 11,
                          color: BhakthiColors.textSecondary)),
                  const SizedBox(height: 7),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(tradition,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                            letterSpacing: 0.3)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String name;
  final String sanskrit;
  final String desc;
  final Color color;
  final AppLocalizations l;

  const _PlaceholderCard({
    required this.name,
    required this.sanskrit,
    required this.desc,
    required this.color,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Expanded(
            child: Container(
              color: BhakthiColors.parchmentElev,
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('✦',
                          style: TextStyle(
                              fontSize: 20,
                              color: color.withOpacity(0.4))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l.comingSoon,
                      style: const TextStyle(
                          fontSize: 10,
                          color: BhakthiColors.textTertiary)),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sanskrit,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFCCCAC6),
                        letterSpacing: -0.3)),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 11,
                        color: BhakthiColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
