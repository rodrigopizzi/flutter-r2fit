import 'package:flutter_blue/flutter_blue.dart';

class HPlusProtocol {
  List<BluetoothService> _services = new List();
  BluetoothDevice _device;

  HPlusProtocol(BluetoothDevice device) {
    _device = device;
  }

  void syncAll() async {
    Future<List<BluetoothService>> discoverServices =
        _device.discoverServices();

    discoverServices.then((result){
      result.forEach((s){
        print(s.uuid.toString());
        if (s.uuid == Guid('14701820-620a-3973-7c78-9cfff0876abd')) {
          _services.add(s);
        }
      });
    });

    discoverServices.whenComplete(() {
      print('Discovery Completo');
      _nextService();
    });
  }

  void _nextService() {
    if (_services.length == 0) return;

    BluetoothService service = _services.removeAt(0);

    _nextCharacteristic(service.characteristics);
  }

  void _nextCharacteristic(List<BluetoothCharacteristic> characteristics) {
    if (characteristics.length == 0) {
      _nextService();
      return;
    }

    BluetoothCharacteristic characteristic = characteristics.removeAt(0);
    characteristics.forEach((c){
      print(c.uuid.toString());
    });

    _device.readCharacteristic(characteristic).then((result) {
      print('BluetoothCharacteristic UUID: ' +
          characteristic.uuid.toString() +
          ' Value: ' +
          result.toString());
    }).whenComplete(() {
      _nextCharacteristic(characteristics);
    });
  }
}
