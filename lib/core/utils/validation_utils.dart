// ============================================================================
// VALIDATION UTILITIES - Input Validation
// ============================================================================
//
// PURPOSE:
// - Common validation functions
// - Reusable across the app
// - User-friendly error messages
// ============================================================================

/// Validation result with error message
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.valid() => const ValidationResult(isValid: true);

  factory ValidationResult.invalid(String message) =>
      ValidationResult(isValid: false, errorMessage: message);
}

/// Common validators
class Validators {
  Validators._();

  /// Required field validation
  static ValidationResult required(String? value,
      {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('$fieldName is required');
    }
    return ValidationResult.valid();
  }

  /// Minimum length validation
  static ValidationResult minLength(String? value, int minLength,
      {String fieldName = 'This field'}) {
    if (value == null || value.length < minLength) {
      return ValidationResult.invalid(
        '$fieldName must be at least $minLength characters',
      );
    }
    return ValidationResult.valid();
  }

  /// Maximum length validation
  static ValidationResult maxLength(String? value, int maxLength,
      {String fieldName = 'This field'}) {
    if (value != null && value.length > maxLength) {
      return ValidationResult.invalid(
        '$fieldName must not exceed $maxLength characters',
      );
    }
    return ValidationResult.valid();
  }

  /// Email validation
  static ValidationResult email(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Email is required');
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return ValidationResult.invalid('Please enter a valid email');
    }
    return ValidationResult.valid();
  }

  /// Phone validation
  static ValidationResult phone(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Phone number is required');
    }
    // Simple phone validation
    if (!RegExp(r'^[\d\s\-+()]{10,}$').hasMatch(value)) {
      return ValidationResult.invalid('Please enter a valid phone number');
    }
    return ValidationResult.valid();
  }

  /// Password validation
  static ValidationResult password(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Password is required');
    }
    if (value.length < 8) {
      return ValidationResult.invalid('Password must be at least 8 characters');
    }
    return ValidationResult.valid();
  }

  /// Confirm password validation
  static ValidationResult confirmPassword(String? value, String? original) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Please confirm your password');
    }
    if (value != original) {
      return ValidationResult.invalid('Passwords do not match');
    }
    return ValidationResult.valid();
  }

  /// Combine multiple validators
  static ValidationResult combine(List<ValidationResult> results) {
    for (final result in results) {
      if (!result.isValid) return result;
    }
    return ValidationResult.valid();
  }
}
