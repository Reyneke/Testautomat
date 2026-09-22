import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/screens/debug_pin_dialog.dart';
import 'package:testautomat_proto/state/app_debug.dart';

/// Verborgener Zugang zum Debug-Bildschirm (E-22, F-15).
///
/// Mehrere Taps auf den umgebenden Bereich oeffnen den PIN-Dialog; erst danach
/// ist der Debug-Bildschirm erreichbar. Beim Verlassen wird wieder gesperrt.
class DebugTrigger extends StatefulWidget {
  const DebugTrigger({super.key, required this.child});

  /// Der Bereich, der die Geste aufnimmt (Debug-Angaben der Fusszeile).
  final Widget child;

  @override
  State<DebugTrigger> createState() => _DebugTriggerState();
}

class _DebugTriggerState extends State<DebugTrigger> {
  int _taps = 0;

  Future<void> _registriereTap() async {
    _taps += 1;
    if (_taps < AppDebug.tapsBisLogin) {
      return;
    }
    _taps = 0;

    final zustand = AppScope.of(context).zustand;
    final angemeldet = await showDialog<bool>(
      context: context,
      builder: (context) => const DebugPinDialog(),
    );
    if (angemeldet != true || !mounted) {
      return;
    }

    await Navigator.of(context).pushNamed(AppRoutes.debug);
    // Nach dem Verlassen ist der Zugang wieder gesperrt (E-22: verborgen).
    zustand.debugAbmelden();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _registriereTap,
      child: widget.child,
    );
  }
}
