import 'dart:io';
import 'package:path/path.dart';

import 'path_utils.dart';

class FileUtils {
  /// 拷贝文件，保留lastModified时间
  /// 如果拷贝失败返回null
  static File? copyFileSync({required String source, required String target}) {
    Context ctx = Context(style: Style.posix);
    File file = File(source);
    if (file.existsSync()) {
      String dirPath = ctx.dirname(target);
      Directory dir = Directory(dirPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      // 拷贝时需要保留lastModified
      try {
        File newFile = file.copySync(target);
        newFile.setLastModifiedSync(file.lastModifiedSync());
        return newFile;
      } catch (e) {
        // 不做任何操作
        print('copy file from $source to $target failed');
      }
    }
    return null;
  }

  /// 差量同步两个文件夹，以sourceDir为准
  static void syncDirTo({required Directory sourceDir, required Directory targetDir}) {
    String sourceAbsPathPrefix = PathUtils.winPathToPosix(sourceDir.absolute.path);
    String targetAbsPathPrefix = PathUtils.winPathToPosix(targetDir.absolute.path);
    List<FileSystemEntity> sourceList = sourceDir.listSync(recursive: true);
    List<FileSystemEntity> targetList = targetDir.listSync(recursive: true);
    // 原目录路径和状态的映射
    Map<String, FileStat> sourceStatMap = {};
    // 目标目录路径和状态的映射
    Map<String, FileStat> targetStatMap = {};

    // 创建targetStatMap
    for (final item in targetList) {
      String sourceItemAbsPath = PathUtils.winPathToPosix(item.absolute.path);
      String targetItemAbsPath = sourceItemAbsPath.replaceFirst(sourceAbsPathPrefix, targetAbsPathPrefix);
      targetStatMap[targetItemAbsPath] = item.statSync();
    }

    // 查找原目录中修改或新增的元素
    for (final item in sourceList) {
      String sourceItemAbsPath = PathUtils.winPathToPosix(item.absolute.path);
      String targetItemAbsPath = sourceItemAbsPath.replaceFirst(sourceAbsPathPrefix, targetAbsPathPrefix);
      // 读取原文件状态
      FileStat sourceStat = item.statSync();
      sourceStatMap[sourceItemAbsPath] = sourceStat;
      // 开始对比与目标的状态差异
      if (targetStatMap[targetItemAbsPath] != null) {
        // 如果目标存在，需要对比差异
        // 读取目标文件状态
        FileStat targetStat = targetStatMap[targetItemAbsPath]!;
        // 比较文件大小
        if (sourceStat.modified != targetStat.modified) {
          copyFileSync(source: sourceItemAbsPath, target: targetItemAbsPath);
        }
      } else {
        // 如果目标是空
        if (sourceStat.type == FileSystemEntityType.file) {
          // 拷贝文件
          copyFileSync(source: sourceItemAbsPath, target: targetItemAbsPath);
        } else if (sourceStat.type == FileSystemEntityType.directory) {
          // 创建目录
          Directory dir = Directory(targetItemAbsPath);
          dir.createSync(recursive: true);
        }
      }
    }

    // 查找目标目录中有，但原目录中没有的元素
    for (final targetItemAbsPath in targetStatMap.keys) {
      String sourceItemAbsPath = targetItemAbsPath.replaceFirst(targetAbsPathPrefix, sourceAbsPathPrefix);
      if (sourceStatMap[sourceItemAbsPath] == null) {
        // 如果原目录没有，则执行删除操作
        if (targetStatMap[targetItemAbsPath]!.type == FileSystemEntityType.file) {
          File file = File(targetItemAbsPath);
          if (file.existsSync()) {
            try {
              file.deleteSync();
            } catch (e) {
              print('delete file $targetItemAbsPath failed');
            }
          }
        } else {
          Directory dir = Directory(targetItemAbsPath);
          if (dir.existsSync()) {
            try {
              dir.deleteSync();
            } catch (e) {
              print('delete directory $targetItemAbsPath failed');
            }
          }
        }
      }
    }
  }
}
