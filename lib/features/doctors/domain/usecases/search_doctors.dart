// ============================================================================
// SEARCH DOCTORS USECASE - Domain Layer
// ============================================================================

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/doctor_entity.dart';
import '../repositories/doctors_repository.dart';

/// Parameters for search doctors use case
class SearchDoctorsParams extends UseCaseParams {
  final String query;

  const SearchDoctorsParams({required this.query});

  @override
  List<Object?> get props => [query];

  @override
  SearchDoctorsParams copyWith() => this;
}

/// Use case for searching doctors by name or specialty
@lazySingleton
class SearchDoctors
    implements UseCase<List<DoctorEntity>, SearchDoctorsParams> {
  final DoctorsRepository repository;

  SearchDoctors(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(
      SearchDoctorsParams params) async {
    return await repository.searchDoctors(params.query);
  }
}
