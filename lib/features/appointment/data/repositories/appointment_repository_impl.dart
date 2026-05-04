import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_data_source.dart';

@LazySingleton(as: AppointmentRepository)
class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AppointmentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AppointmentEntity>>>
      getUpcomingAppointments() async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getUpcomingAppointments();
        return Right(results);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppointmentEntity>>>
      getPreviousAppointments() async {
    if (await networkInfo.isConnected) {
      try {
        final results = await remoteDataSource.getPreviousAppointments();
        return Right(results);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> processBooking(
      String doctorId, DateTime dateTime) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.processBooking(doctorId, dateTime);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
