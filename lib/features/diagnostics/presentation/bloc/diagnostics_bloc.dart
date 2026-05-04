import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/diagnostic_entities.dart';
import 'diagnostics_event.dart';
import 'diagnostics_state.dart';

class DiagnosticsBloc extends Bloc<DiagnosticsEvent, DiagnosticsState> {
  DiagnosticsBloc() : super(const DiagnosticsState()) {
    on<LoadDiagnosticsCenters>(_onLoadCenters);
    on<SelectDiagnosticCenter>(_onSelectCenter);
    on<AddDiagnosticServiceToBooking>(_onAddService);
    on<RemoveDiagnosticServiceFromBooking>(_onRemoveService);
    on<SubmitBookingRequest>(_onSubmitBooking);
    on<LoadBookingDetails>(_onLoadBookingDetails);
  }

  void _onLoadCenters(
      LoadDiagnosticsCenters event, Emitter<DiagnosticsState> emit) async {
    emit(state.copyWith(status: DiagnosticsStatus.loading));

    // Mock data
    await Future.delayed(const Duration(seconds: 1));

    final mockCenters = [
      const DiagnosticCenter(
        id: '1',
        name: 'مركز الشفاء المتكامل للأشعة',
        description:
            'يعتبر مركز الكشافات للأشعة من المراكز الرائدة في تقديم الخدمات الشخصية المتطورة. نستخدم أحدث التقنيات العالمية لضمان دقة النتائج وسرعة التشخيص تحت إشراف نخبة من الأطباء الاستشاريين.',
        image:
            'https://images.unsplash.com/photo-1579154204601-01588f351e67?w=600&q=80',
        logoUrl:
            'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=200&q=80',
        rating: '4.8',
        reviewsCount: 124,
        distance: '2.4 كم',
        location: 'اليمن، صنعاء',
        type: DiagnosticType.radiology,
        isOpen: true,
        workingHours: 'مفتوح الآن - يغلق 10:00 م',
        services: [
          DiagnosticService(
              id: 's1', name: 'فحص الرنين المغناطيسي (MRI)', price: 450.0),
          DiagnosticService(id: 's2', name: 'تصوير طبقي CT', price: 67.5),
          DiagnosticService(id: 's3', name: 'أشعة سينية X-Ray', price: 50.5),
        ],
      ),
      const DiagnosticCenter(
        id: '2',
        name: 'مختبر البرج الطبي',
        description: 'مختبر متخصص في كافة الفحوصات الطبية بأحدث الأجهزة.',
        image:
            'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=600&q=80',
        logoUrl:
            'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=400&q=80',
        rating: '4.5',
        reviewsCount: 89,
        distance: '1.2 كم',
        location: 'اليمن، عدن',
        type: DiagnosticType.lab,
        isOpen: true,
        workingHours: 'مفتوح الآن - يغلق 09:00 م',
        services: [
          DiagnosticService(id: 's4', name: 'فحص دم شامل', price: 25.0),
          DiagnosticService(id: 's5', name: 'فحص السكر', price: 10.0),
        ],
      ),
    ];

    final filtered = event.type == null
        ? mockCenters
        : mockCenters.where((c) => c.type == event.type).toList();

    emit(state.copyWith(
      status: DiagnosticsStatus.success,
      centers: mockCenters,
      filteredCenters: filtered,
    ));
  }

  void _onSelectCenter(
      SelectDiagnosticCenter event, Emitter<DiagnosticsState> emit) {
    emit(state.copyWith(selectedCenter: event.center, selectedServices: []));
  }

  void _onAddService(
      AddDiagnosticServiceToBooking event, Emitter<DiagnosticsState> emit) {
    final updatedServices = List<DiagnosticService>.from(state.selectedServices)
      ..add(event.service);
    emit(state.copyWith(selectedServices: updatedServices));
  }

  void _onRemoveService(RemoveDiagnosticServiceFromBooking event,
      Emitter<DiagnosticsState> emit) {
    final updatedServices = List<DiagnosticService>.from(state.selectedServices)
      ..remove(event.service);
    emit(state.copyWith(selectedServices: updatedServices));
  }

  void _onSubmitBooking(
      SubmitBookingRequest event, Emitter<DiagnosticsState> emit) async {
    emit(state.copyWith(status: DiagnosticsStatus.bookingSubmitting));

    await Future.delayed(const Duration(seconds: 2));

    if (state.selectedCenter == null) {
      emit(state.copyWith(
          status: DiagnosticsStatus.failure,
          errorMessage: 'لم يتم اختيار مركز'));
      return;
    }

    final booking = DiagnosticBooking(
      id: 'PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      center: state.selectedCenter!,
      selectedServices: state.selectedServices,
      patientName: event.patientName,
      patientPhone: event.patientPhone,
      patientAge: event.patientAge,
      patientGender: event.patientGender,
      prescriptionPath: event.prescriptionPath,
      appointmentDate: event.appointmentDate,
      appointmentTime: event.appointmentTime,
      status: BookingStatus.sent,
      totalAmount: state.selectedServices.fold(0, (sum, s) => sum + s.price),
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(
      status: DiagnosticsStatus.bookingSuccess,
      currentBooking: booking,
    ));
  }

  void _onLoadBookingDetails(
      LoadBookingDetails event, Emitter<DiagnosticsState> emit) async {
    // In a real app, fetch by ID. Here we just use the current booking if it matches or mock one.
    if (state.currentBooking?.id == event.bookingId) {
      emit(state.copyWith(status: DiagnosticsStatus.success));
    }
  }
}
