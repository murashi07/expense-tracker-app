class AppConstants {
  static const String appName = 'Expense Tracker';
  static const String currencySymbol = '\$'; // You can change this

  // Database related constants:
  static const String defaultCategoryIcon = 'category'; // Default icon if a category doesn't have one.
  static const int maxExpenseDescriptionLength = 200;
  static const int maxBudgetNameLength = 50;

  // Notification IDs (ensure these are unique)
  static const int budgetNotificationId = 100;
  static const int savingsGoalNotificationId = 200;

  // Settings Screen URLs (fallback if url_launcher fails)
  static const String feedbackEmail = 'feedback@example.com';
  static const String helpPageUrl = 'https://www.example.com/expense-tracker-help';
  static const String githubRepoUrl = 'https://github.com/YourUsername/expense_tracker';

  // Default budget duration in days.
  static const int defaultBudgetDuration = 30;

  // Date format string
  static const String displayDateFormat = 'dd MMM yyyy';  // e.g., 01 Jan 2024
  static const String databaseDateFormat = 'yyyy-MM-dd'; // e.g., 2024-01-01  (ISO format is good too).

  //Key for shared preferences
  static const String seenOnboardingKey = 'seenOnboarding';

  //Error Messages
  static const String genericErrorMessage = "An unexpected error occurred. Please try again.";
  static const String databaseErrorMessage = "Error accessing local data.";
  static const String notificationErrorMessage = "Failed to schedule notification.";

  //Animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

// Add any other constants you need here.
}