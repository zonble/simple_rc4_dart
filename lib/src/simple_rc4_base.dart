import 'dart:convert';

/// A simple RC4 encryptor.
///
/// To use the class, just create an instance of it, and then call methods such
/// as [RC4.encodeBytes], [RC4.decodeBytes] and so on.
class RC4 {
  final String key;
  List<int> _box;
  int _i = 0, _j = 0;

  /// Creates a new instance by passing a given [key].
  RC4(String this.key) {
    this._makeBox();
  }

  void _makeBox() {
    int x = 0;
    List<int> box = new List.generate(256, (i) => i);
    for (int i = 0; i < 256; i++) {
      x = (x + box[i] + this.key.codeUnitAt(i % this.key.length)) % 256;
      _swap(box, i, x);
    }
    this._box = box;
  }

  _swap(List<int> list, int i, int j) {
    var tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }

  List<int> _crypt(List<int> message) {
    List<int> out = <int>[];

    for (int char in message) {
      this._i = (this._i + 1) % 256;
      this._j = (this._j + _box[this._i]) % 256;
      _swap(this._box, this._i, this._j);
      final int c = char ^ (_box[(_box[this._i] + _box[this._j]) % 256]);
      out.add(c);
    }
    return out;
  }

  /// Encodes bytes via RC4 encryption.
  ///
  /// However, actually calling [RC4.encodeBytes] and [RC4.decodeBytes] will
  /// give the same result.
  List<int> encodeBytes(List<int> bytes) {
    List<int> crypted = _crypt(bytes);
    return crypted;
  }

  /// Decodes bytes via RC4 encryption.
  ///
  /// However, actually calling [RC4.encodeBytes] and [RC4.decodeBytes] will
  /// give the same result.
  String decodeBytes(List<int> bytes) {
    List<int> crypted = _crypt(bytes);
    return utf8.decode(crypted);
  }

  /// Encodes a string into another string via RC4 encryption.
  ///
  /// Please note that the method uses UTF-8 text encoding when converting
  /// strings to binary data. If you want to use another string encoding, please
  /// convert your string into bytes using your own encoding and pass your data
  /// to [RC4.encodeBytes].
  ///
  /// [encodeBase64] represents if the result should be base64 encoded.
  String encodeString(String message, [bool encodeBase64 = true]) {
    List<int> crypted = _crypt(utf8.encode(message));

    if (encodeBase64) {
      String string = base64.encode(crypted);
      return string;
    }
    return utf8.decode(crypted);
  }

  /// Decodes a string into the original one via RC4 encryption.
  ///
  /// Please note that the method uses UTF-8 text encoding when converting
  /// strings to binary data. If you want to use another string encoding, please
  /// convert your string into bytes using your own encoding and pass your data
  /// to [RC4.decodeBytes].
  ///
  /// [encodeBase64] represents if the input is base64 encoded.
  String decodeString(String message, [bool encodedBase64 = true]) {
    if (encodedBase64) {
      List<int> bytes = base64.decode(message).toList();
      List<int> crypted = _crypt(bytes);
      return utf8.decode(crypted);
    }

    List<int> decrypted = _crypt(utf8.encode(message));
    return utf8.decode(decrypted);
  }
}
