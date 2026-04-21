# Flutter Mobile Application Development - Complete Exercise Collection

## Project Overview

This project is a comprehensive collection of 10 Flutter mobile application exercises designed to demonstrate various aspects of mobile app development, including database management, state management, UI/UX design, and data persistence. Each exercise focuses on specific features and functionalities commonly used in modern mobile applications.

## Author Information

**Name:** Phan Cong Tri  
**Student ID:** 6451071080

## Technology Stack

- **Framework:** Flutter 3.x
- **Language:** Dart
- **Database:** SQLite (sqflite package)
- **State Management:** StatefulWidget
- **Architecture:** MVC (Model-View-Controller)
- **Platform Support:** Android, iOS, Windows, macOS, Linux

## Project Structure

The project is organized into separate modules for each exercise, following a clean architecture pattern:

```
lib/
├── bai1/           # Exercise 1 - Basic Note Taking
├── bai2/           # Exercise 2 - Categorized Notes
├── bai3/           # Exercise 3 - To-Do List
├── bai4/           # Exercise 4 - Expense Management
├── bai5/           # Exercise 5 - English-Vietnamese Dictionary
├── bai6/           # Exercise 6 - Image Gallery
├── bai7/           # Exercise 7 - Student-Course Management
├── bai8_log/       # Exercise 8 - Activity Logging
├── bai9/           # Exercise 9 - User Authentication
├── bai10/          # Exercise 10 - Login with Remember Me
└── main.dart       # Application Entry Point
```

