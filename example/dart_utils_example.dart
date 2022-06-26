import 'dart:io';

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

  var list = ['a', 'b', 'c'];
  var result3 = ListUtils.find(list, (item) => item == 'b');
  logInfo(result3); // b
  var result4 = ListUtils.filter(list, (item) => item == 'b');
  logInfo(result4); // ['b']
  var result5 = ListUtils.findIndex(list, (item) => item == 'b');
  logInfo(result5); // 1
}
