import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/diagnosis_entity.dart';
import '../../domain/repositories/diagnosis_repository.dart';
import '../datasources/diagnosis_remote_data_source.dart';

@LazySingleton(as: DiagnosisRepository)
class DiagnosisRepositoryImpl implements DiagnosisRepository {
  final DiagnosisRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DiagnosisRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DiagnosisEntity>> analyzeSymptoms({
    required List<String> selectedSymptoms,
    required String textSymptoms,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeSymptoms(
          selectedSymptoms: selectedSymptoms,
          textSymptoms: textSymptoms,
        );
        return Right(result);
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
