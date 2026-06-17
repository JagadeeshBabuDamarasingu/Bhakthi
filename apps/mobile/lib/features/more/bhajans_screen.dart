import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class _BhajanItem {
  final String title;
  final String deity;
  final String language;
  final String type;
  final Color color;
  const _BhajanItem(this.title, this.deity, this.language, this.type, this.color);
}

const _bhajans = [
  _BhajanItem('Jai Ganesh Jai Ganesh Deva', 'Ganesha', 'Hindi', 'Aarti', BhakthiColors.rust),
  _BhajanItem('Om Jai Jagdish Hare', 'Vishnu', 'Hindi', 'Aarti', BhakthiColors.purple),
  _BhajanItem('Jai Ambe Gauri', 'Durga', 'Hindi', 'Aarti', BhakthiColors.pink),
  _BhajanItem('Om Jai Shiv Omkara', 'Shiva', 'Hindi', 'Aarti', BhakthiColors.indigo),
  _BhajanItem('Jai Lakshmi Mata', 'Lakshmi', 'Hindi', 'Aarti', BhakthiColors.mustard),
  _BhajanItem('Hare Krishna Hare Krishna', 'Krishna', 'Sanskrit', 'Kirtan', BhakthiColors.teal),
  _BhajanItem('Raghupati Raghava Raja Ram', 'Rama', 'Hindi', 'Bhajan', BhakthiColors.emerald),
  _BhajanItem('Hanuman Chalisa', 'Hanuman', 'Hindi', 'Bhajan', BhakthiColors.amber),
  _BhajanItem('Venkatesha Suprabhatam', 'Venkateshwara', 'Sanskrit', 'Suprabhatam', BhakthiColors.purple),
  _BhajanItem('Aigiri Nandini', 'Durga', 'Sanskrit', 'Bhajan', BhakthiColors.pink),
  _BhajanItem('Subrahmanya Bhujangam', 'Murugan', 'Sanskrit', 'Bhajan', BhakthiColors.rust),
  _BhajanItem('Mere To Giridhar Gopal', 'Krishna', 'Hindi', 'Bhajan', BhakthiColors.teal),
];

class BhajansScreen extends StatefulWidget {
  const BhajansScreen({super.key});

  @override
  State<BhajansScreen> createState() => _BhajansScreenState();
}

class _BhajansScreenState extends State<BhajansScreen> {
  String _filter = 'All';

  static const _filters = ['All', 'Aarti', 'Bhajan', 'Kirtan'];

  List<_BhajanItem> get _filtered =>
      _filter == 'All' ? _bhajans : _bhajans.where((b) => b.type == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        foregroundColor: Colors.white,
        title: const Text('Bhajans & Aarti'),
      ),
      body: Column(children: [
        _FilterBar(filters: _filters, selected: _filter, onSelect: (f) => setState(() => _filter = f)),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _BhajanCard(item: _filtered[i]),
          ),
        ),
      ]),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;
  const _FilterBar({required this.filters, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: filters.map((f) {
            final active = f == selected;
            return GestureDetector(
              onTap: () => onSelect(f),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? BhakthiColors.rust : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                      color: active ? BhakthiColors.rust : BhakthiColors.lineStrong),
                ),
                child: Text(f,
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

class _BhajanCard extends StatelessWidget {
  final _BhajanItem item;
  const _BhajanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BhakthiColors.line),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(Icons.music_note, size: 20, color: item.color.withOpacity(0.7)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: BhakthiColors.deepInk,
                    fontSize: 14,
                    letterSpacing: -0.2)),
            const SizedBox(height: 4),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(item.deity,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: item.color)),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: BhakthiColors.parchmentElev,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(item.type,
                    style: const TextStyle(
                        fontSize: 10,
                        color: BhakthiColors.textTertiary)),
              ),
              const SizedBox(width: 6),
              Text(item.language,
                  style: const TextStyle(
                      fontSize: 10, color: BhakthiColors.textTertiary)),
            ]),
          ]),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: BhakthiColors.parchmentElev,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow,
              size: 18, color: BhakthiColors.textTertiary),
        ),
      ]),
    );
  }
}