Each exercise module contains:
- **models/** - Data models and entities
- **views/** - UI screens and widgets
- **controllers/** - Business logic and database operations
- **apps/** - Application configuration

## Exercise Details

### Exercise 1: Basic Note Taking Application

A simple note-taking application that allows users to create, read, update, and delete notes.

**Features:**
- Create new notes with title and content
- View all notes in a list
- Edit existing notes
- Delete notes with confirmation dialog
- SQLite database for data persistence
- Clean and intuitive user interface

**Database Schema:**
- Table: notes
- Fields: id (INTEGER PRIMARY KEY), title (TEXT), content (TEXT)

### Exercise 2: Categorized Notes Application

An enhanced note-taking application with category management functionality.

**Features:**
- Create and manage note categories
- Assign categories to notes
- Filter notes by category
- View all notes or filter by specific category
- Category-based organization
- Color-coded category chips

**Database Schema:**
- Table: categories (id, name)
- Table: notes (id, title, content, categoryId)
- Foreign key relationship between notes and categories

### Exercise 3: To-Do List Application

A task management application with import/export functionality.

**Features:**
- Add new tasks quickly
- Mark tasks as complete/incomplete
- Delete completed or unwanted tasks
- Export tasks to JSON file
- Import tasks from JSON file
- Task completion statistics
- Visual indication of completed tasks

**Database Schema:**
- Table: tasks
- Fields: id (INTEGER PRIMARY KEY), title (TEXT), isDone (INTEGER)

**JSON Format:**
```json
[
  {"title": "Task name", "isDone": 0}
]
```

### Exercise 4: Expense Management Application

A personal finance tracking application for managing expenses.

**Features:**
- Add expenses with amount and category
- Edit existing expenses
- Delete expense records
- View total expenses
- Category-wise expense breakdown
- Currency formatting (Vietnamese Dong)
- Visual expense summary

**Database Schema:**
- Table: expense_categories (id, name)
- Table: expenses (id, note, amount, categoryId)

### Exercise 5: English-Vietnamese Dictionary

A dictionary application with search functionality.

**Features:**
- Search English words
- Display Vietnamese meanings
- Real-time search as you type
- Pre-populated with sample vocabulary
- Alphabetically sorted results
- Fast search performance
- Clear search functionality

**Database Schema:**
- Table: words
- Fields: id (INTEGER PRIMARY KEY), word (TEXT), meaning (TEXT)

**Sample Data:**
- Contains common English words with Vietnamese translations
- Automatically initialized on first launch

### Exercise 6: Image Gallery Application

A simple image gallery management application.

**Features:**
- Add simulated images to gallery
- Display images in grid layout
- Delete images with long-press
- Colorful gradient placeholders
- Responsive grid design
- Image count tracking

**Database Schema:**
- Table: images
- Fields: id (INTEGER PRIMARY KEY), path (TEXT)

**Note:** Uses simulated image paths for demonstration purposes.

### Exercise 7: Student-Course Management System

A comprehensive system for managing students and course enrollments.

**Features:**
- Add and manage students
- Add and manage courses
- Enroll students in courses
- View student enrollments
- Many-to-many relationship handling
- Tab-based navigation
- Course enrollment interface

**Database Schema:**
- Table: students (id, name)
- Table: courses (id, name)
- Table: enrollments (id, studentId, courseId)
- Junction table for many-to-many relationship

### Exercise 8: Activity Logging System

An application that logs all CRUD operations for audit purposes.

**Features:**
- Add, edit, and delete items
- Automatic logging of all operations
- View complete activity log
- Timestamp for each operation
- Operation type tracking (ADD, UPDATE, DELETE)
- Detailed log viewer

**Database Schema:**
- Table: items (id, name)
- Table: logs (id, action, detail, timestamp)

**Log Format:**
- ADD: "Added item: [name]"
- UPDATE: "Updated item [id]: [old_name] to [new_name]"
- DELETE: "Deleted item [id]: [name]"

### Exercise 9: User Authentication System

A basic login system with hardcoded credentials.

**Features:**
- Email and password validation
- Login form with validation
- Password visibility toggle
- Success screen after login
- Form validation
- Error handling

**Credentials:**
- Email: admin@gmail.com
- Password: 123456

**Database Schema:**
- Table: users
- Fields: id (INTEGER PRIMARY KEY), email (TEXT), password (TEXT)

### Exercise 10: Login with Remember Me Feature

An advanced authentication system with persistent login.

**Features:**
- Login with email and password
- Remember me checkbox
- Persistent login using SharedPreferences
- Automatic login on app restart
- Splash screen with auto-navigation
- Logout functionality
- Session management

**Database Schema:**
- Table: users (id, email, password)

**Storage:**
- Uses SharedPreferences for storing login state
- Key: "isLoggedIn" (boolean)
- Key: "userEmail" (string)

## Installation and Setup

### Prerequisites

1. Flutter SDK (version 3.0 or higher)
2. Dart SDK (included with Flutter)
3. Android Studio or VS Code with Flutter extensions
4. Android Emulator or physical device for testing

### Installation Steps

1. Clone the repository:
```bash
git clone [repository-url]
cd bai8
```

2. Install dependencies:
```bash
flutter pub get
```

3. Check Flutter installation:
```bash
flutter doctor
```

4. Run the application:
```bash
flutter run
```

### Running on Specific Platforms

**Android Emulator:**
```bash
flutter emulators --launch [emulator-name]
flutter run -d [device-id]
```

**iOS Simulator (macOS only):**
```bash
open -a Simulator
flutter run -d [device-id]
```

**Windows Desktop:**
```bash
flutter run -d windows
```

**Web Browser:**
```bash
flutter run -d chrome
```

Note: SQLite functionality requires native platform (Android, iOS, Windows, macOS, Linux). Web platform is not fully supported due to SQLite limitations.

## Dependencies

The project uses the following Flutter packages:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0           # SQLite database
  path: ^1.8.3              # Path manipulation
  path_provider: ^2.1.1     # File system paths
  shared_preferences: ^2.2.2 # Local storage

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## Database Management

### Database Location

- **Android:** /data/data/[package-name]/databases/
- **iOS:** Application Documents Directory
- **Windows:** Application Data Directory

### Database Initialization

Each exercise initializes its own database on first launch. The database helper classes handle:
- Database creation
- Table schema definition
- Initial data population (where applicable)
- Version management
- Migration support

### Common Database Operations

**Create:**
```dart
await db.insert('table_name', data.toMap());
```

**Read:**
```dart
final List<Map<String, dynamic>> maps = await db.query('table_name');
```

**Update:**
```dart
await db.update('table_name', data.toMap(), where: 'id = ?', whereArgs: [id]);
```

**Delete:**
```dart
await db.delete('table_name', where: 'id = ?', whereArgs: [id]);
```

## Application Architecture

### MVC Pattern

The application follows the Model-View-Controller (MVC) architectural pattern:

**Model Layer:**
- Defines data structures
- Represents database entities
- Contains data validation logic
- Provides serialization methods (toMap, fromMap)

**View Layer:**
- Implements user interface
- Handles user interactions
- Displays data from controllers
- Manages UI state

**Controller Layer:**
- Contains business logic
- Manages database operations
- Handles data transformation
- Coordinates between Model and View

### State Management

The application uses StatefulWidget for state management:
- Local state management within widgets
- setState() for UI updates
- Async/await for database operations
- FutureBuilder for async data loading

## User Interface Design

### Design Principles

- Material Design 3 guidelines
- Consistent color schemes per exercise
- Intuitive navigation
- Responsive layouts
- Accessibility considerations
- Loading indicators for async operations
- Confirmation dialogs for destructive actions

### Common UI Components

- AppBar with title and actions
- FloatingActionButton for primary actions
- ListView for scrollable lists
- Card widgets for list items
- Dialog boxes for user input
- SnackBar for feedback messages
- Form validation
- Custom widgets for reusability

### Color Schemes

Each exercise uses a distinct color scheme:
- Exercise 1: Blue
- Exercise 2: Teal
- Exercise 3: Green
- Exercise 4: Orange
- Exercise 5: Purple
- Exercise 6: Pink
- Exercise 7: Cyan
- Exercise 8: Brown
- Exercise 9: Indigo
- Exercise 10: Deep Purple

## Testing

### Running Tests

```bash
flutter test
```

### Test Coverage

The project includes:
- Unit tests for models
- Widget tests for UI components
- Integration tests for database operations

### Manual Testing Checklist

For each exercise:
1. Create operation works correctly
2. Read operation displays data
3. Update operation modifies data
4. Delete operation removes data
5. UI responds to user interactions
6. Error handling works properly
7. Data persists after app restart

## Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: build/app/outputs/flutter-apk/app-release.apk

### Android App Bundle

```bash
flutter build appbundle --release
```

Output: build/app/outputs/bundle/release/app-release.aab

### iOS

```bash
flutter build ios --release
```

### Windows

```bash
flutter build windows --release
```

## Troubleshooting

### Common Issues

**Issue: Database not found**
- Solution: Ensure path_provider is properly configured
- Check database initialization in controller

**Issue: SQLite errors**
- Solution: Verify table schema matches model
- Check SQL syntax in queries

**Issue: UI not updating**
- Solution: Ensure setState() is called after data changes
- Verify async operations complete before UI update

**Issue: Build failures**
- Solution: Run flutter clean and flutter pub get
- Check Flutter and Dart SDK versions

## Performance Optimization

### Database Optimization

- Use indexes on frequently queried columns
- Batch operations when possible
- Close database connections properly
- Use transactions for multiple operations

### UI Optimization

- Implement lazy loading for large lists
- Use const constructors where possible
- Minimize widget rebuilds
- Optimize image loading and caching

## Future Enhancements

Potential improvements for each exercise:

1. Cloud synchronization
2. Data backup and restore
3. Advanced search and filtering
4. Data export to multiple formats
5. User preferences and settings
6. Dark mode support
7. Localization and internationalization
8. Offline-first architecture
9. Push notifications
10. Analytics and reporting

## Contributing

This is an educational project. Contributions, suggestions, and feedback are welcome.

## License

This project is created for educational purposes as part of mobile application development coursework.

## Contact

For questions or feedback, please contact:
- Name: Phan Cong Tri
- Student ID: 6451071080

## Acknowledgments

- Flutter team for the excellent framework
- SQLite for reliable database management
- Material Design for UI guidelines
- Course instructors and teaching assistants

## Version History

- Version 1.0.0 - Initial release with all 10 exercises
- All exercises fully functional with SQLite integration
- Complete MVC architecture implementation
- Comprehensive documentation

## Conclusion

This project demonstrates proficiency in Flutter mobile application development, including database management, state management, UI design, and various mobile app features. Each exercise builds upon fundamental concepts to create practical, real-world applications.
