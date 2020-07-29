import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rehber_notlari/data/notes.dart';
import 'package:rehber_notlari/services/fbAssistant.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:sliverbar_with_card/sliverbar_with_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NotIcerik extends StatefulWidget {
  static const String id = "Not İcerik";
  Notes icerik;
  NotIcerik(this.icerik);

  @override
  NotIcerikState createState() => NotIcerikState(icerik);
}

class NotIcerikState extends State<NotIcerik> {
  Notes note;
  NotIcerikState(this.note);
  FbAssistant fbaseAssistant = FbAssistant();
  @override
  Widget build(BuildContext context) {
    ScreenScaler boyut = ScreenScaler()..init(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          return CardSliverAppBar(
            height: boyut.getHeight(30),
            background: Image.asset(
              "assets/img/books.jpg",
              fit: BoxFit.cover,
            ),
            title: Text(
              note.baslik,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            titleDescription: Text(
              "Tag: " + note.etiket + " | " + "Sıra no: ${note.no}",
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            //card: AssetImage("assets/img/notes1.jpg"),
            backButton: true,
            backButtonColors: [Colors.black, Colors.black],
            body: Container(
              alignment: Alignment.topLeft,
              color: Colors.white38,
              width: boyut.getWidth(100),
              height: boyut.getHeight(100),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: note.youtube == "youtube" &&
                            note.resim == "resim" &&
                            note.sayfa == "sayfa" &&
                            note.pdf == "pdf"
                        ? false
                        : true,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AutoSizeText(
                            "Kaynaklar : ",
                            maxLines: 1,
                            minFontSize: 10,
                            maxFontSize: 14,
                            style: GoogleFonts.lato(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          note.pdf != "pdf"
                              ? IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.filePdf,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    print("pdf tıklandı");
                                    _showPDF();
                                  },
                                )
                              : SizedBox(),
                          note.youtube != "youtube"
                              ? IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.youtube,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    print("tıklandı");
                                    _showYoutube();
                                  },
                                )
                              : SizedBox(),
                          note.resim != "resim"
                              ? IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.image,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () {
                                    print("resim tıklandı");
                                    _showImage();
                                  },
                                )
                              : SizedBox(),
                          note.sayfa != "sayfa"
                              ? IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.link,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    print("link tıklandı");
                                    _showURL();
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: note.youtube == "youtube" &&
                              note.resim == "resim" &&
                              note.sayfa == "sayfa"
                          ? false
                          : true,
                      child: Divider()),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: HTML.toRichText(
                            context,
                            note.icerik,
                            defaultTextStyle: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _showYoutube() {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: note.youtube,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          );
        });
  }

  _showImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(note.baslik),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                imageProvider: NetworkImage(
                  note.resim,
                  scale: 2,
                ),
              ),
            ),
          );
        });
  }

  _showURL() async {
    String url = note.sayfa;
    if (await canLaunch(url)) {
      await launch(url);
      print(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showPDF() {
    ScreenScaler boyut = ScreenScaler();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("PDF Okuyucu"),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: boyut.getHeight(100),
                width: boyut.getWidth(100),
                child: PDF.network(
                  note.pdf,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          );
        });
  }
}
