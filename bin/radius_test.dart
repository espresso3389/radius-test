import 'dart:convert';
import 'dart:io';
import 'package:udp/udp.dart';

void main(List<String> arguments) async {
  final udp = await UDP.bind(Endpoint.any());
  udp.asStream().listen((datagram) {
    if (datagram == null) return;
    final data = ascii
        .decode(datagram.data)
        .trim()
        .split('\r')
        .map((v) => double.parse(v));
    print('count: ${data.length}');
    print(data.join(','));
  });
  final dest = Endpoint.unicast(InternetAddress.tryParse('192.168.10.161')!,
      port: Port(48631));

  //await udp.send(ascii.encode('CMV Get 0.1.CPGain.{I1O1:I1O99}\r'), dest);
  await udp.send(ascii.encode('CMV Get 0.1.CPGain.{I1O1:I2O99}\r'), dest);
}
