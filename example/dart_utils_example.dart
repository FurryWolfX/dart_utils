import 'package:dart_utils/dart_utils.dart';
import 'package:loggy/loggy.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: LoggyFileOutputPrinter(filePath: 'log.log'),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.off,
    ),
  );

  var json = {
    'a': 'aaa',
    'b': {'c': 'ccc', 'f': null},
    'd': null
  };
  var result = MapUtils.removeKey(json, 'b.c');
  logInfo(result); // {a: aaa, b: {f: null}, d: null}
  var result2 = MapUtils.removeNulls(json);
  logInfo(result2); // {a: aaa, b: {c: ccc}}
}
