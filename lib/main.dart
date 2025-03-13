import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/main_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'bloc/home/home_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_state.dart';
import 'bloc/connectivity/connectivity_bloc.dart';
import 'services/snackbar_service.dart';
import 'widgets/connectivity_listener.dart';
import 'config/app_config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize app configuration
  AppConfig.initialize(
    env: const String.fromEnvironment('FLUTTER_ENV') == 'prod' 
        ? Environment.prod 
        : Environment.dev,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<ConnectivityBloc>(
          create: (context) => ConnectivityBloc(),
          lazy: false, // Initialize immediately
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Eden\'s Shop',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
            initialRoute: '/',
            routes: {
              '/': (context) => ConnectivityListener(child: const MainScreen()),
              '/signup': (context) => const SignupScreen(),
              '/login': (context) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
