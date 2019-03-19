# simple_rc4

Yet another RC4 cryptor that encodes/decodes bytes and UTF8 strings.

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
