import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Loest im Browser einen Download des Parkscheins aus.
///
/// Die Bytes werden als `Blob` verpackt, ueber eine Objekt-URL an einen
/// kurzlebigen Anker gehaengt und nach dem Klick wieder freigegeben.
Future<String> speichereParkschein(Uint8List bytes, String dateiname) async {
  final blob = web.Blob(
    <JSAny>[bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);
  final anker = web.document.createElement('a') as web.HTMLAnchorElement;
  anker
    ..href = url
    ..download = dateiname
    ..click();
  web.URL.revokeObjectURL(url);
  return dateiname;
}
