import 'package:equatable/equatable.dart';

enum DiagnosisStatus { initial, loading, success, failure }

class DiagnosisState extends Equatable {
  static const Object _sentinel = Object();

  final List<String> selectedSymptoms;
  final String textSymptoms;
  final DiagnosisStatus status;
  final String? error;
  final String diagnosisTitle;
  final String diagnosisSubtitle;
  final List<String> specialties;

  const DiagnosisState({
    required this.selectedSymptoms,
    required this.textSymptoms,
    required this.status,
    this.error,
    this.diagnosisTitle = '',
    this.diagnosisSubtitle = '',
    this.specialties = const [],
  });

  factory DiagnosisState.initial() {
    return const DiagnosisState(
      selectedSymptoms: [],
      textSymptoms: '',
      status: DiagnosisStatus.initial,
      diagnosisTitle: '',
      diagnosisSubtitle: '',
      specialties: [],
    );
  }

  DiagnosisState copyWith({
    List<String>? selectedSymptoms,
    String? textSymptoms,
    DiagnosisStatus? status,
    Object? error = _sentinel,
    String? diagnosisTitle,
    String? diagnosisSubtitle,
    List<String>? specialties,
  }) {
    return DiagnosisState(
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
      textSymptoms: textSymptoms ?? this.textSymptoms,
      status: status ?? this.status,
      error: identical(error, _sentinel) ? this.error : error as String?,
      diagnosisTitle: diagnosisTitle ?? this.diagnosisTitle,
      diagnosisSubtitle: diagnosisSubtitle ?? this.diagnosisSubtitle,
      specialties: specialties ?? this.specialties,
    );
  }

  @override
  List<Object?> get props => [
        selectedSymptoms,
        textSymptoms,
        status,
        error,
        diagnosisTitle,
        diagnosisSubtitle,
        specialties,
      ];
}
