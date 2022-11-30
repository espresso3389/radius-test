import 'dart:convert';
import 'dart:io';
import 'package:udp/udp.dart';

void main(List<String> arguments) async {
  final udp = await UDP.bind(Endpoint.any());
  udp.asStream().listen((datagram) {
    if (datagram == null) return;
    print(ascii.decode(datagram.data));
  });
  final dest = Endpoint.unicast(InternetAddress.tryParse('192.168.0.100')!,
      port: Port(48631));

  await udp.send(ascii.encode('CS 2 65535\r'), dest);

  for (int i = 0; i <= 65535; i++) {
    await udp.send(ascii.encode('CS 1 $i\r'), dest);
  }
}
