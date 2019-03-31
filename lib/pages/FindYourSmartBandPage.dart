import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:r2fit/blocs/FindYourSmartBandBloc.dart';

class FindYourSmartBandPage extends StatelessWidget {
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
          new FindDevice(),
          Container(
            child: Image(
              image: NetworkImage(
                  'https://cdn.iconscout.com/icon/free/png-256/smartwatch-479-1141075.png'),
              height: 100,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
          ),
          Expanded(child: new HowItWorks()),
        ],
      ),
    );
  }
}

class HowItWorks extends StatelessWidget {
  const HowItWorks({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: BorderDirectional(top: BorderSide(color: Colors.black12)),
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
          ),
        ],
      ),
    );
  }
}

class FindDevice extends StatelessWidget {
  const FindDevice({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        navigateToScanDevices(context);
      },
      child: Container(
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
    );
  }

  void navigateToScanDevices(BuildContext context) {
    final FindYourSmartBandBloc bloc =
        BlocProvider.of<FindYourSmartBandBloc>(context);

    bloc.scanDevices();

    final biggerFont =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
              appBar: new AppBar(
                title: StreamBuilder(
                    stream: bloc.outDevices,
                    builder: (context, snapshot) {
                      SmartBandResult result = snapshot.data;
                      String text = 'Encontrando dispositivos...';
                      if (result.finish) {
                        text =
                            '${result.devices.values.length} dispositivos encontrados';
                      }

                      return Text(text);
                    }),
              ),
              body: StreamBuilder(
                  stream: bloc.outDevices,
                  builder: (c, s) {
                    SmartBandResult result = s.data;
                    if (result != null && result.finish) {
                      if (result.devices.length == 0) {
                        return Center(
                          child: Text(
                            'Nenhum dispositivo encontrado. \n\nVerifique se o dispositivo esta ligado e no alcance do seu smartphone.',
                            style: biggerFont,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(itemBuilder: (context, i) {
                        if (i.isOdd) return Divider();
                        final index = i ~/ 2; /*3*/
                        if (index >= result.devices.length) {
                          return null;
                        }

                        SmartBandDevice device =
                            result.devices.values.elementAt(index);

                        return ListTile(
                            title: Column(
                          children: <Widget>[
                            Chip(
                                padding: EdgeInsets.all(5.0),
                                label: Text(
                                  device.localName + ' ',
                                  style: biggerFont,
                                )),
                            Text(device.device.id.toString())
                          ],
                        ));
                      });
                    }

                    return Center(
                        child: Text(
                      'Aguarde... \n\nProcurando dispositivos.',
                      style: biggerFont,
                      textAlign: TextAlign.center,
                    ));
                  }));
        },
      ),
    );
  }
}
