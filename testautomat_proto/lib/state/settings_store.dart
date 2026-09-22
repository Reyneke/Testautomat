import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/state/app_state.dart';

/// Gemerkte Einstellungen des Automaten (E-20).
///
/// Nur Darstellungsmodus und Sprache - mehr wird nicht gemerkt, damit die
/// Ablage uebersichtlich bleibt und keine persoenlichen Daten entstehen.
@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.locale = AppLocale.fallbackLocale,
  });

  /// Gemerkter Darstellungsmodus (Standard: Dunkel, E-07).
  final ThemeMode themeMode;

  /// Gemerkte Sprache (Standard: Deutsch, E-06).
  final Locale locale;

  /// Abbildung fuer die Ablage als JSON.
  Map<String, Object?> toJson() => {
    'themeMode': themeMode.name,
    'language': locale.languageCode,
  };

  /// Liest die Ablage; unbekannte Werte fallen auf die Standardwerte zurueck.
  static AppSettings fromJson(Map<String, Object?> json) {
    final modus = ThemeMode.values.firstWhere(
      (eintrag) => eintrag.name == json['themeMode'],
      orElse: () => ThemeMode.dark,
    );
    final sprache = Locale(json['language'] as String? ?? 'de');
    return AppSettings(
      themeMode: modus,
      locale: AppLocale.unterstuetzt(sprache)
          ? sprache
          : AppLocale.fallbackLocale,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.themeMode == themeMode &&
      other.locale == locale;

  @override
  int get hashCode => Object.hash(themeMode, locale);
}

/// Merkt Darstellungsmodus und Sprache ueber einen Neustart hinweg (E-20).
///
/// Die Ablage liegt als `settings.json` im App-Support-Verzeichnis des Geraets.
/// Im Web gibt es kein solches Verzeichnis: dort ist das Merken bewusst
/// wirkungslos (Session-Verhalten), die App laeuft trotzdem unveraendert.
/// Fuer Tests laesst sich das Verzeichnis ueber den Konstruktor ersetzen.
class SettingsStore {
  SettingsStore({
    Future<Directory> Function()? verzeichnis,
    this.dateiname = 'settings.json',
  }) : _verzeichnis = verzeichnis ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _verzeichnis;

  /// Name der Ablagedatei.
  final String dateiname;

  /// Letzter Schreibauftrag; Tests koennen darauf warten.
  @visibleForTesting
  Future<void>? letzterAuftrag;

  final List<void Function()> _zuhoerer = [];

  File? _datei;

  Future<File?> _ablage() async {
    if (kIsWeb) {
      return null;
    }
    if (_datei != null) {
      return _datei;
    }
    final ordner = await _verzeichnis();
    await ordner.create(recursive: true);
    _datei = File('${ordner.path}${Platform.pathSeparator}$dateiname');
    return _datei;
  }

  /// Liest die gemerkten Einstellungen; `null`, wenn nichts gemerkt ist.
  Future<AppSettings?> lade() async {
    try {
      final datei = await _ablage();
      if (datei == null || !datei.existsSync()) {
        return null;
      }
      final inhalt = jsonDecode(await datei.readAsString());
      if (inhalt is! Map<String, Object?>) {
        return null;
      }
      return AppSettings.fromJson(inhalt);
    } on Object {
      // Eine unlesbare Ablage darf den Start nicht verhindern (E-20).
      return null;
    }
  }

  /// Schreibt die Einstellungen in die Ablage.
  Future<void> speichere(AppSettings einstellungen) async {
    try {
      final datei = await _ablage();
      if (datei == null) {
        return;
      }
      await datei.writeAsString(jsonEncode(einstellungen.toJson()));
    } on Object {
      // Schlaegt das Schreiben fehl, laeuft die App mit den aktuellen Werten
      // weiter - nur das Merken entfaellt.
    }
  }

  /// Verfolgt Aenderungen am Zustand und merkt sie (E-20).
  void binde(AppState zustand) {
    void merken() {
      final einstellungen = AppSettings(
        themeMode: zustand.themeMode.value,
        locale: zustand.locale.value,
      );
      letzterAuftrag = speichere(einstellungen);
    }

    zustand.themeMode.addListener(merken);
    zustand.locale.addListener(merken);
    _zuhoerer
      ..add(() => zustand.themeMode.removeListener(merken))
      ..add(() => zustand.locale.removeListener(merken));
  }

  /// Loest die Zuhoerer wieder (Tests, Lebenszyklus).
  void loese() {
    for (final entfernen in _zuhoerer) {
      entfernen();
    }
    _zuhoerer.clear();
  }
}
