# Expense-Tracker: Smart Expense & Budget Tracker for Students

## 📌 Description

Expense-Tracker is a personal finance management mobile application designed to help students efficiently track their daily expenses, manage their budgets, and achieve their savings goals. This app offers a user-friendly interface with offline storage capabilities, ensuring that students can manage their finances anytime, anywhere.

## 🛠️ Core Features

*   **Expense Logging & Categorization:** Manually enter and categorize expenses for clear tracking.
*   **Budget Setting & Alerts:** Define a monthly budget and receive notifications when overspending.
*   **Savings Goals & Reminders:** Track progress on savings goals and set reminders for consistent saving.
*   **Simple Reports & Graphs:** Visualize spending habits with easy-to-understand reports and graphs.
*   **Offline Storage:** All transactions are stored locally for offline access and data privacy.
*   **User-Friendly Interface:** Designed with simplicity in mind for ease of use.
*   **Onboarding Experience:** Introduction screens guide new users on how to effectively use the app.
*   **Settings Screen:** Options for feedback, help, and displaying app/device information.

## ✨ Additional Useful Features

*   **Edit and Delete Transactions:** Easily modify or remove expenses and budgets as needed.
*   **Transaction Summary:** View overall expenses, income, and balance at a glance.
*   **Animated UI Elements:** Engaging Lottie animations add visual appeal.
*   **Customizable Categories:** (Future Enhancement) Allow users to create their own expense categories.
*   **Recurring Transactions:** (Future Enhancement) Automate the entry of regular expenses (e.g., rent, subscriptions).
*   **Cloud Sync:** (Future Enhancement) Option to sync data across devices (with user authentication).

## 💻 Technologies Used

*   **Flutter:** The primary framework for building the cross-platform mobile application.
*   **Dart:** The programming language used within the Flutter framework.
*   **SQLite (sqflite package):** For local, persistent storage of expense data, budget information, and savings goals.
*   **intl Package:** For formatting dates and currencies according to user preferences.
*   **fl\_chart Package:** To generate visual representations of spending habits through charts and graphs.
*   **shared\_preferences Package:** Used to store user preferences, such as whether the onboarding screen has been viewed.
*   **flutter\_local\_notifications Package:** For scheduling and displaying local notifications, such as budget alerts and savings reminders.
*   **timezone Package:** For configuring timezone.
*   **animations Package:** For implementing smooth page route transitions and other UI animations.
*   **introduction\_screen Package:** To create interactive onboarding screens for new users.
*   **url\_launcher Package:** Allows the app to launch URLs for feedback, help, and other external links.
*   **flutter\_native\_splash Package:** Used to create a customizable native splash screen for a better user experience.
*   **lottie Package:** To include engaging and visually appealing animations.
*   **package\_info\_plus Package:** To retrieve information about the app, such as its name, version, and build number.
*   **device\_info\_plus Package:** To retrieve the device ID to be used for support cases.

## ⚙️ How It Works

1.  **Data Storage:** The app uses a local SQLite database managed through the `sqflite` package to persistently store all user data, including expenses, budgets, and savings goals.

2.  **Expense Tracking:** Users can manually input their expenses, categorizing them and specifying the amount, date, and an optional description. These entries are stored in the SQLite database.

3.  **Budget Management:** Users can set monthly budgets for different categories. The app tracks spending within each category and can trigger local notifications (using `flutter_local_notifications`) when a user is approaching or exceeding their budget.

4.  **Savings Goals:** Users can define savings goals with a target amount and a deadline. The app allows users to track their progress toward these goals, providing motivation and reminders.

5.  **Reporting:** The `fl_chart` package is used to generate charts and graphs that visually represent the user's spending habits, budget status, and progress toward savings goals.

6.  **User Interface:** The user interface is built using Flutter widgets, providing a smooth and responsive experience. Animations and transitions (using the `animations` package) enhance the overall user experience.

7.  **Offline Functionality:** Because all data is stored locally in the SQLite database, the app functions fully even when the device is offline.

## 🚀 How to Run the Project

Follow these steps to run the Expense-Tracker application:

### Prerequisites

*   **Flutter SDK:** Make sure you have the Flutter SDK installed and configured correctly. Download it from [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
*   **Android Studio or VS Code:** Use an IDE (Integrated Development Environment) like Android Studio ([https://developer.android.com/studio](https://developer.android.com/studio)) or VS Code ([https://code.visualstudio.com/](https://code.visualstudio.com/)).
*   **Connected Device or Emulator:** Connect an Android/iOS device with debugging enabled or start an emulator.

### Steps

1.  **Clone the Repository:**
    ```bash
    git clone [repository URL]
    cd expense_tracker
    ```

2.  **Get Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure the Project:**
    *   Ensure that the `assets` directory is correctly structured according to the `pubspec.yaml` file and that all assets are in place.

4.  **Run the App:**
    ```bash
    flutter run
    ```

    Select the device or emulator you want to run the app on when prompted.

### Sample Pictures

![IMG-20250227-WA0006](https://github.com/user-attachments/assets/f1b2e83c-b4eb-4bf2-b572-a45d22350489)
![IMG-20250227-WA0015](https://github.com/user-attachments/assets/8ab09f44-45d3-4459-b23b-e376d1679933)
![IMG-20250227-WA0014](https://github.com/user-attachments/assets/2cc4b42d-5cef-4020-b4ab-b4636ebe661c)
![IMG-20250227-WA0013](https://github.com/user-attachments/assets/6c52314c-ebf5-476e-87fb-dacf191e370e)
![IMG-20250227-WA0012](https://github.com/user-attachments/assets/d21acf02-e105-4b01-b127-14ab223501eb)
![IMG-20250227-WA0011](https://github.com/user-attachments/assets/0294d8d3-9d42-4b4b-a23d-2332e3a5d7c9)
![IMG-20250227-WA0010](https://github.com/user-attachments/assets/97da7944-6095-4734-b6c0-dfde7172d333)
![IMG-20250227-WA0009](https://github.com/user-attachments/assets/56249cf9-ebdc-4f68-b48e-209eecb69cbb)
![IMG-20250227-WA0007](https://github.com/user-attachments/assets/3ee8f2b0-0356-41bf-9b0f-43f1b0c00e59)
![IMG-20250227-WA0006](https://github.com/user-attachments/assets/9d16c432-964d-4a4d-9935-c5827f821b5e)
![IMG-20250227-WA0005](https://github.com/user-attachments/assets/2bcbf652-0adc-4852-af01-cbdd2fdb9d12)
![IMG-20250227-WA0004](https://github.com/user-attachments/assets/e6663610-ac35-48ca-85a3-f6a10dc4e1bf)
![IMG-20250227-WA0003](https://github.com/user-attachments/assets/a2bc8bcc-7846-47e3-acdc-35e8dda07084)
![IMG-20250227-WA0002](https://github.com/user-attachments/assets/551a92bb-20a4-4e0f-be38-c12cc90c8e8f)
![IMG-20250227-WA0001](https://github.com/user-attachments/assets/667c6d19-308e-4ed1-8115-64ed28697a8e)

### Class Diagram
![classD drawio](https://github.com/user-attachments/assets/08d5e374-7ba3-4b0a-84d9-c803f2b9dfdd)

### Sequence Diagram
![Sequence drawio](https://github.com/user-attachments/assets/b4b91737-dfc2-4158-979c-e9621e551dad)

### Activity Diagram
![ACTIVITY drawio](https://github.com/user-attachments/assets/57cfb094-97df-407c-8dba-a38279dcea32)






