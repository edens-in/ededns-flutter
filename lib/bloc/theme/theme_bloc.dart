import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetLightTheme>(_onSetLightTheme);
    on<SetDarkTheme>(_onSetDarkTheme);
    
    // Load saved theme on initialization
    _loadSavedTheme();
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newThemeType = state.themeType == ThemeType.light
        ? ThemeType.dark
        : ThemeType.light;
    
    final newThemeData = newThemeType == ThemeType.light
        ? AppTheme.getLightTheme()
        : AppTheme.getDarkTheme();
    
    emit(state.copyWith(
      themeType: newThemeType,
      themeData: newThemeData,
    ));
    
    _saveThemePreference(newThemeType);
  }

  void _onSetLightTheme(SetLightTheme event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeType: ThemeType.light,
      themeData: AppTheme.getLightTheme(),
    ));
    
    _saveThemePreference(ThemeType.light);
  }

  void _onSetDarkTheme(SetDarkTheme event, Emitter<ThemeState> emit) {
    emit(state.copyWith(
      themeType: ThemeType.dark,
      themeData: AppTheme.getDarkTheme(),
    ));
    
    _saveThemePreference(ThemeType.dark);
  }

  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('isDarkTheme') ?? false;
      
      if (isDark) {
        add(SetDarkTheme());
      } else {
        add(SetLightTheme());
      }
    } catch (e) {
      // If there's an error, use default theme
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveThemePreference(ThemeType themeType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkTheme', themeType == ThemeType.dark);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
} 