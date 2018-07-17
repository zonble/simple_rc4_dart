import 'dart:convert';

class RC4 {
  String _key;
  List<int> _box;
  int i = 0, j = 0;

  RC4(String this._key) {
    this._makeBox();
  }

  void _makeBox() {
    int x = 0;
    List<int> box = new List.generate(256, (i) => i);
    for (int i = 0; i < 256; i++) {
      x = (x + box[i] + this._key.codeUnitAt(i % this._key.length)) % 256;
      _swap(box, i, x);
    }
    this._box = box;
  }

  _swap(List<int> S, int i, int j) {
    var tmp = S[i];
    S[i] = S[j];
    S[j] = tmp;
  }

  List<int> _crypt(List<int> message) {
    List<int> out = <int>[];

    for (int char in message) {
      this.i = (this.i + 1) % 256;
      this.j = (this.j + _box[this.i]) % 256;
      _swap(this._box, this.i, this.j);
      int c = char ^ (_box[(_box[this.i] + _box[this.j]) % 256]);
      out.add(c);
    }
    return out;
  }

  List<int> encodeBytes(List<int> bytes) {
    List<int> crypted = _crypt(bytes);
    return crypted;
  }

  String decodeBytes(List<int> bytes) {
    List<int> crypted = _crypt(bytes);
    return utf8.decode(crypted);
  }

  String encodeString(String message, [bool encodeBase64 = true]) {
    List<int> crypted = _crypt(utf8.encode(message));

    if (encodeBase64) {
      String string = base64.encode(crypted);
      return string;
    }
    return utf8.decode(crypted);
  }

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
