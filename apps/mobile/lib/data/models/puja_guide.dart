import 'localized_text.dart';

class Ingredient {
  final String name;
  final String quantity;
  final String? note;

  const Ingredient({
    required this.name,
    required this.quantity,
    this.note,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json['name'] as String,
        quantity: json['quantity'] as String,
        note: json['note'] as String?,
      );
}

class PujaStep {
  final int index;
  final LocalizedText title;
  final LocalizedText description;
  final String? mantra;
  final String? imageAsset;
  final int? durationMinutes;

  const PujaStep({
    required this.index,
    required this.title,
    required this.description,
    this.mantra,
    this.imageAsset,
    this.durationMinutes,
  });

  factory PujaStep.fromJson(Map<String, dynamic> json) => PujaStep(
        index: json['index'] as int,
        title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
        description: LocalizedText.fromJson(
            json['description'] as Map<String, dynamic>),
        mantra: json['mantra'] as String?,
        imageAsset: json['imageAsset'] as String?,
        durationMinutes: json['duration_minutes'] as int?,
      );
}

class PujaGuide {
  final String id;
  final LocalizedText title;
  final String deity;
  final int estimatedDuration;
  final String? bestTiming;
  final List<Ingredient> ingredients;
  final List<PujaStep> steps;
  final List<String> associatedMantras;
  final List<String>? tips;

  const PujaGuide({
    required this.id,
    required this.title,
    required this.deity,
    required this.estimatedDuration,
    this.bestTiming,
    required this.ingredients,
    required this.steps,
    required this.associatedMantras,
    this.tips,
  });

  factory PujaGuide.fromJson(Map<String, dynamic> json) => PujaGuide(
        id: json['id'] as String,
        title: LocalizedText.fromJson(json['title'] as Map<String, dynamic>),
        deity: json['deity'] as String,
        estimatedDuration: json['estimatedDuration'] as int,
        bestTiming: json['bestTiming'] as String?,
        ingredients: (json['ingredients'] as List)
            .map((i) => Ingredient.fromJson(i as Map<String, dynamic>))
            .toList(),
        steps: (json['steps'] as List)
            .map((s) => PujaStep.fromJson(s as Map<String, dynamic>))
            .toList(),
        associatedMantras:
            List<String>.from(json['associatedMantras'] as List? ?? []),
        tips: json['tips'] != null
            ? List<String>.from(json['tips'] as List)
            : null,
      );
}
