import 'dart:convert';

/// A simple RC4 encryptor.
///
/// To use the class, just create an instance of it, and then call methods such
/// as [RC4.encodeBytes], [RC4.decodeBytes] and so on.
class RC4 {
  /// The key.
  List<int> get key => _key;
  late List<int> _key;
  late List<int> _box;
  int _i = 0, _j = 0;

  /// Creates a new instance by passing a given [key].
  RC4(String key) {
    _key = utf8.encode(key);
    _makeBox();
  }

  /// Creates a new instance by passing a given [key].
  RC4.fromBytes(List<int> key) {
    _key = key;
    _makeBox();
  }

  void _makeBox() {
    var x = 0;
    var box = List.generate(256, (i) => i);
    for (var i = 0; i < 256; i++) {
      x = (x + box[i] + _key[i % _key.length]) % 256;
      _swap(box, i, x);
    }
    _box = box;
  }

  void _swap(List<int> list, int i, int j) {
    var tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }

  List<int> _crypt(List<int> message) {
    var out = <int>[];

    for (var char in message) {
      _i = (_i + 1) % 256;
      _j = (_j + _box[_i]) % 256;
      _swap(_box, _i, _j);
      final c = char ^ (_box[(_box[_i] + _box[_j]) % 256]);
      out.add(c);
    }
    return out;
  }

  /// Encodes bytes via RC4 encryption.
  ///
  /// However, actually calling [RC4.encodeBytes] and [RC4.decodeBytes] will
  /// give the same result.
  List<int> encodeBytes(List<int> bytes) => _crypt(bytes);

  /// Decodes bytes via RC4 encryption.
  ///
  /// However, actually calling [RC4.encodeBytes] and [RC4.decodeBytes] will
  /// give the same result.
  String decodeBytes(List<int> bytes, [bool allowMalformed = false]) =>
      utf8.decode(_crypt(bytes), allowMalformed: allowMalformed);

  /// Encodes a string into another string via RC4 encryption.
  ///
  /// Please note that the method uses UTF-8 text encoding when converting
  /// strings to binary data. If you want to use another string encoding, please
  /// convert your string into bytes using your own encoding and pass your data
  /// to [RC4.encodeBytes].
  ///
  /// [encodeBase64] represents if the result should be base64 encoded.
  String encodeString(String message, [bool encodeBase64 = true]) {
    var crypted = _crypt(utf8.encode(message));
    return encodeBase64 ? base64.encode(crypted) : utf8.decode(crypted);
  }

  /// Decodes a string into the original one via RC4 encryption.
  ///
  /// Please note that the method uses UTF-8 text encoding when converting
  /// strings to binary data. If you want to use another string encoding, please
  /// convert your string into bytes using your own encoding and pass your data
  /// to [RC4.decodeBytes].
  ///
  /// [encodeBase64] represents if the input is base64 encoded.
  String decodeString(String message,
      [bool encodedBase64 = true, allowMalformed = false]) {
    if (encodedBase64) {
      var bytes = base64.decode(message);
      var crypted = _crypt(bytes);
      return utf8.decode(crypted, allowMalformed: allowMalformed);
    }

    var decrypted = _crypt(utf8.encode(message));
    return utf8.decode(decrypted, allowMalformed: allowMalformed);
  }
}
