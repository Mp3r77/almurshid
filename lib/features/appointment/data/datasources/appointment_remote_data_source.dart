import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../../../../features/doctors/data/models/doctor_model.dart';
import '../models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> getUpcomingAppointments();
  Future<List<AppointmentModel>> getPreviousAppointments();
  Future<void> processBooking(String doctorId, DateTime dateTime);
}

@LazySingleton(as: AppointmentRemoteDataSource)
class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final ApiClient apiClient;

  AppointmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      AppointmentModel(
        id: '1',
        doctor: const DoctorModel(
          id: '1',
          name: 'د. بسامة محمود',
          specialty: 'أخصائي جراحة وزراعة الأسنان',
          location: 'عيادات مجمع الصفوة الطبي',
          bio: 'متخصصة في التركيبات وزراعة الأسنان والحالات التجميلية.',
          rating: 4.5,
          reviews: 120,
          imageUrl: 'https://i.pravatar.cc/150?img=47',
          price: 5000,
        ),
        dateTime: DateTime.now().add(const Duration(days: 2, hours: 16)),
        status: 'في الانتظار',
        type: 'موعد طبيب',
        patientName: 'أحمد محمد علي',
        patientPhone: '770001122',
        patientGender: 'ذكر',
        patientAge: '28',
        bookingPeriod: 'مساء',
      ),
      AppointmentModel(
        id: '2',
        doctor: const DoctorModel(
          id: '5',
          name: 'عيادة القلب والأوعية',
          specialty: 'د. ناهد كمال',
          location: 'مجمع الأمل الطبي',
          bio: 'استشارات قلبية ومتابعة الضغط واضطرابات النبض.',
          rating: 4.8,
          reviews: 90,
          imageUrl:
              'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=400&q=80',
          price: 4000,
        ),
        dateTime: DateTime.now().add(const Duration(days: 4, hours: 10)),
        status: 'مؤكد',
        type: 'موعد كشفية',
        patientName: 'سارة علي حسن',
        patientPhone: '777003344',
        patientGender: 'أنثى',
        patientAge: '24',
        bookingPeriod: 'صباحا',
      ),
    ];
  }

  @override
  Future<List<AppointmentModel>> getPreviousAppointments() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      AppointmentModel(
        id: '3',
        doctor: const DoctorModel(
          id: '6',
          name: 'مختبر التشخيص الحديث',
          specialty: 'أشعة سينية الصدر',
          location: 'تعز',
          bio: 'خدمة تشخيصية سريعة مع تقارير رقمية ومتابعة للحالة.',
          rating: 4.7,
          reviews: 210,
          imageUrl:
              'https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=400&q=80',
          price: 3500,
        ),
        dateTime: DateTime.now().subtract(const Duration(days: 8, hours: 12)),
        status: 'مرفوض',
        type: 'موعد مختبر',
        patientName: 'علي عبدالله',
        patientPhone: '775667788',
        patientGender: 'ذكر',
        patientAge: '31',
        bookingPeriod: 'مساء',
        cancelReason: 'وجدت موعدا أقرب',
        cancelNote: 'تم اختيار مركز آخر قريب من المنزل',
      ),
      AppointmentModel(
        id: '4',
        doctor: const DoctorModel(
          id: '7',
          name: 'د. خالد الهاشمي',
          specialty: 'استشاري عيون',
          location: 'صنعاء',
          bio: 'يقدم فحوصات النظر وعلاج الالتهابات ومتابعة ما بعد الإجراءات.',
          rating: 4.7,
          reviews: 210,
          imageUrl: 'https://i.pravatar.cc/150?img=34',
          price: 6000,
        ),
        dateTime: DateTime.now().subtract(const Duration(days: 30)),
        status: 'مكتمل',
        type: 'متابعة الطلب',
        patientName: 'منى عبدالكريم',
        patientPhone: '771334455',
        patientGender: 'أنثى',
        patientAge: '33',
        bookingPeriod: 'صباحا',
      ),
    ];
  }

  @override
  Future<void> processBooking(String doctorId, DateTime dateTime) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
