import 'package:equatable/equatable.dart';

enum NotificationType {
  appointment,
  labResult,
  message,
  medication,
  announcement,
  security,
}

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final NotificationType type;
  final String timeText; // e.g., "15 دقيقة", "11:30 صباحاً"
  final DateTime timestamp;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.timeText,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, subtitle, type, timeText, timestamp];
}
