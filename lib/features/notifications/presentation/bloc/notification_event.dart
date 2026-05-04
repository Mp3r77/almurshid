part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class ClearAllNotifications extends NotificationEvent {}

class AddNotification extends NotificationEvent {
  final NotificationModel notification;

  const AddNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}
