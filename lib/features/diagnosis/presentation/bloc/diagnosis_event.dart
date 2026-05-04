import 'package:equatable/equatable.dart';

abstract class DiagnosisEvent extends Equatable {
  const DiagnosisEvent();

  @override
  List<Object> get props => [];
}

class ToggleSymptom extends DiagnosisEvent {
  final String symptom;
  const ToggleSymptom(this.symptom);

  @override
  List<Object> get props => [symptom];
}

class UpdateTextSymptoms extends DiagnosisEvent {
  final String text;
  const UpdateTextSymptoms(this.text);

  @override
  List<Object> get props => [text];
}

class AnalyzeSymptoms extends DiagnosisEvent {
  const AnalyzeSymptoms();
}
