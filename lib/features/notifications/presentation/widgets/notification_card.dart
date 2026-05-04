import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final typeColor = _getColorForType(notification.type, colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showNotificationDetails(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _getIconForType(notification.type),
                          color: typeColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: GoogleFonts.cairo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  notification.timeText,
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification.subtitle,
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Side colored strip
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final typeColor = _getColorForType(notification.type, colorScheme);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getIconForType(notification.type),
                        color: typeColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  notification.subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'وقت الإشعار: ${notification.timeText}',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'حسناً',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForType(NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case NotificationType.appointment:
        return const Color(0xFF0C61C8); // Blue
      case NotificationType.labResult:
        return Colors.green; // Green
      case NotificationType.message:
        return Colors.orange; // Orange
      case NotificationType.medication:
        return Colors.purple; // Purple
      case NotificationType.security:
        return Colors.blueGrey; // Greyish
      case NotificationType.announcement:
        return colorScheme.primary;
    }
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return Icons.calendar_month_outlined;
      case NotificationType.labResult:
        return Icons.science_outlined;
      case NotificationType.message:
        return Icons.chat_bubble_outline;
      case NotificationType.medication:
        return Icons.assignment_outlined;
      case NotificationType.security:
        return Icons.security_outlined;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
    }
  }
}
