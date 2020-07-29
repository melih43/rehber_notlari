import 'package:algolia/algolia.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class BaslikAra extends StatefulWidget {
  @override
  _BaslikAraState createState() => _BaslikAraState();
}

class _BaslikAraState extends State<BaslikAra> {
  GlobalKey _formkey = GlobalKey<FormState>();
  final TextEditingController txtara = TextEditingController();
  static Algolia algolia = Algolia.init(
    applicationId: 'KEOXWTR7VB',
    apiKey: '7a40189aa162b1b4b156219705d8f49a',
  );

  queryFunc() {
    AlgoliaQuery query = algolia.instance.index('baslik').search(txtara.text);
    Future<AlgoliaQuerySnapshot> snap = query.getObjects();
    return snap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('Başlıklarda Ara'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextFormField(
              key: _formkey,
              autofocus: true,
              controller: txtara,
              decoration: InputDecoration(
                hintText: "Başlıkta Ara",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onChanged: (value) {
                setState(() {
                  value = txtara.text;
                });
              },
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder(
                stream: queryFunc().asStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<AlgoliaQuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  final int documentsLength = snapshot.data.hits.length;
                  return new ListView.builder(
                      itemCount: documentsLength,
                      itemBuilder: (context, int index) {
                        final AlgoliaObjectSnapshot document =
                            snapshot.data.hits[index];
                        return Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: Lottie.asset(
                                        'assets/lottie/menu1.json'),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 16,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AutoSizeText(
                                        document.data['baslik'],
                                        style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        minFontSize: 15,
                                        maxFontSize: 20,
                                      ),
                                      Divider(),
                                      AutoSizeText(
                                        "Kategori: " + document.data['etiket'],
                                        style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 9,
                                        maxFontSize: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          AutoSizeText(
                                            "Sıra No: " + document.data['no'],
                                            style: GoogleFonts.lato(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            minFontSize: 9,
                                            maxFontSize: 12,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
