part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final List<NotificationModel> today;
  final List<NotificationModel> yesterday;
  final List<NotificationModel> older;
  final NotificationStatus status;

  const NotificationState({
    this.today = const [],
    this.yesterday = const [],
    this.older = const [],
    this.status = NotificationStatus.initial,
  });

  NotificationState copyWith({
    List<NotificationModel>? today,
    List<NotificationModel>? yesterday,
    List<NotificationModel>? older,
    NotificationStatus? status,
  }) {
    return NotificationState(
      today: today ?? this.today,
      yesterday: yesterday ?? this.yesterday,
      older: older ?? this.older,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [today, yesterday, older, status];
}
