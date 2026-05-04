// ============================================================================
// DOCTORS REPOSITORY IMPLEMENTATION - Data Layer
// ============================================================================
//
// PURPOSE:
// - Implements DoctorsRepository contract
// - Handles data operations (remote API calls)
// - Transforms exceptions to failures
//
// ARCHITECTURE:
// DataSource (API) → Repository (transforms) → UseCase → BLoC
//
// ERROR HANDLING:
// 1. DataSource throws specific exceptions
// 2. Repository catches and converts to Failures
// 3. UseCase returns Either<Failure, Success>
// ============================================================================

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';
import '../datasources/doctors_remote_data_source.dart';

/// Implementation of DoctorsRepository
///
/// Handles:
/// - Network connectivity check
/// - Remote data fetching
/// - Error transformation
@LazySingleton(as: DoctorsRepository)
class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DoctorsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors() async {
    try {
      // Check network connectivity
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // Fetch from remote
      final doctors = await remoteDataSource.getDoctors();

      // Convert models to entities and return
      return Right(doctors.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorEntity>>> searchDoctors(
      String query) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final doctors = await remoteDataSource.searchDoctors(query);
      return Right(doctors.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final doctor = await remoteDataSource.getDoctorById(doctorId);
      return Right(doctor.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getDoctorAvailability(
    String doctorId,
    DateTime date,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final availability =
          await remoteDataSource.getDoctorAvailability(doctorId, date);
      return Right(availability);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
