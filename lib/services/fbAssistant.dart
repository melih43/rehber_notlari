import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:rehber_notlari/data/notes.dart';

class FbAssistant {
  DatabaseReference fbreference;
  StreamSubscription<Event> fbStream;
  FirebaseDatabase vt = FirebaseDatabase();
  DatabaseError hata;

  static final FbAssistant _assistant = FbAssistant.icislem();
  FbAssistant.icislem();

  factory FbAssistant() {
    return _assistant;
  }

  void initState() {
    fbreference = vt.reference().child(("notlar"));
    vt.setPersistenceEnabled(true);
    vt.setPersistenceCacheSizeBytes(10000000);
  }

  notKaydet(Notes note) {
    fbreference.push().set(<String, String>{
      'no': note.no,
      'baslik': note.baslik,
      'icerik': note.icerik,
      'etiket': note.etiket,
      'youtube': note.youtube,
      'resim': note.resim,
      'sayfa': note.sayfa,
      'pdf': note.pdf,
    });
  }

  notSil(Notes note) {
    fbreference.child(note.id).remove();
  }

  NotGetir() {
    return fbreference;
  }

  NotAl(Notes note) {
    return fbreference.child(note.id);
  }
}
