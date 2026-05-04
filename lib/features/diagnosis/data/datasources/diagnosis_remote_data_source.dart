import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/diagnosis_model.dart';

abstract class DiagnosisRemoteDataSource {
  Future<DiagnosisModel> analyzeSymptoms({
    required List<String> selectedSymptoms,
    required String textSymptoms,
  });
}

@LazySingleton(as: DiagnosisRemoteDataSource)
class DiagnosisRemoteDataSourceImpl implements DiagnosisRemoteDataSource {
  final ApiClient apiClient;

  DiagnosisRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DiagnosisModel> analyzeSymptoms({
    required List<String> selectedSymptoms,
    required String textSymptoms,
  }) async {
    // Simulate AI Analysis Call
    await Future.delayed(const Duration(seconds: 2));

    // In production, we'd send these to the AI backend and get the response
    // final body = {
    //   'selectedSymptoms': selectedSymptoms,
    //   'textSymptoms': textSymptoms,
    // };
    // final response = await apiClient.dio.post(Endpoints.analyze, data: body);
    // return DiagnosisModel.fromJson(response.data);

    return const DiagnosisModel(
      possibleConditions: ['التهاب الحلق', 'احتقان اللوزتين'],
      advice:
          'ينصح بشرب السوائل الدافئة والراحة. إذا استمرت الأعراض لأكثر من 3 أيام، يجب مراجعة الطبيب.',
      urgencyLevel: 'low',
    );
  }
}
