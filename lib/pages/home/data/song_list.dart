final List<SongModel> songs = [
  SongModel(songName: "刀剑如梦",songAuthor: "陈梓童"),
  SongModel(songName: '这些民谣一次听个够',songAuthor: '翁大涵'),
  SongModel(songName: '酒家',songAuthor: "诺诺"),
  SongModel(songName: '结果',songAuthor: '阿木宇梅'),
];

class SongModel {
  SongModel({
    required this.songName,
    this.songAuthor = "未知",
    this.album = "未知",
  });

  final String songName;
  final String songAuthor;
  final String album;
}