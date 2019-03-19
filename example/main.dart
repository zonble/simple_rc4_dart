import 'dart:convert';
import 'package:simple_rc4/simple_rc4.dart';

main() {
  RC4 rc4 = new RC4('zonble');
  String input = '中文';
  var bytes = rc4.encodeBytes(utf8.encode(input));
  rc4 = new RC4('zonble');
  var output = rc4.decodeBytes(bytes);
  print(output);
}
