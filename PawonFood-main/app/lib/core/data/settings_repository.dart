import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'listings_repository.dart';
import 'onboarding_repository.dart';

/// App settings (D18d, D18f-D18h) with local persistence via SharedPreferences.
class AppSettings {
  const AppSettings({
    this.newMessages = true,
    this.offerUpdates = true,
    this.pickupReminder = true,
    this.nearbyFood = true,
    this.quietHours = true,
    this.quietFrom = const TimeOfDay(hour: 22, minute: 0),
    this.quietTo = const TimeOfDay(hour: 6, minute: 0),
    this.radiusMeters = 1000,
    this.themeMode = ThemeMode.system,
    this.fontScale = 1.0,
    this.reducedMotion = false,
    this.dataSaver = false,
  });

  final bool newMessages;
  final bool offerUpdates;
  final bool pickupReminder;
  final bool nearbyFood;
  final bool quietHours;
  final TimeOfDay quietFrom;
  final TimeOfDay quietTo;
  final double radiusMeters;
  final ThemeMode themeMode;
  final double fontScale;
  final bool reducedMotion;
  final bool dataSaver;

  String get themeModeLabel => switch (themeMode) {
        ThemeMode.system => 'Ikuti sistem',
        ThemeMode.light => 'Mode Terang',
        ThemeMode.dark => 'Mode Gelap',
      };

  String get fontScaleLabel => switch (fontScale) {
        <= 0.90 => 'Kecil (85%)',
        <= 1.05 => 'Standar (100%)',
        <= 1.20 => 'Besar (115%)',
        _ => 'Sangat besar (130%)',
      };

  AppSettings copyWith({
    bool? newMessages,
    bool? offerUpdates,
    bool? pickupReminder,
    bool? nearbyFood,
    bool? quietHours,
    TimeOfDay? quietFrom,
    TimeOfDay? quietTo,
    double? radiusMeters,
    ThemeMode? themeMode,
    double? fontScale,
    bool? reducedMotion,
    bool? dataSaver,
  }) =>
      AppSettings(
        newMessages: newMessages ?? this.newMessages,
        offerUpdates: offerUpdates ?? this.offerUpdates,
        pickupReminder: pickupReminder ?? this.pickupReminder,
        nearbyFood: nearbyFood ?? this.nearbyFood,
        quietHours: quietHours ?? this.quietHours,
        quietFrom: quietFrom ?? this.quietFrom,
        quietTo: quietTo ?? this.quietTo,
        radiusMeters: radiusMeters ?? this.radiusMeters,
        themeMode: themeMode ?? this.themeMode,
        fontScale: fontScale ?? this.fontScale,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        dataSaver: dataSaver ?? this.dataSaver,
      );
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final prefs = ref.watch(preferencesProvider);
    final themeStr = prefs?.getString('theme_mode');
    final themeMode = switch (themeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final fontScale = prefs?.getDouble('font_scale') ?? 1.0;
    final reducedMotion = prefs?.getBool('reduced_motion') ?? false;
    final dataSaver = prefs?.getBool('data_saver') ?? false;

    return AppSettings(
      themeMode: themeMode,
      fontScale: fontScale,
      reducedMotion: reducedMotion,
      dataSaver: dataSaver,
    );
  }

  void update(AppSettings Function(AppSettings s) f) => state = f(state);

  /// "Radius default" also applies to Beranda and Peta right away.
  void setRadius(double meters) {
    state = state.copyWith(radiusMeters: meters);
    ref.read(radiusMetersProvider.notifier).state = meters;
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    ref.read(preferencesProvider)?.setString('theme_mode', mode.name);
  }

  void setFontScale(double scale) {
    state = state.copyWith(fontScale: scale);
    ref.read(preferencesProvider)?.setDouble('font_scale', scale);
  }

  void setReducedMotion(bool value) {
    state = state.copyWith(reducedMotion: value);
    ref.read(preferencesProvider)?.setBool('reduced_motion', value);
  }

  void setDataSaver(bool value) {
    state = state.copyWith(dataSaver: value);
    ref.read(preferencesProvider)?.setBool('data_saver', value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

/// `500 m`, `1 km`, `2 km`.
String formatRadius(double m) => m < 1000 ? '${m.round()} m' : '${(m / 1000).toStringAsFixed(m % 1000 == 0 ? 0 : 1).replaceAll('.', ',')} km';

/// `22.00`
String formatTimeOfDay(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')}';
