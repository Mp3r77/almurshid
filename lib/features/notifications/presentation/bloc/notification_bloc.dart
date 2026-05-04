import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<AddNotification>(_onAddNotification);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(status: NotificationStatus.loading));

    if (state.today.isNotEmpty ||
        state.yesterday.isNotEmpty ||
        state.older.isNotEmpty) {
      emit(state.copyWith(status: NotificationStatus.success));
      return;
    }

    final today = [
      NotificationModel(
        id: '1',
        title: 'تأكيد موعد الحجز',
        subtitle:
            'تم تأكيد موعدك مع د. سارة العتيبي في عيادة القلب يوم الثلاثاء القادم الساعة 10:30 صباحاً.',
        type: NotificationType.appointment,
        timeText: 'منذ دقيقتين',
        timestamp: DateTime.now(),
      ),
      NotificationModel(
        id: '2',
        title: 'نتائج المختبر جاهزة',
        subtitle:
            'نتائج تحليل الدم الشامل أصبحت متاحة الآن في ملفك الطبي، يمكنك عرضها وتحميلها بصيغة PDF.',
        type: NotificationType.labResult,
        timeText: 'منذ ساعة',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '3',
        title: 'رسالة جديدة من الطبيب',
        subtitle:
            'د. أحمد خالد: "بناءً على الأشعة، يفضل الالتزام بالراحة التامة لمدة أسبوع.."',
        type: NotificationType.message,
        timeText: 'منذ 3 ساعات',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    final yesterday = [
      NotificationModel(
        id: '4',
        title: 'تحديث الوصفة الطبية',
        subtitle:
            'تمت إضافة أدوية جديدة لوصفتك الرقمية، يمكنك صرفها من أي صيدلية متعاقدة.',
        type: NotificationType.medication,
        timeText: 'أمس، 4:00 م',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: '5',
        title: 'تسجيل دخول جديد',
        subtitle:
            'تم تسجيل الدخول إلى حسابك من جهاز iPhone 15 Pro في مدينة الرياض.',
        type: NotificationType.security,
        timeText: 'أمس، 10:15 ص',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      ),
    ];

    emit(state.copyWith(
      status: NotificationStatus.success,
      today: today,
      yesterday: yesterday,
      older: const [],
    ));
  }

  void _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationState> emit,
  ) {
    emit(const NotificationState(status: NotificationStatus.success));
  }

  void _onAddNotification(
    AddNotification event,
    Emitter<NotificationState> emit,
  ) {
    final notification = event.notification;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    var today = List<NotificationModel>.from(state.today);
    var yesterday = List<NotificationModel>.from(state.yesterday);
    var older = List<NotificationModel>.from(state.older);

    if (notification.timestamp.isAfter(startOfToday)) {
      today = [notification, ...today];
    } else if (notification.timestamp.isAfter(startOfYesterday)) {
      yesterday = [notification, ...yesterday];
    } else {
      older = [notification, ...older];
    }

    emit(state.copyWith(
      status: NotificationStatus.success,
      today: today,
      yesterday: yesterday,
      older: older,
    ));
  }
}
