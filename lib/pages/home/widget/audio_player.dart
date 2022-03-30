import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:itools/log.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// 单例模式
final AudioPlayerManger audioManager = AudioPlayerManger();

///
/// Title： Flutter声音播放工具类
/// Description：
/// 1. 单例模式
/// 2. 文件缓存管理优化
/// 3. 播放Flutter项目本地assets音频文件
/// 4. 播放网络音频文件
///
/// @version 1.0.0
/// @date 2022/03/25
///
class AudioPlayerManger {

  static String resourcePath = "assets/music/";

  late AudioPlayer player;
  static late AudioCache _audioCache;

  // 工厂方法构造函数
  factory AudioPlayerManger() => _getInstance();

  // instance的getter方法，singletonManager.instance获取对象
  static AudioPlayerManger get instance => _getInstance();

  // 获取对象
  static AudioPlayerManger _getInstance() => _instance;

  // 静态变量_instance，存储唯一对象
  static late final AudioPlayerManger _instance = AudioPlayerManger.internal();

  // 私有命名式构造方法，通过它实现一个类 可以有多个构造函数，
  // 子类不能继承internal
  // 不是关键字，可定义其他名字
  AudioPlayerManger.internal() {
    // 初始化...
    _audioCache = AudioCache();
    player = AudioPlayer();
    printf("初始化成功...");
  }

  // 音频文件夹, 缓存使用，path:文件
  Map<String, File> loadedFiles = {};

  ///播放
  loadAudioCache(String fileName) {
    // 播放给定的[fileName]。
    // 如果文件已经缓存，它会立即播放。否则，首先等待文件加载(可能需要几毫秒)。
    // 它创建一个新的实例[AudioPlayer]，所以它不会影响其他的音频播放(除非你指定一个[fixedPlayer]，在这种情况下它总是使用相同的)。
    // 返回实例，以允许以后的访问(无论哪种方式)，如暂停和恢复。
    _audioCache.play(fileName, mode: PlayerMode.LOW_LATENCY);
  }

  ///清空单个
  void clear(String fileName) {
    loadedFiles.remove(fileName);
  }

  ///清空整个
  void clearCache() {
    loadedFiles.clear();
  }

  /// 读取assets文件
  static Future<ByteData> _fetchAsset(String fileName) async {
    return await rootBundle.load('$resourcePath$fileName');
  }

  /// 读取到内存
  static Future<File> _fetchToMemory(String fileName) async {
    String path = '${(await getTemporaryDirectory()).path}/$fileName';
    final file = File(path);
    await file.create(recursive: true);
    return await file.writeAsBytes((await _fetchAsset(fileName)).buffer.asUint8List());
  }

  ///读取文件
  Future<File?> _loadFile(String fileName) async {
    if (!loadedFiles.containsKey(fileName)) {
      // 新增到缓存
      loadedFiles[fileName] = await _fetchToMemory(fileName);
    }
    return loadedFiles[fileName];
  }

  /// 本地音乐文件播放
  Future playLocal(String fileName) async {
    // 读取文件
    File? file = await _loadFile(fileName);
    // 播放音频
    // 如果[isLocal]为true， [url]必须是本地文件系统路径。
    int result = await player.play(file!.path, isLocal: true);
    if (result == 1) {
      printf('local play success');
    } else {
      printf('local play failed');
    }
    return result;
  }

  /// 远程音乐文件播放，localPath类似http://xxx/xxx.mp3
  playRemote(String url) async {
    int result = await player.play(url);
    if (result == 1) {
      printf('remote play success');
    } else {
      printf('remote play failed');
    }
  }

  ///暂停
  pause() async {
    // 暂停当前播放的音频。
    // 如果你稍后调用[resume]，音频将从它的点恢复
    // 已暂停。
    int result = await player.pause();
    if (result == 1) {
      printf('pause success');
    } else {
      printf('pause failed');
    }
  }

  /// 继续播放
  resume() async {
    int result = await player.resume();
    if (result == 1) {
      printf('resume play success');
    } else {
      printf('resume play failed');
    }
  }

  ///停止
  stop() async {
    int result = await player.stop();
    if (result == 1) {
      printf('stop success');
    } else {
      printf('stop failed');
    }
  }

  PlayerState state() {
    return player.state;
  }

  /// 调整进度 - 跳转指定时间
  /// milliseconds 毫秒
  jump(int milliseconds) async {
    //移动光标到目标位置。
    int result =
    await player.seek(Duration(milliseconds: milliseconds));
    if (result == 1) {
      printf('seek to success');
    } else {
      printf('seek to failed');
    }
  }

  ///调整音量
  ///double volume 音量 0-1
  setVolume(double volume) async {
    // 设置音量(振幅)。
    // 0表示静音，1表示最大音量。0到1之间的值是线性的
    int result = await player.setVolume(volume);
    if (result == 1) {
      printf('seek to success');
    } else {
      printf('seek to failed');
    }
  }

  ///释放资源
  release() async {
    // 释放与该媒体播放器关联的资源。
    // 当你需要重新获取资源时，你需要重新获取资源
    // 调用[play]或[setUrl]。
    int result = await player.release();
    if (result == 1) {
      printf('release success');
    } else {
      printf('release failed');
    }
  }
}