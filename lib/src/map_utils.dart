import 'dart:convert';
import 'package:json_by_path/json_by_path.dart';

/// 补充Map的一些实用方法
class MapUtils {
  /// 深克隆一个Map
  static Map<String, T> cloneDeep<T>(Map<String, T> target) {
    return json.decode(json.encode(target));
  }

  /// 浅克隆一个Map
  static Map<String, T> clone<T>(Map<String, T> target) {
    return {...target};
  }

  /// 通过path获取Map中的值
  static T? getValue<T>(Map<String, dynamic> target, String path, T defaultValue) {
    return JsonByPath().getValue<T>(target, path, defaultValue);
  }

  /// 通过path设置Map中的值
  static Map<String, dynamic> setValue(Map<String, dynamic> target, String path, dynamic val) {
    return JsonByPath().setValue(target, path, val);
  }

  /// 通过path移除Map中的Key
  static Map<String, dynamic> removeKey(Map<String, dynamic> target, String path) {
    var keys = path.split('.');
    var targetClone = MapUtils.cloneDeep(target);
    Map<String, dynamic> obj = targetClone;
    for (var i = 0; i < keys.length - 1; i++) {
      var key = keys[i];
      obj = obj[key];
    }
    obj.remove(keys.last);
    return targetClone;
  }

  /// 移除Map中所有值为null的键
  static Map<String, dynamic> removeNulls(Map<String, dynamic> target, {bool clone = true}) {
    var keys = [...target.keys];
    var targetClone = target;
    if (clone) {
      targetClone = MapUtils.cloneDeep(target);
    }
    for (final key in keys) {
      if (targetClone[key] == null) {
        targetClone.remove(key);
      } else if (targetClone[key] is Map) {
        removeNulls(targetClone[key], clone: false);
      }
    }
    return targetClone;
  }
}
