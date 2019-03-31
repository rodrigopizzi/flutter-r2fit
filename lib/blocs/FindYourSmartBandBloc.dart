import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindYourSmartBandBloc implements BlocBase {
  FindYourSmartBandBloc();

  StreamSubscription _scanSubscription;

  var _devicesController = BehaviorSubject<SmartBandResult>(seedValue: null);
  Stream<SmartBandResult> get outDevices => _devicesController.stream;
  Sink<SmartBandResult> get inDevices => _devicesController.sink;

  scanDevices() {
    final SmartBandResult result = new SmartBandResult();
    inDevices.add(result);

    FlutterBlue flutterBlue = FlutterBlue.instance;

    _scanSubscription = flutterBlue
        .scan(timeout: const Duration(seconds: 5))
        .listen((scanResult) {

      SmartBandDevice dev = new SmartBandDevice();
      dev.device = scanResult.device;
      dev.localName = scanResult.advertisementData.localName;
      dev.manufacturerData = scanResult.advertisementData.manufacturerData;
      dev.serviceData = scanResult.advertisementData.serviceData;

      if (dev.localName.length > 0) {
        result.devices[scanResult.device.id] = dev;
      }

    });

    _scanSubscription.onDone(() {
      result.finish = true;
      inDevices.add(result);
    });

  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    _devicesController.close();
  }
}

class SmartBandResult {
  bool finish = false;
  Map<DeviceIdentifier, SmartBandDevice> devices = Map<DeviceIdentifier,SmartBandDevice>();
}

class SmartBandDevice {
  BluetoothDevice device;
  String localName;
  Map<int, List<int>> manufacturerData;
  Map<String, List<int>> serviceData;
}
