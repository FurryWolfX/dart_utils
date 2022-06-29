# Dart utils for self use

为了避免和pub仓库上的重名，包名已重命名 `dart_utils` -> `wolfx_dart_utils`

## Map 工具

```dart
import 'package:wolfx_dart_utils/wolfx_dart_utils.dart';
void main() {
  var json = {
    'a': 'aaa',
    'b': {'c': 'ccc', 'f': null},
    'd': null
  };
  /// 浅克隆一个Map
  var newMap = MapUtils.clone(json);
  /// 深克隆一个Map
  var newMapDeep = MapUtils.cloneDeep(json);
  /// 通过path获取Map中的值
  var value = MapUtils.getValue(json, 'b.c'); // 'ccc'
  /// 通过path设置Map中的值
  var value = MapUtils.setValue(json, 'b.c', 'ccc2');
  /// 通过path移除Map中的Key
  var result = MapUtils.removeKey(json, 'b.c');
  logInfo(result); // {a: aaa, b: {f: null}, d: null}
  /// 移除Map中所有值为null的键
  var result2 = MapUtils.removeNulls(json);
  logInfo(result2); // {a: aaa, b: {c: ccc}}
}
```

## List 工具

```dart
import 'package:wolfx_dart_utils/wolfx_dart_utils.dart';
void main() {
  var list = ['a', 'b', 'c'];
  /// 补充find方法，找到后中断循环，比通过filter来找更高效
  /// 找出List中使得callback返回true的第一个值
  var result3 = ListUtils.find(list, (item) => item == 'b');
  logInfo(result3); // b
  /// 补充filter方法，和dartx库中不同的是，默认返回List而非Iterable
  /// 过滤出List中使得callback返回true的值
  var result4 = ListUtils.filter(list, (item) => item == 'b');
  logInfo(result4); // ['b']
  /// 找出List中使得callback返回true的第一个值的下标
  /// 如果没找到，返回-1
  var result5 = ListUtils.findIndex(list, (item) => item == 'b');
  logInfo(result5); // 1
}
```

## 路径工具

```dart
import 'package:wolfx_dart_utils/wolfx_dart_utils.dart';
void main() {
  // 将win风格的路径转换成posix风格，并通过normalize简化路径
  PathUtils.winPathToPosix('c:\\dir\\.\\file'); // c:/dir/file
}
```

## 文件工具

拷贝文件，保留lastModified时间

```dart
import 'package:wolfx_dart_utils/wolfx_dart_utils.dart';
void main() {
  // 拷贝文件，并保留lastModified时间
  FileUtils.copyFileSync('c:/file.txt', 'd:/file.txt');
  // 差量同步两个文件夹，以sourceDir为准
  FileUtils.syncDirTo('c:/dir', 'd:/dir');
}
```

## 其他

默认不包含在 `wolfx_dart_utils.dart` 使用前请引用 `plugins` 下的文件。

### 计算文本相似度



```dart
import 'package:wolfx_dart_utils/plugins/text_compare.dart';

void main() {
  /// 余弦相似度用向量空间中两个向量夹角的余弦值作为衡量两个个体差异的大小。
  /// 余弦值越接近1，就表明夹角越接近0度，也就是两个向量越相似，这就是余弦相似性。
  double c = getTextSimilarity('ab', 'b');
  print(c); // 0.7071067811865475
  /// 计算文本相似度(集合法)
  double c2 = getTextBalance('ab', 'b');
  print(c2); // 0.5
}
```

### 赋予 loggy 写文件能力

赋予 `loggy` 写文件的能力，需要配合 `loggy` 使用

```dart
import 'package:loggy/loggy.dart';
import 'package:wolfx_dart_utils/plugins/loggy_file_output_printer.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: LoggyFileOutputPrinter(filePath: 'log.log'),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.off,
    ),
  );
}
```