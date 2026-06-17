import 'localized_text.dart';

class VratRule {
  final String id;
  final LocalizedText name;
  final String? deity;
  final String recurrence;
  final String? paksha;
  final int? tithi;
  final int? weekday;
  final LocalizedText description;
  final List<String> whatToEat;
  final List<String> whatToAvoid;
  final List<String> prayersToRecite;
  final LocalizedText significance;
  final Map<String, List<String>>? howToObserve;

  const VratRule({
    required this.id,
    required this.name,
    this.deity,
    required this.recurrence,
    this.paksha,
    this.tithi,
    this.weekday,
    required this.description,
    required this.whatToEat,
    required this.whatToAvoid,
    required this.prayersToRecite,
    required this.significance,
    this.howToObserve,
  });

  factory VratRule.fromJson(Map<String, dynamic> json) => VratRule(
        id: json['id'] as String,
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        deity: json['deity'] as String?,
        recurrence: json['recurrence'] as String,
        paksha: json['paksha'] as String?,
        tithi: json['tithi'] as int?,
        weekday: json['weekday'] as int?,
        description: LocalizedText.fromJson(
            json['description'] as Map<String, dynamic>),
        whatToEat: List<String>.from(json['whatToEat'] as List? ?? []),
        whatToAvoid: List<String>.from(json['whatToAvoid'] as List? ?? []),
        prayersToRecite:
            List<String>.from(json['prayersToRecite'] as List? ?? []),
        significance: LocalizedText.fromJson(
            json['significance'] as Map<String, dynamic>),
        howToObserve: json['howToObserve'] != null
            ? (json['howToObserve'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, List<String>.from(v as List)),
              )
            : null,
      );
}
