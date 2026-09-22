// Semantik-Labels und Fokusreihenfolge (E-25, E-45).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_test_helpers.dart';

/// Liefert den ersten Text im Teilbaum des aktuell fokussierten Widgets.
String? fokussierterText() {
  final context = FocusManager.instance.primaryFocus?.context;
  if (context is! Element) {
    return null;
  }
  String? gefunden;
  void besuchen(Element element) {
    if (gefunden != null) {
      return;
    }
    final widget = element.widget;
    if (widget is Text) {
      gefunden = widget.data;
      return;
    }
    element.visitChildren(besuchen);
  }

  besuchen(context);
  return gefunden;
}

void main() {
  testWidgets('Semantik-Labels fuer Logo, Selektoren und Knoepfe', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpeApp(tester);

    // Das Logo traegt den App-Titel als Label.
    expect(find.bySemanticsLabel('Parkautomat Weiden'), findsWidgets);
    // Die Selektoren nutzen ihre Tooltips als Semantik-Label (E-09).
    expect(find.byTooltip('Hell'), findsOneWidget);
    expect(find.byTooltip('Dunkel'), findsOneWidget);
    expect(find.byTooltip('System'), findsOneWidget);
    expect(find.byTooltip('Deutsch'), findsOneWidget);
    expect(find.byTooltip('Englisch'), findsOneWidget);
    // Der Startknopf ist beschriftet.
    final knopf = tester.getSemantics(
      find.widgetWithText(FilledButton, 'Verkauf starten'),
    );
    expect(knopf.label, contains('Verkauf starten'));

    handle.dispose();
    await beendeApp(tester);
  });

  testWidgets('Tabulator erreicht Startknopf und Sprachauswahl', (
    tester,
  ) async {
    await pumpeApp(tester);

    final erreicht = <String>{};
    for (var schritt = 0; schritt < 14; schritt++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      final text = fokussierterText();
      if (text != null) {
        erreicht.add(text);
      }
    }

    expect(erreicht, contains('Verkauf starten'));
    expect(erreicht, contains('Deutsch'));
    expect(erreicht, contains('English'));

    await beendeApp(tester);
  });
}
