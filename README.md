# Session 8 - Local Database with SQLite in Flutter

## Table of Contents

- [Overview](#overview)
- [Learning Objectives](#learning-objectives)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Architecture](#project-architecture)
- [Project Structure](#project-structure)
- [Database Design](#database-design)
- [Exercise 1 - Basic Note Application (SQLite CRUD)](#exercise-1---basic-note-application-sqlite-crud)
- [Exercise 2 - Notes with Categories (SQLite with Foreign Keys)](#exercise-2---notes-with-categories-sqlite-with-foreign-keys)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Dependencies](#dependencies)
- [Application Flow](#application-flow)
- [Key Implementation Details](#key-implementation-details)
- [Screenshots](#screenshots)
- [Troubleshooting](#troubleshooting)
- [References](#references)

---

## Overview

This project is a Flutter mobile application developed as part of **Session 8 (Buoi 8)** of the Mobile Programming course. The primary focus of this session is on implementing **local data persistence** using **SQLite** through the `sqflite` package in Flutter. The application demonstrates how to perform full CRUD (Create, Read, Update, Delete) operations on a local SQLite database, manage relational data with foreign keys, and structure a Flutter project using the MVC (Model-View-Controller) architectural pattern.

The project consists of two independent exercises, each building upon the concepts of local database management:

1. **Exercise 1** introduces basic SQLite operations through a simple note-taking application.
2. **Exercise 2** extends the concept by introducing a category system with foreign key relationships between tables, along with advanced features such as filtering and dropdown-based category selection.

Both exercises are accessible from a unified home screen that serves as a navigation hub, allowing users to select which exercise they want to explore.

---

## Learning Objectives

By completing this project, the following learning objectives are achieved:

- Understanding how to integrate SQLite databases into Flutter applications using the `sqflite` package.
- Learning how to design and create database tables with proper column types and constraints.
- Implementing full CRUD operations (Create, Read, Update, Delete) against a local SQLite database.
- Working with foreign key relationships between multiple database tables.
- Using SQL JOIN queries to retrieve related data from multiple tables simultaneously.
- Applying the MVC (Model-View-Controller) architectural pattern to organize Flutter code effectively.
- Implementing the Singleton design pattern for database helper classes to ensure only one database connection exists throughout the application lifecycle.
- Building reusable UI components (widgets) that can be shared across different views.
- Managing asynchronous operations in Flutter using `Future` and `async/await` syntax.
- Handling user input validation with `Form` and `TextFormField` widgets.
- Navigating between screens and passing data back to previous screens using `Navigator`.

---

## Features

### General Features

- Material Design 3 (Material You) UI with modern, clean aesthetics.
- Unified home screen with card-based navigation to each exercise.
- Responsive layout that adapts to different screen sizes.
- Loading indicators during asynchronous database operations.
- SnackBar notifications for user feedback on successful or failed operations.
- Confirmation dialogs before destructive actions (e.g., deleting a note).
- Form validation to prevent empty or invalid data from being saved.

### Exercise 1 - Basic Note Application

- Create new notes with a title and content.
- View all saved notes in a scrollable list, ordered by most recent first.
- Edit existing notes by tapping on them in the list.
- Delete notes with a confirmation dialog to prevent accidental deletion.
- Empty state UI that guides users when no notes exist yet.
- Persistent storage using SQLite - data survives app restarts.

### Exercise 2 - Notes with Categories

- All features from Exercise 1, plus:
- Create and manage custom categories for organizing notes.
- Assign a category to each note using a dropdown selector.
- Filter notes by category using horizontal filter chips.
- View category names displayed on each note card as a badge.
- Pre-seeded default categories ("Work", "Personal", "Study") on first database creation.
- Cascading delete - when a category is deleted, all associated notes are automatically removed.
- SQL INNER JOIN queries to fetch notes along with their category names in a single query.

---

## Technology Stack

| Component         | Technology                          |
|-------------------|-------------------------------------|
| Framework         | Flutter (Dart)                      |
| SDK Version       | Dart SDK ^3.11.1                    |
| Database          | SQLite via `sqflite` ^2.4.2         |
| Path Utilities    | `path` ^1.9.1                       |
| UI Framework      | Material Design 3 (Material You)    |
| State Management  | StatefulWidget with setState        |
| Architecture      | MVC (Model-View-Controller)         |
| Design Pattern    | Singleton (DatabaseHelper)          |
| Platform Support  | Android, iOS, Windows, macOS, Linux |

---

## Project Architecture

The project follows the **MVC (Model-View-Controller)** architectural pattern. Each exercise is self-contained within its own directory and follows the same organizational structure:

```
MVC Architecture:

[Model]  <-->  [Controller]  <-->  [View]
   |                                  |
   v                                  v
[Database Helper]              [Widget Components]
   |
   v
[SQLite Database]
```

### Layer Responsibilities

- **Model Layer**: Defines the data structures (e.g., `Note`, `Category`) with serialization methods (`toMap`, `fromMap`) for converting between Dart objects and SQLite-compatible Map structures.

- **View Layer**: Contains the UI screens (`NoteListView`, `NoteFormView`, `CategoryFormView`) that display data to the user and capture user input. Views delegate all business logic to controllers.

- **Controller Layer**: Acts as the intermediary between Views and the database. Controllers (`NoteController`, `CategoryController`) contain business logic such as input validation and coordinate data flow between the UI and the data layer.

- **Utils Layer**: Contains the `DatabaseHelper` class, which is a Singleton responsible for initializing the SQLite database, creating tables, and providing low-level data access methods (insert, query, update, delete).

- **Widgets Layer**: Houses reusable UI components (`NoteCard`, `CategoryDropdown`) that are used across different views to maintain consistency and reduce code duplication.

- **Apps Layer**: Contains standalone `MaterialApp` wrappers for each exercise. These are provided as alternative entry points in case each exercise needs to run independently.

---

## Project Structure

```
bai8/
|-- lib/
|   |-- main.dart                              # Main entry point with home screen navigation
|   |
|   |-- bai1/                                  # Exercise 1: Basic Note App
|   |   |-- apps/
|   |   |   |-- bai1_app.dart                  # Standalone MaterialApp wrapper
|   |   |-- controllers/
|   |   |   |-- note_controller.dart           # Business logic for note operations
|   |   |-- models/
|   |   |   |-- note.dart                      # Note data model (id, title, content)
|   |   |-- utils/
|   |   |   |-- database_helper.dart           # SQLite database helper (Singleton)
|   |   |-- views/
|   |   |   |-- note_list_view.dart            # Main screen displaying all notes
|   |   |   |-- note_form_view.dart            # Form screen for creating/editing notes
|   |   |-- widgets/
|   |       |-- note_card.dart                 # Reusable note card widget
|   |
|   |-- bai2/                                  # Exercise 2: Notes with Categories
|       |-- apps/
|       |   |-- bai2_app.dart                  # Standalone MaterialApp wrapper
|       |-- controllers/
|       |   |-- note_controller.dart           # Note controller with category support
|       |   |-- category_controller.dart       # Category management controller
|       |-- models/
|       |   |-- note.dart                      # Extended Note model with categoryId
|       |   |-- category.dart                  # Category data model (id, name)
|       |-- utils/
|       |   |-- database_helper.dart           # Database helper with two tables and JOIN queries
|       |-- views/
|       |   |-- note_list_view.dart            # Note list with category filter chips
|       |   |-- note_form_view.dart            # Note form with category dropdown
|       |   |-- category_form_view.dart        # Form for adding new categories
|       |-- widgets/
|           |-- note_card.dart                 # Note card with category badge display
|           |-- category_dropdown.dart         # Reusable category dropdown selector
|
|-- pubspec.yaml                               # Project dependencies and configuration
|-- analysis_options.yaml                      # Dart analysis and lint rules
|-- README.md                                  # This documentation file
```

---

## Database Design

### Exercise 1 - Single Table Schema

Exercise 1 uses a single `notes` table stored in the file `bai1_notes.db`:

**Table: `notes`**

| Column    | Type    | Constraints                   | Description                         |
|-----------|---------|-------------------------------|-------------------------------------|
| `id`      | INTEGER | PRIMARY KEY AUTOINCREMENT     | Unique auto-incrementing identifier |
| `title`   | TEXT    | NOT NULL                      | The title of the note               |
| `content` | TEXT    | NOT NULL                      | The body content of the note        |

**SQL CREATE Statement:**

```sql
CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL
);
```

### Exercise 2 - Relational Schema with Foreign Keys

Exercise 2 uses two related tables stored in the file `bai2_notes.db`:

**Table: `categories`**

| Column | Type    | Constraints               | Description                         |
|--------|---------|---------------------------|-------------------------------------|
| `id`   | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique auto-incrementing identifier |
| `name` | TEXT    | NOT NULL                  | The name of the category            |

**Table: `notes`**

| Column       | Type    | Constraints                          | Description                              |
|--------------|---------|--------------------------------------|------------------------------------------|
| `id`         | INTEGER | PRIMARY KEY AUTOINCREMENT            | Unique auto-incrementing identifier      |
| `title`      | TEXT    | NOT NULL                             | The title of the note                    |
| `content`    | TEXT    | NOT NULL                             | The body content of the note             |
| `categoryId` | INTEGER | NOT NULL, FOREIGN KEY -> categories  | Foreign key referencing categories table |

**SQL CREATE Statements:**

```sql
CREATE TABLE categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    categoryId INTEGER NOT NULL,
    FOREIGN KEY (categoryId) REFERENCES categories (id)
        ON DELETE CASCADE
);
```

**Entity Relationship:**

```
categories (1) ---< (many) notes
    |                        |
    +-- id (PK)              +-- id (PK)
    +-- name                 +-- title
                             +-- content
                             +-- categoryId (FK -> categories.id)
```

**Seed Data:**

Upon first database creation, three default categories are automatically inserted:
- "Cong viec" (Work)
- "Ca nhan" (Personal)
- "Hoc tap" (Study)

---

## Exercise 1 - Basic Note Application (SQLite CRUD)

### Description

Exercise 1 implements a straightforward note-taking application that demonstrates the fundamental CRUD operations with SQLite in Flutter. Users can create notes with a title and content, view them in a scrollable list, tap a note to edit it, and delete notes with a confirmation dialog.

### Data Model

The `Note` class in Exercise 1 contains three fields:

```dart
class Note {
    final int? id;       // Nullable because it's auto-generated by SQLite
    final String title;  // Required note title
    final String content; // Required note content
}
```

Key methods:
- `toMap()` - Converts the Note object to a Map for SQLite insertion.
- `Note.fromMap()` - Factory constructor to create a Note from a database query result Map.
- `copyWith()` - Creates a modified copy of the Note (immutability pattern).

### Database Operations

The `DatabaseHelper` class in Exercise 1 provides the following operations:

| Method          | SQL Operation | Description                                    |
|-----------------|---------------|------------------------------------------------|
| `insertNote`    | INSERT        | Adds a new note to the database                |
| `getAllNotes`    | SELECT        | Retrieves all notes, ordered by ID descending  |
| `getNoteById`   | SELECT WHERE  | Retrieves a single note by its ID              |
| `updateNote`    | UPDATE        | Updates an existing note's title and content   |
| `deleteNote`    | DELETE        | Removes a note from the database by its ID     |

### User Interface

- **Note List View**: Displays all notes using a `ListView.builder`. Shows an empty state with helpful text when no notes exist. Includes a floating action button (+) to create new notes.
- **Note Form View**: A form with validated text fields for title (single line) and content (multi-line, 8 rows). Supports both creating new notes and editing existing ones based on whether a `Note` object is passed to it.

---

## Exercise 2 - Notes with Categories (SQLite with Foreign Keys)

### Description

Exercise 2 extends the basic note application by introducing a **category system**. Each note must be assigned to a category, and users can filter the note list by category. This exercise demonstrates working with multiple database tables, foreign key constraints, SQL JOIN queries, and more complex UI components like dropdown selectors and filter chips.

### Data Models

**Note Model (Extended):**

```dart
class Note {
    final int? id;
    final String title;
    final String content;
    final int categoryId;        // Foreign key to categories table
    final String? categoryName;  // Populated via SQL JOIN (not stored in DB)
}
```

**Category Model:**

```dart
class Category {
    final int? id;
    final String name;
}
```

The `Category` class overrides `==` and `hashCode` operators based on the `id` field to enable proper comparison in dropdown widgets and filter chips.

### Database Operations

The `DatabaseHelper` class in Exercise 2 provides operations for both tables:

**Category Operations:**

| Method             | SQL Operation | Description                                          |
|--------------------|---------------|------------------------------------------------------|
| `insertCategory`   | INSERT        | Adds a new category                                  |
| `getAllCategories`  | SELECT        | Retrieves all categories, ordered alphabetically     |
| `deleteCategory`   | DELETE        | Removes a category and all its associated notes      |

**Note Operations:**

| Method               | SQL Operation        | Description                                              |
|-----------------------|----------------------|----------------------------------------------------------|
| `insertNote`          | INSERT               | Adds a new note with a category assignment               |
| `getAllNotes`          | SELECT + INNER JOIN  | Retrieves all notes with category names                  |
| `getNotesByCategory`  | SELECT + INNER JOIN + WHERE | Retrieves notes filtered by a specific category   |
| `updateNote`          | UPDATE               | Updates a note's title, content, and category            |
| `deleteNote`          | DELETE               | Removes a specific note by ID                            |

**JOIN Query Used:**

```sql
SELECT notes.*, categories.name as categoryName
FROM notes
INNER JOIN categories ON notes.categoryId = categories.id
ORDER BY notes.id DESC
```

### User Interface

- **Note List View**: Includes a horizontal scrollable row of `FilterChip` widgets at the top for filtering notes by category. An "All" chip shows all notes regardless of category. The app bar includes an action button to navigate to the category management form.
- **Note Form View**: Similar to Exercise 1 but includes a `CategoryDropdown` widget for selecting the category when creating or editing a note. When editing, the dropdown automatically pre-selects the note's current category.
- **Category Form View**: A dedicated screen for adding new categories with a validated text input field.
- **Note Card Widget**: Enhanced version that displays a category badge below the note content, showing which category the note belongs to.

---

## Getting Started

### Prerequisites

Before running this project, ensure you have the following installed on your development machine:

1. **Flutter SDK** (version 3.11.1 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter doctor`

2. **Dart SDK** (version 3.11.1 or higher, included with Flutter)

3. **Android Studio** or **Visual Studio Code** with Flutter and Dart plugins installed.

4. **An Android Emulator** or a **physical Android/iOS device** connected for testing.
   - Note: `sqflite` does NOT support Flutter Web. This app must be run on Android, iOS, Windows, macOS, or Linux.

### Installation

1. **Clone the repository:**

```bash
git clone <repository-url>
cd buoi8/bai8
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Verify the project setup:**

```bash
flutter doctor
```

### Running the Application

**On an Android emulator or connected device:**

```bash
flutter run
```

**On a specific device (if multiple are connected):**

```bash
flutter devices          # List available devices
flutter run -d <device-id>
```

**On Windows desktop:**

```bash
flutter run -d windows
```

**Build a release APK (for Android):**

```bash
flutter build apk --release
```

The release APK can be found at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Dependencies

This project uses the following packages, as defined in `pubspec.yaml`:

### Runtime Dependencies

| Package          | Version  | Purpose                                                        |
|------------------|----------|----------------------------------------------------------------|
| `flutter`        | SDK      | Core Flutter framework                                         |
| `cupertino_icons` | ^1.0.8  | iOS-style icons for Cupertino widgets                          |
| `sqflite`        | ^2.4.2   | SQLite plugin for Flutter - provides local database support    |
| `path`           | ^1.9.1   | Cross-platform path manipulation for database file location    |

### Development Dependencies

| Package          | Version  | Purpose                                                        |
|------------------|----------|----------------------------------------------------------------|
| `flutter_test`   | SDK      | Flutter testing framework                                      |
| `flutter_lints`  | ^6.0.0   | Recommended lint rules for Flutter projects                    |

---

## Application Flow

### Home Screen Flow

```
App Launch
    |
    v
Home Screen (MainApp)
    |
    |-- Tap "Exercise 1" Card --> Navigate to Bai1 NoteListView
    |
    |-- Tap "Exercise 2" Card --> Navigate to Bai2 NoteListView
```

### Exercise 1 Flow

```
NoteListView (List Screen)
    |
    |-- [FAB +] --> NoteFormView (Create Mode)
    |                   |
    |                   |-- Fill title & content --> Save --> Return to list (refreshed)
    |
    |-- [Tap Note] --> NoteFormView (Edit Mode)
    |                   |
    |                   |-- Modify title & content --> Update --> Return to list (refreshed)
    |
    |-- [Delete Icon] --> Confirmation Dialog
                            |
                            |-- Confirm --> Delete note --> Refresh list
                            |-- Cancel  --> Dismiss dialog
```

### Exercise 2 Flow

```
NoteListView (List Screen with Category Filters)
    |
    |-- [Filter Chips] --> Filter notes by selected category or show all
    |
    |-- [AppBar Folder Icon] --> CategoryFormView
    |                               |
    |                               |-- Enter category name --> Save --> Return (refreshed)
    |
    |-- [FAB +] --> NoteFormView (Create Mode with Category Dropdown)
    |                   |
    |                   |-- Select category, fill title & content --> Save --> Return
    |
    |-- [Tap Note] --> NoteFormView (Edit Mode with pre-selected Category)
    |                   |
    |                   |-- Modify any field --> Update --> Return (refreshed)
    |
    |-- [Delete Icon] --> Confirmation Dialog --> Confirm/Cancel
```

---

## Key Implementation Details

### Singleton Pattern for Database Access

Both exercises use the Singleton pattern to ensure only one instance of `DatabaseHelper` exists throughout the app lifecycle. This prevents issues with multiple database connections and ensures thread safety:

```dart
class DatabaseHelper {
    static final DatabaseHelper instance = DatabaseHelper._init();
    static Database? _database;

    DatabaseHelper._init(); // Private constructor

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDB('database_name.db');
        return _database!;
    }
}
```

### Lazy Database Initialization

The database is not created when the `DatabaseHelper` is instantiated. Instead, it is lazily initialized the first time the `database` getter is called. This improves startup performance and ensures the database is only created when needed.

### Map-Based Serialization

Since SQLite does not natively support Dart objects, each model class implements `toMap()` and `fromMap()` methods for converting between Dart objects and SQLite-compatible `Map<String, dynamic>` structures:

```dart
// Dart Object --> SQLite Map
Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
}

// SQLite Map --> Dart Object
factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], title: map['title'], content: map['content']);
}
```

### Asynchronous Database Operations

All database operations are asynchronous and return `Future` objects. The UI uses `async/await` to handle these operations without blocking the main thread:

```dart
Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _noteController.getAllNotes();
    setState(() {
        _notes = notes;
        _isLoading = false;
    });
}
```

### Navigation with Data Return

The project uses Flutter's navigation system to pass data between screens. When a note is successfully created or updated, the form view returns `true` to the list view, which then triggers a data refresh:

```dart
// Navigating to form and waiting for result
final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => NoteFormView(note: note)),
);
if (result == true) {
    _loadNotes(); // Refresh the list
}

// Returning result from form
Navigator.pop(context, true); // true = operation was successful
```

### Cascading Deletes in Exercise 2

When a category is deleted in Exercise 2, all notes belonging to that category are automatically deleted first. This is implemented both at the SQL level (via `ON DELETE CASCADE` in the foreign key constraint) and at the application level (explicit delete before category removal):

```dart
Future<int> deleteCategory(int id) async {
    final db = await database;
    await db.delete('notes', where: 'categoryId = ?', whereArgs: [id]);
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
}
```

### Form Validation

Both exercises use Flutter's built-in form validation system with `Form`, `GlobalKey<FormState>`, and `TextFormField` validators to ensure that required fields are not empty before saving:

```dart
validator: (value) {
    if (value == null || value.trim().isEmpty) {
        return 'Please enter a title';
    }
    return null;
}
```

---

## Screenshots

_Screenshots can be added here to demonstrate the application's UI on different screens._

| Screen                        | Description                                           |
|-------------------------------|-------------------------------------------------------|
| Home Screen                   | Main navigation hub with cards for each exercise      |
| Exercise 1 - Note List        | List of all notes with empty state handling            |
| Exercise 1 - Add/Edit Note    | Form for creating or editing a note                   |
| Exercise 1 - Delete Dialog    | Confirmation dialog before deleting a note            |
| Exercise 2 - Note List        | Notes displayed with category filter chips at top     |
| Exercise 2 - Add Note         | Note form with category dropdown selector             |
| Exercise 2 - Add Category     | Form for creating a new category                      |
| Exercise 2 - Filtered View    | Notes filtered by a specific category                 |

---

## Troubleshooting

### Common Issues and Solutions

**1. "sqflite" plugin not found or MissingPluginException**

This error occurs when running on Flutter Web, which is not supported by `sqflite`. Run the app on Android, iOS, or a desktop platform instead:

```bash
flutter run -d android
flutter run -d windows
```

**2. Database not persisting data after restart**

Ensure you are running on a real device or emulator, not in a web browser. Also verify that the `getDatabasesPath()` function is returning a valid path on your platform.

**3. "No matching constructor found" or model errors**

If you modify the database schema after initial creation, the old database file may still exist with the old schema. Uninstall the app from the emulator/device and reinstall to force database recreation:

```bash
flutter clean
flutter run
```

**4. Foreign key constraint errors (Exercise 2)**

If you encounter foreign key errors, ensure that:
- A category exists before creating a note that references it.
- The `categoryId` in the note corresponds to a valid `id` in the `categories` table.

**5. Build errors after cloning**

Run the following commands to resolve dependency issues:

```bash
flutter clean
flutter pub get
flutter run
```

---

## References

- [Flutter Official Documentation](https://docs.flutter.dev/)
- [sqflite Package on pub.dev](https://pub.dev/packages/sqflite)
- [SQLite Official Documentation](https://www.sqlite.org/docs.html)
- [Flutter Cookbook - Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Dart Language Tour](https://dart.dev/language)
- [Material Design 3 for Flutter](https://m3.material.io/)

---

## License

This project is developed for educational purposes as part of the Mobile Programming course curriculum. It is intended for academic use and learning.
