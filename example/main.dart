import 'dart:convert';

import 'package:simple_rc4/simple_rc4.dart';

void main() {
  var rc4 = RC4('zonble');
  var input = '中文';
  var bytes = rc4.encodeBytes(utf8.encode(input));
  rc4 = RC4('zonble');
  var output = rc4.decodeBytes(bytes);
  print(output);
}
