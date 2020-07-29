import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'anasayfa.dart';

class PinScreen extends StatefulWidget {
  static const String id = "PinScreen";
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  TextEditingController _pinController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  final _formKey = GlobalKey<FormState>();
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler boyut = ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: boyut.getWidth(100),
          height: boyut.getHeight(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Image.asset("assets/img/logo.png"),
              ),
              Flexible(
                flex: 1,
                child: Lottie.asset("assets/lottie/key.json"),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: boyut.getWidth(5),
                    vertical: boyut.getHeight(5),
                  ),
                  child: AutoSizeText(
                    "Şifre Giriniz!",
                    maxLines: 1,
                    minFontSize: 24,
                    maxFontSize: 34,
                    style: GoogleFonts.lato(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      length: 6,
                      obsecureText: true,
                      animationType: AnimationType.fade,
                      textInputType: TextInputType.phone,
                      pinTheme: PinTheme(
                        selectedFillColor: Colors.amber,
                        inactiveFillColor: Colors.grey.shade400,
                        activeColor: Colors.grey.shade700,
                        inactiveColor: Colors.white,
                        borderWidth: 0,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor: hasError ? Colors.white : Colors.white,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: _pinController,
                      onCompleted: (pin) {
                        if (currentText == "693234") {
                          print("giriş olacak");
                          _pinController.clear();
                          Flushbar(
                            icon: Icon(
                              Icons.check_box,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.amber,
                            titleText: AutoSizeText(
                              'Giriş Başarılı!',
                              maxLines: 1,
                              minFontSize: 12,
                              maxFontSize: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            messageText: AutoSizeText(
                              "Anasayfaya Yönlendiriliyorsunuz!",
                              maxLines: 1,
                              minFontSize: 10,
                              maxFontSize: 14,
                            ),
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context).then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Anasayfa())));
                        } else {
                          _pinController.clear();
                          Flushbar(
                            icon: Icon(
                              Icons.warning,
                              color: Colors.black,
                            ),
                            backgroundColor: Colors.amberAccent,
                            titleText: AutoSizeText(
                              'Pin Kodu Yanlış!',
                              maxLines: 1,
                              minFontSize: 12,
                              maxFontSize: 16,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            messageText: AutoSizeText(
                              "Programı Kullanmak için Lütfen Pin Kodunu Giriniz!",
                              maxLines: 1,
                              minFontSize: 10,
                              maxFontSize: 14,
                            ),
                            isDismissible: true,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                          )..show(context);
                        }
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
