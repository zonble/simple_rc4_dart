# simple_rc4

[![Actions Status](https://github.com/zonble/simple_rc4_dart/workflows/Dart%20CI/badge.svg)](https://github.com/zonble/simple_rc4_dart/actions)

RC4 cryptor that encodes/decodes bytes and UTF8 strings.

Credit to https://github.com/zonble the original creator of this library.

The only difference: this handels mal formed list in decoding, by adding a default parameter {[bool](https://api.dart.dev/be/181224/dart-core/bool-class.html)? allowMalformed} to the decoding function that allows mal formed List to prevent FormatException: Unexpected extension byte...

## Usage

The package provides a simple class, [RC4], just create an instance of it with
your key, and then pass your data that you want to do encoding/decoding.

A simple usage example:

```dart
import 'package:simple_rc4/simple_rc4.dart';

main() {
  RC4 rc4 = new RC4('zonble');
  String input = '中文';
  var bytes = rc4.encodeBytes(utf8.encode(input));
  print(bytes);
}
```

That's all! Enjoy!
