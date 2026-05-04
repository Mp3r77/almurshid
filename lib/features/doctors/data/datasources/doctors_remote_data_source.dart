import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/doctor_model.dart';

abstract class DoctorsRemoteDataSource {
  Future<List<DoctorModel>> getDoctors();
  Future<List<DoctorModel>> searchDoctors(String query);
  Future<DoctorModel> getDoctorById(String id);
  Future<List<Map<String, dynamic>>> getDoctorAvailability(
    String id,
    DateTime date,
  );
}

@LazySingleton(as: DoctorsRemoteDataSource)
class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  final ApiClient apiClient;

  DoctorsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<DoctorModel>> getDoctors() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return _mockDoctors;
    } catch (e) {
      throw ServerException(
        message: 'Failed to load doctors: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<DoctorModel>> searchDoctors(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (query.isEmpty) {
        return _mockDoctors;
      }

      final lowerQuery = query.toLowerCase();
      return _mockDoctors
          .where(
            (doctor) =>
                doctor.name.toLowerCase().contains(lowerQuery) ||
                doctor.specialty.toLowerCase().contains(lowerQuery) ||
                doctor.location.toLowerCase().contains(lowerQuery),
          )
          .toList();
    } catch (e) {
      throw ServerException(
        message: 'Failed to search doctors: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      return _mockDoctors.firstWhere(
        (doctor) => doctor.id == id,
        orElse: () => throw const ServerException(message: 'Doctor not found'),
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }

      throw ServerException(
        message: 'Failed to get doctor: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorAvailability(
    String id,
    DateTime date,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _generateMockSlots(date);
    } catch (e) {
      throw ServerException(
        message: 'Failed to get availability: ${e.toString()}',
        originalError: e,
      );
    }
  }

  List<Map<String, dynamic>> _generateMockSlots(DateTime date) {
    final slots = <Map<String, dynamic>>[];
    final baseDate = DateTime(date.year, date.month, date.day);

    for (var hour = 9; hour < 17; hour++) {
      final slotTime = baseDate.add(Duration(hours: hour));
      slots.add({
        'time': slotTime.toIso8601String(),
        'available': hour % 3 != 0,
      });
    }

    return slots;
  }

  static final List<DoctorModel> _mockDoctors = [
    const DoctorModel(
      id: '1',
      name: 'د. سامر الراشدي',
      specialty: 'قلبية',
      location: 'تعز',
      bio:
          'استشاري قلبية يركز على تشخيص أمراض القلب ومتابعة ضغط الدم والذبحة الصدرية.',
      rating: 4.5,
      reviews: 120,
      imageUrl: 'https://i.pravatar.cc/150?img=12',
      price: 5000,
    ),
    const DoctorModel(
      id: '2',
      name: 'د. لمياء الأهدل',
      specialty: 'أطفال',
      location: 'عدن',
      bio:
          'أخصائية أطفال بخبرة في متابعة النمو والتطعيمات وعلاج مشاكل الجهاز التنفسي لدى الأطفال.',
      rating: 4.6,
      reviews: 150,
      imageUrl: 'https://i.pravatar.cc/150?img=32',
      price: 3500,
    ),
    const DoctorModel(
      id: '3',
      name: 'د. عادل الشيباني',
      specialty: 'جراحة عامة',
      location: 'صنعاء',
      bio:
          'استشاري جراحة عامة للحالات البسيطة والمتوسطة مع متابعة ما بعد العمليات.',
      rating: 4.7,
      reviews: 180,
      imageUrl: 'https://i.pravatar.cc/150?img=13',
      price: 8000,
    ),
    const DoctorModel(
      id: '4',
      name: 'د. رشا الحبيشي',
      specialty: 'طب صدري',
      location: 'إب',
      bio:
          'متخصصة في أمراض الجهاز التنفسي والربو والحساسية ومتابعة الأمراض المزمنة.',
      rating: 4.9,
      reviews: 200,
      imageUrl: 'https://i.pravatar.cc/150?img=33',
      price: 6500,
    ),
    const DoctorModel(
      id: '5',
      name: 'د. محمد القليوبي',
      specialty: 'أمراض باطنية',
      location: 'الحديدة',
      bio:
          'استشاري باطنية يتابع السكري والضغط واضطرابات المعدة والفحوصات الدورية.',
      rating: 4.4,
      reviews: 95,
      imageUrl: 'https://i.pravatar.cc/150?img=14',
      price: 4500,
    ),
    const DoctorModel(
      id: '6',
      name: 'د. فاطمة الزهراء',
      specialty: 'نساء وولادة',
      location: 'تعز',
      bio:
          'أخصائية نساء وولادة لمتابعة الحمل والفحوصات الدورية والعلاج التحفظي.',
      rating: 4.8,
      reviews: 210,
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      price: 6000,
    ),
    const DoctorModel(
      id: '7',
      name: 'د. عائشة الجفري',
      specialty: 'جلدية',
      location: 'عدن',
      bio:
          'أخصائية جلدية تقدم استشارات للحساسية وحب الشباب والعناية العلاجية بالبشرة.',
      rating: 4.7,
      reviews: 132,
      imageUrl: 'https://i.pravatar.cc/150?img=21',
      price: 4200,
    ),
    const DoctorModel(
      id: '8',
      name: 'د. علي الهاشمي',
      specialty: 'أطفال',
      location: 'صنعاء',
      bio:
          'طبيب أطفال يركز على الاستشارات السريعة وحالات الحمى والتغذية ومتابعة النمو.',
      rating: 4.6,
      reviews: 175,
      imageUrl: 'https://i.pravatar.cc/150?img=18',
      price: 3800,
    ),
    const DoctorModel(
      id: '9',
      name: 'د. سارة الغريب',
      specialty: 'أمراض قلبية',
      location: 'المكلا',
      bio:
          'استشارية قلبية متخصصة في التخطيط القلبي ومتابعة حالات الخفقان والدهون.',
      rating: 4.9,
      reviews: 220,
      imageUrl: 'https://i.pravatar.cc/150?img=24',
      price: 7000,
    ),
  ];
}
