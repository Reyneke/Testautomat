import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/data/repository_factory.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/screens/start_screen.dart';
import 'package:testautomat_proto/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TestAutomatApp(repository: createDefaultRepository()));
}

/// Wurzel-Widget der App.
///
/// Bindet den globalen Theme- ([AppTheme.themeModeNotifier]) und Sprachzustand
/// ([AppLocale.notifier]) an die [MaterialApp] und stellt das Datenlayer ueber
/// [AppScope] bereit. Siehe `doc/plan/grundlagen/1_Frontendstruktur.md`.
class TestAutomatApp extends StatelessWidget {
  const TestAutomatApp({super.key, required this.repository});

  /// Datenzugriff (Composition Root, E-04): pro App-Instanz genau eine Fassung.
  final ParkautomatRepository repository;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      repository: repository,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppTheme.themeModeNotifier,
        builder: (context, themeMode, _) {
          return ValueListenableBuilder<Locale>(
            valueListenable: AppLocale.notifier,
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
                home: const StartScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
