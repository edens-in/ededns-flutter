# Eden's Shop

A modern e-commerce Flutter application with a focus on fashion and lifestyle products. The app features a clean, intuitive interface with smooth animations and a responsive design.

## Features

- 🎨 Modern UI with custom animations
- 🌓 Dark/Light theme support
- 🔍 Voice-enabled search functionality
- 🎯 Category-based product browsing
- 🔄 Auto-sliding promotional banners
- 📱 Responsive design
- 🔐 User authentication
- 🌐 Network connectivity handling

## Getting Started

### Prerequisites

- Flutter (Latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/edens.git
```

2. Navigate to the project directory
```bash
cd edens
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Architecture

The app follows the BLoC (Business Logic Component) pattern for state management. Key architectural decisions include:

- Clean separation of UI, business logic, and data layers
- BLoC pattern for state management
- Service-based architecture for core functionalities
- Reusable widgets for consistent UI elements

## Project Structure

```
lib/
  ├── bloc/           # BLoC pattern implementations
  ├── models/         # Data models
  ├── screens/        # App screens
  ├── services/       # Service layer
  ├── theme/          # Theme configuration
  ├── widgets/        # Reusable widgets
  └── main.dart       # App entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
