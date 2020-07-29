import 'package:firebase_database/firebase_database.dart';

class Notes {
  String id;
  String _no;
  String _baslik;
  String _icerik;
  String _etiket;
  String _youtube;
  String _resim;
  String _sayfa;
  String _pdf;

  Notes(this._no, this._baslik, this._icerik, this._etiket, this._youtube,
      this._resim, this._sayfa, this._pdf,
      {this.id});

  Notes.map(dynamic, nesne) {
    this._no = nesne['no'];
    this._baslik = nesne['baslik'];
    this._icerik = nesne['icerik'];
    this._etiket = nesne['etiket'];
    this._youtube = nesne['youtube'];
    this._resim = nesne['resim'];
    this._sayfa = nesne['sayfa'];
    this._pdf = nesne['pdf'];
  }

  String get no => _no;
  String get baslik => _baslik;
  String get icerik => _icerik;
  String get etiket => _etiket;
  String get youtube => _youtube;
  String get resim => _resim;
  String get sayfa => _sayfa;
  String get pdf => _pdf;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['no'] = _no;
    map['baslik'] = _baslik;
    map['icerik'] = _icerik;
    map['etiket'] = _etiket;
    map['youtube'] = _youtube;
    map['resim'] = _resim;
    map['sayfa'] = _sayfa;
    map['pdf'] = _pdf;
    return map;
  }

  Notes.fromDataSnapShot(DataSnapshot gelen) {
    id = gelen.key;
    _no = gelen.value['no'];
    _baslik = gelen.value['baslik'];
    _icerik = gelen.value['icerik'];
    _etiket = gelen.value['etiket'];
    _youtube = gelen.value['youtube'];
    _resim = gelen.value['resim'];
    _sayfa = gelen.value['sayfa'];
    _pdf = gelen.value['pdf'];
  }

  toJson() {
    return {
      "no": no,
      "baslik": baslik,
      "icerik": icerik,
      "etiket": etiket,
      "youtube": youtube,
      "resim": resim,
      "sayfa": sayfa,
      "pdf": pdf,
    };
  }
}
