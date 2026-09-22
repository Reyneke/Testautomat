import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/bootstrap/machine_loader.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/data/repository_factory.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/state/app_state.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    TestAutomatApp(zustand: AppState(), repository: createDefaultRepository()),
  );
}

/// Wurzel-Widget der App.
///
/// Bindet Theme und Sprache an die [MaterialApp], stellt Zustand und Datenlayer
/// ueber den [AppScope] bereit und ueberlaesst den Einstieg dem [MachineLoader]
/// (Laedt die Maschine, E-23/E-55). Siehe `1_Frontendstruktur.md`.
class TestAutomatApp extends StatelessWidget {
  const TestAutomatApp({
    super.key,
    required this.zustand,
    required this.repository,
  });

  /// Globaler Zustand der App - eine Instanz pro App (E-46).
  final AppState zustand;

  /// Datenzugriff (Composition Root, E-04).
  final ParkautomatRepository repository;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      zustand: zustand,
      repository: repository,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: zustand.themeMode,
        builder: (context, themeMode, _) {
          return ValueListenableBuilder<Locale>(
            valueListenable: zustand.locale,
            builder: (context, locale, _) {
              return MaterialApp(
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appTitle,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: AppLocale.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const MachineLoader(),
              );
            },
          );
        },
      ),
    );
  }
}
