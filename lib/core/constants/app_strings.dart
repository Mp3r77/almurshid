// ============================================================================
// APP STRINGS - Centralized String Constants
// ============================================================================
//
// PURPOSE:
// - All user-facing strings in one place
// - Easy to maintain and update
// - Can be localized later
//
// USAGE:
// import 'package:app/core/constants/app_strings.dart';
// Text(AppStrings.welcome)
//
// FUTURE:
// - Replace with ARB files for localization
// ============================================================================

class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Al Murshid';
  static const String appDescription = 'Your Healthcare Companion';

  // General
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String search = 'Search';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String submit = 'Submit';
  static const String close = 'Close';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorTimeout = 'Request timed out. Please try again.';

  // Empty States
  static const String emptyNoData = 'No data available';
  static const String emptyNoResults = 'No results found';
  static const String emptyNoDoctors = 'No doctors found';
  static const String emptyNoAppointments = 'No appointments found';
  static const String emptyNoLabs = 'No labs found';

  // Doctors
  static const String doctorsTitle = 'Find a Doctor';
  static const String doctorsSearchHint = 'Search doctors by name or specialty';
  static const String doctorReviews = 'reviews';
  static const String doctorPrice = 'Price';

  // Appointments
  static const String appointmentsTitle = 'My Appointments';
  static const String upcomingAppointments = 'Upcoming';
  static const String previousAppointments = 'Previous';
  static const String bookAppointment = 'Book Appointment';
  static const String appointmentConfirmed = 'Appointment Confirmed';
  static const String appointmentPending = 'Pending Confirmation';

  // Labs
  static const String labsTitle = 'Medical Labs';
  static const String labServices = 'Services';
  static const String labDistance = 'Away';

  // Diagnosis
  static const String diagnosisTitle = 'Symptom Analysis';
  static const String diagnosisHint = 'Describe your symptoms...';
  static const String analyzeSymptoms = 'Analyze Symptoms';
  static const String diagnosisResult = 'Possible Conditions';

  // Navigation
  static const String navHome = 'Home';
  static const String navDoctors = 'Doctors';
  static const String navAppointments = 'Appointments';
  static const String navLabs = 'Labs';
  static const String navProfile = 'Profile';
}
