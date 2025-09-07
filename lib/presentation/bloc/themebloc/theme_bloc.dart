import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.light)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
    // Fire initial event to load saved theme
    add(LoadTheme());
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    // Get instance of SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Read the string of the saved theme (can be null if it was never saved)
    final themeString = prefs.getString('theme');

    // If saved and contains "dark", use Theme Mode.dark; otherwise ThemeMode.light
    final theme = themeString != null && themeString.contains('dark')
        ? ThemeMode.dark
        : ThemeMode.light;
    // Emit the initial state with the theme loaded
    emit(ThemeState(theme));
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    // Switch between light and dark depending on the current state
    final newTheme = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    // Emit the new state to update the UI
    emit(ThemeState(newTheme));
    // Save the new theme to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    //remove or add dark instance
    await prefs.setString('theme', newTheme.toString());
  }
}
