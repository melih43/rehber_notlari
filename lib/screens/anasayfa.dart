import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rehber_notlari/algolia/arama_baslik.dart';
import 'package:rehber_notlari/data/notes.dart';
import 'package:rehber_notlari/screens/notIcerik.dart';
import 'package:rehber_notlari/services/fbAssistant.dart';
import 'package:rehber_notlari/widgets/notCard.dart';

class Anasayfa extends StatefulWidget {
  static const String id = "Anasayfa";
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  FbAssistant fbaseAssistant = FbAssistant();
  List<Notes> _noteList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onAdded;
  StreamSubscription<Event> _onChanged;
  Query _notesQuery;

  @override
  void initState() {
    super.initState();
    fbaseAssistant = FbAssistant();
    fbaseAssistant.initState();

    _noteList = List();
    _notesQuery = _database.reference().child("notlar").equalTo(widget.key);
    _onAdded = _notesQuery.onChildAdded.listen(_onEntryAdded);
    _onChanged = _notesQuery.onChildChanged.listen(_onEntryChanged);
  }

  listeYenile() {
    fbaseAssistant.NotGetir().then((gelen) {
      _noteList = gelen;
    });
  }

  @override
  void dispose() {
    _onAdded.cancel();
    _onChanged.cancel();
    super.dispose();
  }

  _onEntryAdded(Event event) {
    setState(() {
      _noteList.add(Notes.fromDataSnapShot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var oldEntry = _noteList.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });

    setState(() {
      _noteList[_noteList.indexOf(oldEntry)] =
          Notes.fromDataSnapShot(event.snapshot);
    });
  }

  _NotEkle() {
    fbaseAssistant.notKaydet(Notes("no", "baslik", "icerik", "etiket",
        "youtube", "resim", "sayfa", "pdf"));
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler boyut = ScreenScaler()..init(context);
    int sayi = 0;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        body: Container(
          height: boyut.getHeight(100),
          width: boyut.getWidth(100),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: boyut.getHeight(5),
                    left: boyut.getWidth(2),
                    right: boyut.getWidth(2),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: boyut.getTextSize(15),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BaslikAra()));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.exit_to_app,
                              size: boyut.getTextSize(15),
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _onBackPressed();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40, top: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: FlatButton(
                              onPressed: () {
                                sayi++;

                                if (sayi == 5) {
                                  _NotEkle();
                                  sayi = 0;
                                }
                              },
                              child: AutoSizeText.rich(
                                TextSpan(
                                  text: 'Rehber Notları',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 25, color: Colors.black),
                                ),
                                minFontSize: 0,
                                stepGranularity: 0.1,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Container(
                  height: boyut.getHeight(100),
                  width: boyut.getWidth(100),
                  padding: EdgeInsets.symmetric(
                    horizontal: boyut.getWidth(1),
                    vertical: boyut.getHeight(1),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Liste(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Liste() {
    if (_noteList.length > 0) {
      return FirebaseAnimatedList(
        shrinkWrap: true,
        query: fbaseAssistant.NotGetir(),
        sort: (k, l) {
          k.value["no"].toString().compareTo(l.value["baslik"].toString());
        },
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation animation, int index) {
          final Notes note = Notes.fromDataSnapShot(snapshot);
          return NotCard(
            no: note.no,
            baslik: note.baslik,
            altbaslik: note.etiket,
            pdf: Visibility(
              visible: note.pdf == "pdf" ? false : true,
              child: Icon(
                FontAwesomeIcons.filePdf,
                color: Colors.red,
              ),
            ),
            youtube: Visibility(
              visible: note.youtube == "youtube" ? false : true,
              child: Icon(
                FontAwesomeIcons.youtube,
                color: Colors.redAccent,
              ),
            ),
            resim: Visibility(
              visible: note.resim == "resim" ? false : true,
              child: Icon(
                FontAwesomeIcons.image,
                color: Colors.teal,
              ),
            ),
            sayfa: Visibility(
              visible: note.sayfa == "sayfa" ? false : true,
              child: Icon(
                FontAwesomeIcons.link,
                color: Colors.blue,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotIcerik(note)));
            },
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Emin misiniz?'),
              content: Text('Çıkmak İstiyor musunuz?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Hayır'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Evet'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }
}
