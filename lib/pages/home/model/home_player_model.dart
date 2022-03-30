import 'package:c_m_player/pages/home/data/song_list.dart';
import 'package:flutter/material.dart';

class HomePlayerModel extends ChangeNotifier {
  late SongModel _currentSong = SongModel(songName: "刀剑如梦",songAuthor: "陈梓童");

  SongModel get current {
    return _currentSong;
  }

  set current(SongModel model) {
    _currentSong = model;
    notifyListeners();
  }
}