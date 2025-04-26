import 'package:flutter/foundation.dart' show kIsWeb;

import 'web_import_stub.dart'
    if (dart.library.html) 'web_import_web.dart';

void configureApp() {
  if (kIsWeb) {
    importForWeb();
  }
}
