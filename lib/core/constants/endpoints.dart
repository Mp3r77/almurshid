// ============================================================================
// API ENDPOINTS - Centralized API Routes
// ============================================================================
//
// PURPOSE:
// - All API endpoints in one place
// - Easy to update and maintain
// - Consistent URL patterns
//
// STRUCTURE:
// Base URL -> Version -> Resource -> Action
// https://api.example.com/v1/doctors
//
// ============================================================================

class Endpoints {
  Endpoints._();

  // Base URL - Change this to your actual API URL
  static const String baseUrl = 'https://api.almurshid.app/v1';
  // static const String baseUrl = 'https://staging-api.almurshid.app/v1'; // Staging
  // static const String baseUrl = 'https://api.example.com/v1'; // Development

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';

  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String userSettings = '/users/settings';

  // Doctor Endpoints
  static const String doctors = '/doctors';
  static const String doctorDetails = '/doctors/{id}';
  static const String doctorAvailability = '/doctors/{id}/availability';
  static const String doctorReviews = '/doctors/{id}/reviews';
  static const String searchDoctors = '/doctors/search';

  // Appointment Endpoints
  static const String appointments = '/appointments';
  static const String appointmentDetails = '/appointments/{id}';
  static const String upcomingAppointments = '/appointments/upcoming';
  static const String previousAppointments = '/appointments/history';
  static const String bookAppointment = '/appointments/book';
  static const String cancelAppointment = '/appointments/{id}/cancel';

  // Lab Endpoints
  static const String labs = '/labs';
  static const String labDetails = '/labs/{id}';
  static const String labServices = '/labs/{id}/services';

  // Diagnosis Endpoints
  static const String analyzeSymptoms = '/diagnosis/analyze';
  static const String diagnosisHistory = '/diagnosis/history';

  // Upload Endpoints
  static const String uploadFile = '/uploads';
  static const String uploadImage = '/uploads/images';

  // Helper methods for dynamic endpoints
  static String getDoctorDetails(String id) => '/doctors/$id';
  static String getDoctorAvailability(String id) => '/doctors/$id/availability';
  static String getDoctorReviews(String id) => '/doctors/$id/reviews';
  static String getAppointmentDetails(String id) => '/appointments/$id';
  static String getCancelAppointment(String id) => '/appointments/$id/cancel';
  static String getLabDetails(String id) => '/labs/$id';
  static String getLabServices(String id) => '/labs/$id/services';
}
