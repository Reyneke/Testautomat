import 'package:flutter/material.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/state/app_debug.dart';

/// PIN-Dialog fuer den Debug-Zugang (E-22).
///
/// Liefert `true`, wenn die PIN stimmt und der Debug-Bildschirm geoeffnet
/// werden darf.
class DebugPinDialog extends StatefulWidget {
  const DebugPinDialog({super.key});

  @override
  State<DebugPinDialog> createState() => _DebugPinDialogState();
}

class _DebugPinDialogState extends State<DebugPinDialog> {
  final TextEditingController _eingabe = TextEditingController();
  String? _fehler;

  @override
  void dispose() {
    _eingabe.dispose();
    super.dispose();
  }

  void _bestaetigen() {
    if (AppDebug.pruefePin(_eingabe.text)) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _fehler = AppLocalizations.of(context).debugPinFalsch);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.debugPinTitel),
      content: TextField(
        controller: _eingabe,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: localizations.debugPinFeld,
          errorText: _fehler,
        ),
        onSubmitted: (_) => _bestaetigen(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.debugAbbrechen),
        ),
        FilledButton(
          onPressed: _bestaetigen,
          child: Text(localizations.debugAnmelden),
        ),
      ],
    );
  }
}
