import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/preferences/app_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';
import '../../shared/widgets/main_scaffold.dart';

// ── Deity data ────────────────────────────────────────────────────────────────

class _DeityInfo {
  final String id;
  final String english;
  final String sanskrit;
  final String initial;
  final Color color;
  const _DeityInfo(this.id, this.english, this.sanskrit, this.initial, this.color);
}

const _kDeities = [
  _DeityInfo('ganesha',   'Ganesha',   'गणेश',    'ग',  BhakthiColors.rust),
  _DeityInfo('lakshmi',   'Lakshmi',   'लक्ष्मी',  'ल',  BhakthiColors.mustard),
  _DeityInfo('saraswati', 'Saraswati', 'सरस्वती', 'स',  BhakthiColors.teal),
  _DeityInfo('shiva',     'Shiva',     'शिव',     'श',  BhakthiColors.indigo),
  _DeityInfo('vishnu',    'Vishnu',    'विष्णु',   'वि', BhakthiColors.purple),
  _DeityInfo('krishna',   'Krishna',   'कृष्ण',   'कृ', BhakthiColors.teal),
  _DeityInfo('rama',      'Rama',      'राम',     'र',  BhakthiColors.emerald),
  _DeityInfo('hanuman',   'Hanuman',   'हनुमान',  'ह',  BhakthiColors.amber),
];

// ── Language data ─────────────────────────────────────────────────────────────

const _kLanguages = [
  ('en', 'English',    'English'),
  ('hi', 'हिंदी',     'Hindi'),
  ('te', 'తెలుగు',    'Telugu'),
  ('ta', 'தமிழ்',     'Tamil'),
  ('kn', 'ಕನ್ನಡ',     'Kannada'),
  ('ml', 'മലയാളം',    'Malayalam'),
  ('bn', 'বাংলা',     'Bengali'),
  ('mr', 'मराठी',     'Marathi'),
  ('gu', 'ગુજરાતી',   'Gujarati'),
  ('pa', 'ਪੰਜਾਬੀ',   'Punjabi'),
  ('or', 'ଓଡ଼ିଆ',    'Odia'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  String _selectedLang = AppPreferences.languageCode;
  final Set<String> _selectedDeities = {'ganesha'};

  void _nextPage() {
    if (_page < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await AppPreferences.setLanguageCode(_selectedLang);
    await AppPreferences.setSelectedDeities(_selectedDeities.toList());
    await AppPreferences.setOnboardingComplete();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const MainScaffold(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  void _pickLanguage(String code) {
    setState(() => _selectedLang = code);
    BhakthiApp.of(context)?.setLocale(Locale(code));
  }

  void _toggleDeity(String id) {
    setState(() {
      if (_selectedDeities.contains(id)) {
        if (_selectedDeities.length > 1) _selectedDeities.remove(id);
      } else {
        _selectedDeities.add(id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedLang = AppPreferences.languageCode;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BhakthiColors.deepInk,
      body: SafeArea(
        child: Column(
          children: [
            // ── Page content ────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomePage(l: l),
                  _LanguagePage(
                    selectedCode: _selectedLang,
                    onPick: _pickLanguage,
                    l: l,
                  ),
                  _DeityPage(
                    selected: _selectedDeities,
                    onToggle: _toggleDeity,
                    l: l,
                  ),
                ],
              ),
            ),

            // ── Bottom bar ──────────────────────────────────────────────────
            _BottomBar(
              page: _page,
              onNext: _nextPage,
              l: l,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 0: Welcome ───────────────────────────────────────────────────────────

class _WelcomePage extends StatefulWidget {
  final AppLocalizations l;
  const _WelcomePage({required this.l});

  @override
  State<_WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<_WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _ac, curve: Curves.easeIn);
    _slide = Tween<double>(begin: 24, end: 0).animate(
        CurvedAnimation(parent: _ac, curve: Curves.easeOut));
    _ac.forward();
  }

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) => FadeTransition(
        opacity: _fade,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glow ॐ
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BhakthiColors.amber.withValues(alpha: 0.12),
                    boxShadow: [
                      BoxShadow(
                        color: BhakthiColors.amber.withValues(alpha: 0.28),
                        blurRadius: 48,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'ॐ',
                      style: TextStyle(
                        fontSize: 64,
                        color: BhakthiColors.amber,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                const Text(
                  'Bhakthi',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'भक्ति',
                  style: TextStyle(
                    fontSize: 16,
                    color: BhakthiColors.amber.withValues(alpha: 0.8),
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  'Your daily companion\nfor Hindu devotion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: BhakthiColors.amber.withValues(alpha: 0.2)),
                  ),
                  child: const Text(
                    'श्रद्धावान् लभते ज्ञानम्',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BhakthiColors.amberLight,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'The faithful one attains knowledge  —  Bhagavad Gita 4.39',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Page 1: Language ──────────────────────────────────────────────────────────

class _LanguagePage extends StatelessWidget {
  final String selectedCode;
  final void Function(String) onPick;
  final AppLocalizations l;
  const _LanguagePage({
    required this.selectedCode,
    required this.onPick,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your language',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'भाषा चुनें',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
              children: _kLanguages.map((lang) {
                final code    = lang.$1;
                final native  = lang.$2;
                final english = lang.$3;
                final selected = code == selectedCode;
                return GestureDetector(
                  onTap: () => onPick(code),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: selected
                          ? BhakthiColors.rust.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? BhakthiColors.rust
                            : Colors.white.withValues(alpha: 0.12),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                native,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.white.withValues(alpha: 0.85),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                english,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                              color: BhakthiColors.rust, size: 18),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Deity selection ───────────────────────────────────────────────────

class _DeityPage extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;
  final AppLocalizations l;
  const _DeityPage({
    required this.selected,
    required this.onToggle,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your Ishta Devata',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'इष्ट देवता',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select one or more deities you pray to.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.55,
              children: _kDeities.map((d) {
                final isSelected = selected.contains(d.id);
                return GestureDetector(
                  onTap: () => onToggle(d.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? d.color.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? d.color
                            : Colors.white.withValues(alpha: 0.1),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Color circle with Sanskrit initial
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: d.color.withValues(alpha: isSelected ? 0.3 : 0.15),
                              ),
                              child: Center(
                                child: Text(
                                  d.initial,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? d.color : d.color.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: d.color,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.white, size: 13),
                              )
                            else
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2)),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          d.sanskrit,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          d.english,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.45),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int page;
  final VoidCallback onNext;
  final AppLocalizations l;
  const _BottomBar({required this.page, required this.onNext, required this.l});

  @override
  Widget build(BuildContext context) {
    final isLast = page == 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      color: BhakthiColors.deepInk,
      child: Row(
        children: [
          // Page dots
          Row(
            children: List.generate(3, (i) {
              final active = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 6),
                width: active ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? BhakthiColors.amber
                      : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const Spacer(),
          // Next / Get Started button
          GestureDetector(
            onTap: onNext,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              decoration: BoxDecoration(
                color: isLast ? BhakthiColors.rust : BhakthiColors.amber,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (isLast ? BhakthiColors.rust : BhakthiColors.amber)
                        .withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLast ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isLast ? Icons.auto_awesome : Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
