import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/diagnosis_entity.dart';
import '../repositories/diagnosis_repository.dart';

class AnalyzeSymptomsParams extends Equatable {
  final List<String> selectedSymptoms;
  final String textSymptoms;

  const AnalyzeSymptomsParams({
    required this.selectedSymptoms,
    required this.textSymptoms,
  });

  @override
  List<Object?> get props => [selectedSymptoms, textSymptoms];
}

@lazySingleton
class AnalyzeSymptomsUseCase
    implements UseCase<DiagnosisEntity, AnalyzeSymptomsParams> {
  final DiagnosisRepository repository;

  AnalyzeSymptomsUseCase(this.repository);

  @override
  Future<Either<Failure, DiagnosisEntity>> call(
      AnalyzeSymptomsParams params) async {
    return await repository.analyzeSymptoms(
      selectedSymptoms: params.selectedSymptoms,
      textSymptoms: params.textSymptoms,
    );
  }
}
