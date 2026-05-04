import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almurshid/core/services/ai_diagnosis_service.dart';

import 'diagnosis_event.dart';
import 'diagnosis_state.dart';

class DiagnosisBloc extends Bloc<DiagnosisEvent, DiagnosisState> {
  DiagnosisBloc() : super(DiagnosisState.initial()) {
    on<AnalyzeSymptoms>(_onAnalyzeSymptoms);
    on<UpdateTextSymptoms>(_onUpdateTextSymptoms);
    on<ToggleSymptom>(_onToggleSymptom);
  }

  Future<void> _onAnalyzeSymptoms(
    AnalyzeSymptoms event,
    Emitter<DiagnosisState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DiagnosisStatus.loading, error: null));

      final allSymptoms = [
        if (state.textSymptoms.trim().isNotEmpty) state.textSymptoms.trim(),
        ...state.selectedSymptoms,
      ].join(', ');

      if (allSymptoms.isEmpty) {
        emit(state.copyWith(
          status: DiagnosisStatus.failure,
          error: 'يرجى إدخال الأعراض أو اختيار أكثر من عرض',
        ));
        return;
      }

      final aiResult = await AiDiagnosisService.getDiagnosis(allSymptoms);
      final specialties = List<String>.from(
        aiResult['specialties'] as List<dynamic>,
      );

      emit(state.copyWith(
        status: DiagnosisStatus.success,
        diagnosisTitle: aiResult['title'] as String,
        diagnosisSubtitle: aiResult['subtitle'] as String,
        specialties: specialties,
        error: null,
      ));
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '').trim();
      emit(state.copyWith(
        status: DiagnosisStatus.failure,
        error: message.isEmpty
            ? 'حدث خطأ أثناء تحليل الأعراض. حاول مرة أخرى.'
            : message,
      ));
    }
  }

  void _onUpdateTextSymptoms(
    UpdateTextSymptoms event,
    Emitter<DiagnosisState> emit,
  ) {
    emit(state.copyWith(
      textSymptoms: event.text,
      status: DiagnosisStatus.initial,
      error: null,
      specialties: const [],
    ));
  }

  void _onToggleSymptom(
    ToggleSymptom event,
    Emitter<DiagnosisState> emit,
  ) {
    final currentSymptoms = List<String>.from(state.selectedSymptoms);
    if (currentSymptoms.contains(event.symptom)) {
      currentSymptoms.remove(event.symptom);
    } else {
      currentSymptoms.add(event.symptom);
    }

    emit(state.copyWith(
      selectedSymptoms: currentSymptoms,
      status: DiagnosisStatus.initial,
      error: null,
      specialties: const [],
    ));
  }
}
