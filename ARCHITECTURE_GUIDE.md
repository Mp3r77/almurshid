# Al Murshid - Healthcare App Architecture Guide

## 📋 Overview

This document describes the Clean Architecture implementation for the Al Murshid healthcare Flutter application.

---

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │   Pages     │  │   Widgets   │  │      BLoC       │  │
│  └─────────────┘  └─────────────┘  └─────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                      DOMAIN                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │  Entities   │  │ Repository  │  │    Use Cases    │  │
│  │             │  │ Contracts   │  │                 │  │
│  └─────────────┘  └─────────────┘  └─────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                       DATA                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │   Models    │  │Data Sources │  │ Repository     │  │
│  │             │  │             │  │ Implementation  │  │
│  └─────────────┘  └─────────────┘  └─────────────────┘  │
├─────────────────────────────────────────────────────────┤
│                       CORE                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │  Constants  │  │   Network   │  │    Theme        │  │
│  └─────────────┘  └─────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
lib/
├── app/
│   ├── injection_container.dart      # Dependency Injection
│   └── app_router.dart               # Navigation (future)
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Color constants
│   │   ├── app_dimensions.dart       # Spacing, sizing
│   │   ├── app_strings.dart          # String constants
│   │   └── endpoints.dart            # API endpoints
│   │
│   ├── error/
│   │   ├── exceptions.dart          # Custom exceptions
│   │   ├── failures.dart             # Failure classes
│   │   └── error_handler.dart        # Error utilities
│   │
│   ├── network/
│   │   ├── api_client.dart          # Dio HTTP client
│   │   └── network_info.dart         # Connectivity checker
│   │
│   ├── theme/
│   │   └── app_theme.dart           # Light/Dark themes
│   │
│   ├── usecases/
│   │   ├── usecase.dart             # Base use case
│   │   └── async_usecase.dart       # Async variants
│   │
│   ├── utils/
│   │   ├── functional_utils.dart     # Helper functions
│   │   └── validation_utils.dart     # Validators
│   │
│   └── widgets/
│       └── common_widgets.dart       # Shared widgets
│
├── features/
│   ├── doctors/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── doctors_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── doctor_model.dart
│   │   │   └── repositories/
│   │   │       └── doctors_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── doctor_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── doctors_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_doctors.dart
│   │   │       └── search_doctors.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── doctors_bloc.dart
│   │       │   ├── doctors_event.dart
│   │       │   └── doctors_state.dart
│   │       ├── pages/
│   │       │   └── doctors_list_page.dart
│   │       └── widgets/
│   │           └── doctor_card.dart
│   │
│   ├── appointments/
│   ├── labs/
│   └── diagnosis/
│
└── main.dart
```

---

## 🔄 Data Flow

### 1. User Action
```
User taps "Search" → UI dispatches Event
```

### 2. BLoC Processing
```
Event → BLoC → UseCase.call(params)
```

### 3. Business Logic
```
UseCase → Repository (interface)
```

### 4. Data Fetching
```
Repository → DataSource → API Client → Server
```

### 5. Response Handling
```
DataSource (throws Exception) 
    ↓
Repository (catches, converts to Failure)
    ↓
UseCase (returns Either<Failure, Data>)
    ↓
BLoC (receives Either)
    ↓
Emits new State
```

### 6. UI Update
```
State change → UI rebuilds via BlocBuilder
```

---

## 🎯 Key Patterns

### Use Case Pattern
```dart
// Every business operation is a Use Case
class GetAllDoctors implements UseCase<List<DoctorEntity>, NoParams> {
  final DoctorsRepository repository;

  GetAllDoctors(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(NoParams params) async {
    return await repository.getAllDoctors();
  }
}
```

### Either Pattern (Error Handling)
```dart
// Success
result.fold(
  (failure) => handleError(failure),  // Left side
  (data) => handleSuccess(data),        // Right side
);
```

### Repository Pattern
```dart
// Abstract contract (domain layer)
abstract class DoctorsRepository {
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors();
}

// Concrete implementation (data layer)
@LazySingleton(as: DoctorsRepository)
class DoctorsRepositoryImpl implements DoctorsRepository {
  // Implementation...
}
```

### Entity vs Model
```dart
// Entity - Domain Layer (Pure Dart, no dependencies)
class DoctorEntity extends Equatable {
  final String id;
  final String name;
  // ... no JSON, no parsing
}

// Model - Data Layer (Has JSON serialization)
class DoctorModel extends DoctorEntity {
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    // JSON parsing here
  }
  
  DoctorEntity toEntity() {
    // Convert to domain entity
  }
}
```

---

## 🔧 Dependency Injection

Using `get_it` + `injectable`:

```dart
// Register in injection_container.dart
// Annotate classes:
@lazySingleton    // Single instance
@injectable      // New instance each time
@LazySingleton(as: SomeAbstract)  // Register implementation

// Use in widgets/BLoCs:
final bloc = sl<MyBloc>();
final repo = sl<MyRepository>();
```

---

## 📝 Code Standards

### 1. Naming Conventions
- **Classes**: PascalCase (`DoctorsRepository`)
- **Methods/Functions**: camelCase (`getAllDoctors`)
- **Private members**: `_underscorePrefix` (`_repository`)
- **Constants**: camelCase (`maxRetries`)
- **Files**: snake_case (`doctors_repository.dart`)

### 2. File Organization
- One class per file
- Group related files in directories
- Feature-first organization

### 3. Documentation
- Document public APIs
- Use doc comments (`///`)
- Keep comments up-to-date

### 4. Error Handling
- Always use `Either<Failure, Success>`
- Never swallow exceptions silently
- Provide meaningful error messages

---

## 🚀 Best Practices

### ✅ DO:
- Use use cases for all business logic
- Keep entities pure (no external dependencies)
- Use Equatable for state comparison
- Handle loading, error, and empty states
- Use const constructors where possible
- Implement proper error boundaries

### ❌ DON'T:
- Put business logic in widgets/BLoCs
- Make API calls directly from UI
- Use dynamic types unnecessarily
- Skip error handling
- Create god objects/classes

---

## 📊 Testing Strategy

### Unit Tests
- Use cases
- Repository implementations
- BLoC logic

### Widget Tests
- Individual widgets
- State changes

### Integration Tests
- Feature flows
- Navigation

---

## 🔮 Future Improvements

1. **Navigation**: Add `go_router` for declarative routing
2. **Caching**: Implement local caching with `hive` or `drift`
3. **Pagination**: Add pagination support to lists
4. **Authentication**: Implement auth flow with secure token storage
5. **Analytics**: Add crash reporting and analytics
6. **Testing**: Add comprehensive test coverage

---

## 📚 Resources

- [Flutter Clean Architecture](https://resocoder.com/2019/08/27/flutter-clean-architecture-ep-1-the-big-picture/)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Dartz (Either)](https://pub.dev/packages/dartz)
- [GetIt DI](https://pub.dev/packages/get_it)

---

## 🆘 Getting Help

For architecture questions or issues:
1. Review this guide
2. Check code comments
3. Consult Clean Architecture literature
