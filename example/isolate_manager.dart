import 'package:isolate_manager/isolate_manager.dart';

Future<int> add(dynamic value) async {
  await Future.delayed(Duration(seconds: 1));
  return value[0] + value[1];
}

final isolateManager = IsolateManager.create(
  add, // Function that you want to compute
  numOfIsolates: 4, // Number of concurrent isolates. Default is 1
);

void main() async {
  await isolateManager.start();
  for (var i = 0; i < 10; i++) {
    isolateManager.compute([10, 20]);
  }
  isolateManager.stream.listen((result) => print(result));
}
