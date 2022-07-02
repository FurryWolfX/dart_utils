import 'dart:isolate';

Future<void> _entry(List<dynamic> args) async {
  SendPort p = args[0];
  Function fn = args[1];
  dynamic result = await fn(args.sublist(2));
  Isolate.exit(p, result);
}

Future<T> runIsolate<T>(Future<T> Function(List<dynamic>) fn, List<dynamic> args) async {
  final p = ReceivePort();
  await Isolate.spawn(_entry, [p.sendPort, fn, ...args]);
  return await p.first;
}
