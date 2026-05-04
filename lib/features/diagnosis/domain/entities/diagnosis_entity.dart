import 'package:equatable/equatable.dart';

class DiagnosisEntity extends Equatable {
  final List<String> possibleConditions;
  final String advice;
  final String urgencyLevel; // 'low', 'medium', 'high'

  const DiagnosisEntity({
    required this.possibleConditions,
    required this.advice,
    required this.urgencyLevel,
  });

  @override
  List<Object?> get props => [possibleConditions, advice, urgencyLevel];
}
