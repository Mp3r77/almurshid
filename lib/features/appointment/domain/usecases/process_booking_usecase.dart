import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repository.dart';

class ProcessBookingParams extends Equatable {
  final String doctorId;
  final DateTime dateTime;

  const ProcessBookingParams({required this.doctorId, required this.dateTime});

  @override
  List<Object?> get props => [doctorId, dateTime];
}

@lazySingleton
class ProcessBookingUseCase implements UseCase<Unit, ProcessBookingParams> {
  final AppointmentRepository repository;

  ProcessBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ProcessBookingParams params) async {
    return await repository.processBooking(params.doctorId, params.dateTime);
  }
}
