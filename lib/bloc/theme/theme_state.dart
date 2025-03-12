import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum ThemeType { light, dark }

class ThemeState extends Equatable {
  final ThemeType themeType;
  final ThemeData themeData;

  const ThemeState({
    required this.themeType,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      themeType: ThemeType.light,
      themeData: AppTheme.getLightTheme(),
    );
  }

  ThemeState copyWith({
    ThemeType? themeType,
    ThemeData? themeData,
  }) {
    return ThemeState(
      themeType: themeType ?? this.themeType,
      themeData: themeData ?? this.themeData,
    );
  }

  @override
  List<Object> get props => [themeType];
} 