import 'localized_text.dart';

class Verse {
  final int index;
  final String sanskrit;
  final String transliteration;
  final String? hindi;
  final String? telugu;
  final String? tamil;
  final String english;
  final String? audioUrl;
  final int? audioTimestamp;

  const Verse({
    required this.index,
    required this.sanskrit,
    required this.transliteration,
    this.hindi,
    this.telugu,
    this.tamil,
    required this.english,
    this.audioUrl,
    this.audioTimestamp,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        index: json['index'] as int,
        sanskrit: json['sanskrit'] as String,
        transliteration: json['transliteration'] as String,
        hindi: json['hindi'] as String?,
        telugu: json['telugu'] as String?,
        tamil: json['tamil'] as String?,
        english: (json['english'] as String?) ?? '',
        audioUrl: json['audioUrl'] as String?,
        audioTimestamp: json['audioTimestamp'] as int?,
      );

  String? forLocale(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return hindi;
      case 'te':
        return telugu;
      case 'ta':
        return tamil;
      default:
        return null;
    }
  }
}

class Stotra {
  final String id;
  final LocalizedText title;
  final String deity;
  final String type;
  final List<Verse> verses;
  final LocalizedText? description;
  final String? audioUrl;
  final List<String> tags;

  const Stotra({
    required this.id,
    required this.title,
    required this.deity,
    required this.type,
    required this.verses,
    this.description,
    this.audioUrl,
    required this.tags,
  });

  factory Stotra.fromJson(Map<String, dynamic> json) => Stotra(
        id: json['id'] as String,
        title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
        deity: json['deity'] as String,
        type: json['type'] as String,
        verses: (json['verses'] as List)
            .map((v) => Verse.fromJson(v as Map<String, dynamic>))
            .toList(),
        description: json['description'] != null
            ? LocalizedText.fromJson(
                json['description'] as Map<String, dynamic>)
            : null,
        audioUrl: json['audioUrl'] as String?,
        tags: List<String>.from(json['tags'] as List? ?? []),
      );
}
