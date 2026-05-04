// ============================================================================
// GET ALL DOCTORS USECASE - Domain Layer
// ============================================================================
//
// PURPOSE:
// - Single responsibility use case for fetching all doctors
// - Pure Dart, no Flutter dependencies
// - Returns Either<Failure, List<DoctorEntity>>
//
// ARCHITECTURE:
// BLoC → UseCase → Repository → DataSource
// ============================================================================

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/doctor_entity.dart';
import '../repositories/doctors_repository.dart';

/// Use case for getting all doctors
///
/// Example usage:
/// ```dart
/// final result = await getAllDoctors(NoParams());
/// result.fold(
///   (failure) => handleError(failure),
///   (doctors) => displayDoctors(doctors),
/// );
/// ```
@lazySingleton
class GetAllDoctors implements UseCase<List<DoctorEntity>, NoParams> {
  final DoctorsRepository repository;

  GetAllDoctors(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(NoParams params) async {
    return await repository.getAllDoctors();
  }
}
