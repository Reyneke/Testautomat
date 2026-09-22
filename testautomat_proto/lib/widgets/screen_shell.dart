import 'package:flutter/material.dart';

import 'package:testautomat_proto/widgets/app_footer.dart';
import 'package:testautomat_proto/widgets/app_header.dart';

/// Gemeinsames Layout aller sechs Bildschirme (E-21).
///
/// Kopf- und Fusszeile sind fixiert, der mittlere Bereich gehoert dem jeweiligen
/// Bildschirm und ist scrollbar, damit bei stark vergroesserter Schrift nichts
/// abgeschnitten wird (E-41). Aufbau gemaess `0_Einfuehrung.md`.
class ScreenShell extends StatelessWidget {
  const ScreenShell({super.key, required this.child});

  /// Mittlerer Bereich des Bildschirms.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
