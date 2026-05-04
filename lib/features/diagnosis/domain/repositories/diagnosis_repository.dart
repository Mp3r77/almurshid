import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diagnosis_entity.dart';

abstract class DiagnosisRepository {
  Future<Either<Failure, DiagnosisEntity>> analyzeSymptoms({
    required List<String> selectedSymptoms,
    required String textSymptoms,
  });
}
