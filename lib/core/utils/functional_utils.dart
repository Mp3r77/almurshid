import 'package:flutter/foundation.dart';

class AppLogger {
  static bool _isEnabled = kDebugMode;

  static void enable() => _isEnabled = true;
  static void disable() => _isEnabled = false;

  static void debug(String message, {String? tag}) {
    _log(message, tag: tag);
  }

  static void info(String message, {String? tag}) {
    _log('INFO $message', tag: tag);
  }

  static void warning(String message, {String? tag}) {
    _log('WARNING $message', tag: tag);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log('ERROR $message', tag: tag);
    if (error != null) _log('Error: $error');
    if (stackTrace != null) _log('StackTrace: $stackTrace');
  }

  static void _log(String message, {String? tag}) {
    if (!_isEnabled) return;
    debugPrint('${tag != null ? '[$tag] ' : ''}$message');
  }
}

class DateTimeUtils {
  DateTimeUtils._();

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static String getRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    }
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    }
    return 'Just now';
  }
}

class StringUtils {
  StringUtils._();

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }
}

class NumberUtils {
  NumberUtils._();

  static String formatCurrency(int amount, {String symbol = 'YER'}) {
    final formatted = amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
    return '$formatted $symbol';
  }

  static String formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }
}
