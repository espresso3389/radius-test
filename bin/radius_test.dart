import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:udp/udp.dart';

void main(List<String> arguments) async {
  final udp = await UDP.bind(Endpoint.any());
  udp.asStream().listen((datagram) {
    if (datagram == null) return;
    final data = ascii.decode(datagram.data).trim().split('\r');
    print('count: ${data.length}');
    print(data.join(','));
  });
  final dest = Endpoint.unicast(InternetAddress.tryParse('192.168.10.161')!,
      port: Port(48631));

  //await udp.send(ascii.encode('CMV Get 0.1.CPGain.{I1O1:I1O99}\r'), dest);
  await udp.send(ascii.encode('CMV Get 0.1.CPGain.{I1O1:I10O30}\r'), dest);

  final finish = Completer<int>();
  final sub = stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) async {
    if (line.isEmpty) {
      finish.complete(1);
      print('Quit');
      return;
    }
    print('C: $line');
    await udp.send(ascii.encode('$line\r'), dest);
  });
  await finish.future;
  sub.cancel();
}
