import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class NotCard extends StatelessWidget {
  String no;
  String baslik;
  String altbaslik;
  Widget youtube;
  Widget resim;
  Widget sayfa;
  Widget pdf;
  Function onTap;

  NotCard({
    this.no,
    @required this.baslik,
    @required this.altbaslik,
    @required this.youtube,
    @required this.resim,
    @required this.sayfa,
    @required this.pdf,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ScreenScaler boyut = ScreenScaler()..init(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: boyut.getHeight(1.5),
            horizontal: boyut.getWidth(1.5),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  height: boyut.getHeight(8),
                  width: boyut.getWidth(8),
                  child: Lottie.asset('assets/lottie/menu1.json'),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      baslik,
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
                      "Kategori: " + altbaslik,
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      minFontSize: 9,
                      maxFontSize: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AutoSizeText(
                          "Sıra No: " + no,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 9,
                          maxFontSize: 12,
                          maxLines: 1,
                        ),
                        Row(
                          children: <Widget>[
                            pdf,
                            SizedBox(
                              width: 20,
                            ),
                            youtube,
                            SizedBox(
                              width: 20,
                            ),
                            resim,
                            SizedBox(
                              width: 20,
                            ),
                            sayfa
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
