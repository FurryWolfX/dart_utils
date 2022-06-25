import 'package:dartx/dartx.dart';

/// 补充List的一些实用方法
class ListUtils {
  /// 补充filter方法，和dartx库中不同的是，默认返回List而非Iterable
  /// 过滤出List中使得callback返回true的值
  static List<T> filter<T>(List<T> list, bool Function(T item) callback) {
    return list.filter(callback).toList();
  }

  /// 补充find方法，找到后中断循环，比通过filter来找更高效
  /// 找出List中使得callback返回true的第一个值
  static T? find<T>(List<T> list, bool Function(T item) callback) {
    T? result;
    for (final item in list) {
      if (callback(item)) {
        result = item;
        break;
      }
    }
    return result;
  }

  /// 找出List中使得callback返回true的第一个值的下标
  /// 如果没找到，返回-1
  static int findIndex<T>(List<T> list, bool Function(T item) callback) {
    int result = -1;
    for (var i = 0; i < list.length; i++) {
      if (callback(list[i])) {
        result = i;
        break;
      }
    }
    return result;
  }
}
