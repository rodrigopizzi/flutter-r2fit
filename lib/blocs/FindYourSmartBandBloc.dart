import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:r2fit/blocs/HPlustProtocol.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindYourSmartBandBloc implements BlocBase {
  FindYourSmartBandBloc();

  FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<BluetoothDeviceState> _deviceConnection;
  StreamSubscription _scanSubscription;

  var _devicesController = BehaviorSubject<SmartBandResult>(seedValue: null);
  Stream<SmartBandResult> get outDevices => _devicesController.stream;
  Sink<SmartBandResult> get inDevices => _devicesController.sink;

  scanDevices() {
    _deviceConnection?.cancel();

    final SmartBandResult result = new SmartBandResult();
    inDevices.add(result);

    _scanSubscription = _flutterBlue
        .scan(timeout: const Duration(seconds: 5))
        .listen((scanResult) {
      SmartBandDevice dev = new SmartBandDevice();
      dev.id = scanResult.device.id;
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
    _deviceConnection.cancel();
  }

  void connectDevice(SmartBandDevice sbDevice) {
    _deviceConnection?.cancel();

    BluetoothDevice device = BluetoothDevice(id: sbDevice.id);

    _deviceConnection = _flutterBlue
        .connect(device, timeout: Duration(seconds: 30), autoConnect: true)
        .listen((BluetoothDeviceState s) {
      if (s == BluetoothDeviceState.connected) {
        HPlusProtocol protocol = new HPlusProtocol(device);
        protocol.syncAll();
      }
    });

    _deviceConnection.onDone(() {
      print('Done conectado');
    });
  }
}

class SmartBandResult {
  bool finish = false;
  Map<DeviceIdentifier, SmartBandDevice> devices =
      Map<DeviceIdentifier, SmartBandDevice>();
}

class SmartBandDevice {
  String localName;
  Map<int, List<int>> manufacturerData;
  Map<String, List<int>> serviceData;
  DeviceIdentifier id;
}
