import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getUpcomingAppointments();
  Future<Either<Failure, List<AppointmentEntity>>> getPreviousAppointments();
  Future<Either<Failure, Unit>> processBooking(
      String doctorId, DateTime dateTime);
}
