import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

@lazySingleton
class GetPreviousAppointments
    implements UseCase<List<AppointmentEntity>, NoParams> {
  final AppointmentRepository repository;

  GetPreviousAppointments(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(NoParams params) async {
    return await repository.getPreviousAppointments();
  }
}
