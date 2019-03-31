import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:r2fit/blocs/FindYourSmartBandBloc.dart';
import 'package:r2fit/pages/FindYourSmartBandPage.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider<FindYourSmartBandBloc>(
      child: MaterialApp(
        home: FindYourSmartBandPage(),
      ),
      bloc: FindYourSmartBandBloc(),
    );
  }
}
