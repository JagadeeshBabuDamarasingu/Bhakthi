import 'localized_text.dart';

class Festival {
  final String id;
  final LocalizedText name;
  final String? deity;
  final int tithiMonth;
  final int tithiDay;
  final String tithiPaksha;
  final LocalizedText significance;
  final LocalizedText? mythology;
  final Map<String, List<String>>? howToObserve;
  final LocalizedText? foodGuidelines;
  final List<String> associatedStotras;
  final List<Map<String, String>>? regionalNames;
  final int? durationDays;
  final String? gregorianApprox;

  const Festival({
    required this.id,
    required this.name,
    this.deity,
    required this.tithiMonth,
    required this.tithiDay,
    required this.tithiPaksha,
    required this.significance,
    this.mythology,
    this.howToObserve,
    this.foodGuidelines,
    required this.associatedStotras,
    this.regionalNames,
    this.durationDays,
    this.gregorianApprox,
  });

  factory Festival.fromJson(Map<String, dynamic> json) => Festival(
        id: json['id'] as String,
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        deity: json['deity'] as String?,
        tithiMonth: json['tithiMonth'] as int,
        tithiDay: json['tithiDay'] as int,
        tithiPaksha: json['tithiPaksha'] as String,
        significance: LocalizedText.fromJson(
            json['significance'] as Map<String, dynamic>),
        mythology: json['mythology'] != null
            ? LocalizedText.fromJson(
                json['mythology'] as Map<String, dynamic>)
            : null,
        howToObserve: json['howToObserve'] != null
            ? (json['howToObserve'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, List<String>.from(v as List)),
              )
            : null,
        foodGuidelines: json['foodGuidelines'] != null
            ? LocalizedText.fromJson(
                json['foodGuidelines'] as Map<String, dynamic>)
            : null,
        associatedStotras:
            List<String>.from(json['associatedStotras'] as List? ?? []),
        regionalNames: json['regionalNames'] != null
            ? (json['regionalNames'] as List)
                .map((r) => Map<String, String>.from(r as Map))
                .toList()
            : null,
        durationDays: json['duration_days'] as int?,
        gregorianApprox: json['gregorianApprox'] as String?,
      );
}
