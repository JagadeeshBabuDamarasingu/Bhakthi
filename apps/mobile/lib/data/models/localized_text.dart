class LocalizedText {
  final String? sanskrit;
  final String? transliteration;
  final String english;
  final String? hindi;
  final String? telugu;
  final String? tamil;
  final String? kannada;
  final String? malayalam;

  const LocalizedText({
    this.sanskrit,
    this.transliteration,
    required this.english,
    this.hindi,
    this.telugu,
    this.tamil,
    this.kannada,
    this.malayalam,
  });

  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText(
        sanskrit: json['sanskrit'] as String?,
        transliteration: json['transliteration'] as String?,
        english: (json['english'] as String?) ?? '',
        hindi: json['hindi'] as String?,
        telugu: json['telugu'] as String?,
        tamil: json['tamil'] as String?,
        kannada: json['kannada'] as String?,
        malayalam: json['malayalam'] as String?,
      );

  String forLocale(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return hindi ?? english;
      case 'te':
        return telugu ?? english;
      case 'ta':
        return tamil ?? english;
      case 'kn':
        return kannada ?? english;
      case 'ml':
        return malayalam ?? english;
      case 'sa':
        return sanskrit ?? english;
      default:
        return english;
    }
  }
}
