import 'dart:convert';
import 'dart:io';
import 'package:loggy/loggy.dart';

/// 赋予loggy写文件的能力，需要配合loggy使用
class LoggyFileOutputPrinter extends LoggyPrinter {
  LoggyFileOutputPrinter({required String filePath}) : super() {
    File file = File(filePath);
    file.create(recursive: true);
    _sink = file.openWrite(
      mode: FileMode.writeOnlyAppend,
      encoding: utf8,
    );
  }

  IOSink? _sink;

  @override
  void onLog(LogRecord record) async {
    _sink?.writeln(record.toString());
    print(record);
  }
}
