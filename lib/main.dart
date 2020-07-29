import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rehber_notlari/screens/pinScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(new RehberNotlari());
  });
}

class RehberNotlari extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rehber Notları',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: PinScreen(),
    );
  }
}
