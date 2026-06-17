import 'package:flutter/material.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';

class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen({super.key});

  // Native-script Om glyph per language — shown as the row accent
  static const _omGlyph = {
    'en': 'OM',
    'hi': 'ॐ',
    'te': 'ఓం',
    'ta': 'ஓம்',
    'kn': 'ಓಂ',
    'ml': 'ഓം',
    'bn': 'ওম',
    'mr': 'ॐ',
    'gu': 'ૐ',
    'pa': 'ੴ',
    'or': 'ଓ',
  };

  // Region/script label shown below the native name
  static const _scriptLabel = {
    'en': 'Latin',
    'hi': 'देवनागरी · Devanagari',
    'te': 'తెలుగు లిపి · Telugu script',
    'ta': 'தமிழ் எழுத்து · Tamil script',
    'kn': 'ಕನ್ನಡ ಲಿಪಿ · Kannada script',
    'ml': 'മലയാളം ലിപി · Malayalam script',
    'bn': 'বাংলা লিপি · Bengali script',
    'mr': 'देवनागरी · Devanagari',
    'gu': 'ગુજરાતી લિપિ · Gujarati script',
    'pa': 'ਗੁਰਮੁਖੀ · Gurmukhi script',
    'or': 'ଓଡ଼ିଆ ଲିପି · Odia script',
  };

  @override
  Widget build(BuildContext context) {
    final l       = AppLocalizations.of(context);
    final current = l.locale.languageCode;

    return Scaffold(
      backgroundColor: BhakthiColors.parchment,
      appBar: AppBar(
        backgroundColor: BhakthiColors.deepInk,
        title: Text(l.languageSelectTitle),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: AppLocalizations.supportedLocales.length,
        separatorBuilder: (_, __) => Container(
          height: 1,
          margin: const EdgeInsets.only(left: 76),
          color: BhakthiColors.line,
        ),
        itemBuilder: (context, i) {
          final locale   = AppLocalizations.supportedLocales[i];
          final code     = locale.languageCode;
          final name     = AppLocalizations.languageNames[code] ?? code;
          final selected = code == current;

          return _LanguageTile(
            locale:      locale,
            nativeName:  name,
            scriptLabel: _scriptLabel[code] ?? '',
            omGlyph:     _omGlyph[code] ?? 'ॐ',
            selected:    selected,
            onTap: () {
              BhakthiApp.of(context)?.setLocale(locale);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Locale locale;
  final String nativeName;
  final String scriptLabel;
  final String omGlyph;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.locale,
    required this.nativeName,
    required this.scriptLabel,
    required this.omGlyph,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Om glyph badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected
                    ? BhakthiColors.rust.withValues(alpha: 0.1)
                    : BhakthiColors.parchmentElev,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? BhakthiColors.rust.withValues(alpha: 0.35)
                      : BhakthiColors.lineStrong,
                ),
              ),
              child: Center(
                child: Text(
                  omGlyph,
                  style: TextStyle(
                    fontSize: omGlyph.length > 2 ? 11 : 16,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? BhakthiColors.rust
                        : BhakthiColors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? BhakthiColors.deepInk
                          : BhakthiColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scriptLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: BhakthiColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark
            if (selected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: BhakthiColors.rust,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(Icons.check,
                    size: 14, color: Colors.white),
              )
            else
              const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
