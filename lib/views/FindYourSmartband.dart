import 'package:flutter/material.dart';

class FindYourSmartband extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encontre sua Smartband'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/128/60/60939.png'),
              height: 100,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Image(
              image: NetworkImage(
                  'https://image.flaticon.com/icons/png/128/61/61220.png'),
              height: 100,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              new BoxShadow(
                color: Colors.black45,
                offset: new Offset(0.0, 5.0),
              ),
              new BoxShadow(
                color: Colors.white,
                offset: new Offset(0.0, 0.0),
              )
            ]),
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12, width: 1),
            ),
          ),
          Container(
            child: Image(
              image: NetworkImage(
                  'https://cdn.iconscout.com/icon/free/png-256/smartwatch-479-1141075.png'),
              height: 100,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                border:
                    BorderDirectional(top: BorderSide(color: Colors.black12)),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black12,
                    offset: new Offset(0.0, 0.0),
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      'https://www.shareicon.net/data/256x256/2015/08/16/85912_help_512x512.png'),
                  height: 60,
                ),
                Text(
                  '  Como funciona?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
