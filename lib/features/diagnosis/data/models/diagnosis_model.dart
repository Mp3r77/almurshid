import '../../domain/entities/diagnosis_entity.dart';

class DiagnosisModel extends DiagnosisEntity {
  const DiagnosisModel({
    required super.possibleConditions,
    required super.advice,
    required super.urgencyLevel,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      possibleConditions: List<String>.from(json['possibleConditions'] ?? []),
      advice: json['advice'] ?? '',
      urgencyLevel: json['urgencyLevel'] ?? 'low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'possibleConditions': possibleConditions,
      'advice': advice,
      'urgencyLevel': urgencyLevel,
    };
  }
}
