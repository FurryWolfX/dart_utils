import 'package:path/path.dart';

class PathUtils {
  /// 将win风格的路径转换成posix风格，并通过normalize简化路径
  static String winPathToPosix(String path) {
    Context ctx = Context(style: Style.posix);
    return ctx.normalize(path.replaceAll('\\', '/'));
  }
}
