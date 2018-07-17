# simple_rc4

Yet another RC4 encryptor.

## Usage

A simple usage example:

``` dart
import 'package:simple_rc4/simple_rc4.dart';

main() {
  RC4 rc4 = new RC4('zonble');
  String input = '中文';
  var bytes = rc4.encodeBytes(utf8.encode(input));
}
```
