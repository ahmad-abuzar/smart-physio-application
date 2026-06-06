class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change for production
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000/api'; // iOS simulator

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String profile = '/auth/profile';

  // Pain Assessment
  static const String submitAssessment = '/assessment/submit';
  static const String assessmentHistory = '/assessment/history';

  // Exercises
  static const String recommendExercises = '/exercises/recommend';
  static const String allExercises = '/exercises';
  static const String exerciseById = '/exercises/'; // + id
  static const String exercisesByMuscle = '/exercises/by-muscle/'; // + muscle

  // Sessions
  static const String recordSession = '/sessions/record';
  static const String sessionHistory = '/sessions/history';

  // Progress
  static const String progressSummary = '/progress/summary';
  static const String painTrends = '/progress/pain-trends';
  static const String weeklyStats = '/progress/weekly-stats';
}
