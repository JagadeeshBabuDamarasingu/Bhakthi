import 'localized_text.dart';

class Deity {
  final String id;
  final LocalizedText name;
  final String tradition;
  final List<String> aliases;
  final String? associatedDay;
  final String? primaryMantra;
  final String imageAsset;
  final LocalizedText description;
  final LocalizedText? significance;
  final Map<String, String>? iconography;
  final List<String> stotras;
  final List<String> mantras;
  final List<String> festivals;
  final String? pujaGuide;
  final List<String> colors;
  final List<String> flowers;
  final String? offering;
  final int? sacredNumber;

  const Deity({
    required this.id,
    required this.name,
    required this.tradition,
    required this.aliases,
    this.associatedDay,
    this.primaryMantra,
    required this.imageAsset,
    required this.description,
    this.significance,
    this.iconography,
    required this.stotras,
    required this.mantras,
    required this.festivals,
    this.pujaGuide,
    required this.colors,
    required this.flowers,
    this.offering,
    this.sacredNumber,
  });

  factory Deity.fromJson(Map<String, dynamic> json) => Deity(
        id: json['id'] as String,
        name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
        tradition: json['tradition'] as String,
        aliases: List<String>.from(json['aliases'] as List),
        associatedDay: json['associatedDay'] as String?,
        primaryMantra: json['primaryMantra'] as String?,
        imageAsset: json['imageAsset'] as String,
        description:
            LocalizedText.fromJson(json['description'] as Map<String, dynamic>),
        significance: json['significance'] != null
            ? LocalizedText.fromJson(
                json['significance'] as Map<String, dynamic>)
            : null,
        iconography: json['iconography'] != null
            ? Map<String, String>.from(json['iconography'] as Map)
            : null,
        stotras: List<String>.from(json['stotras'] as List? ?? []),
        mantras: List<String>.from(json['mantras'] as List? ?? []),
        festivals: List<String>.from(json['festivals'] as List? ?? []),
        pujaGuide: json['pujaGuide'] as String?,
        colors: List<String>.from(json['colors'] as List? ?? []),
        flowers: List<String>.from(json['flowers'] as List? ?? []),
        offering: json['offering'] as String?,
        sacredNumber: json['sacred_number'] as int?,
      );
}
