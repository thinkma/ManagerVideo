

class videoModel {
  final int id;
  final String VideoName;
  final String VideoPath;
  final String updateTime;
  final String VideoSize;
  final String VideoPicPath;
  final String videoScript;



/*

      "id INTEGER PRIMARY KEY,"
      "VideoName TEXT,"
      "VideoPath TEXT,"
       "updateTime TEXT,"
      "VideoSize TEXT,"
      "VideoPicPath TEXT,"
      "videoScript TEXT,"
      "password TEXT)";

*/

  const videoModel({
    required this.id,
    required this.VideoName,
    required this.VideoPath,
    required this.updateTime,
    required this.VideoSize,
    required this.VideoPicPath,
    required this.videoScript,

  });

   factory videoModel.formJson(Map json) {
   return videoModel(
     id: json['id'],
     VideoName: json['VideoName'],
     VideoPath: json['VideoPath'],
     updateTime: json['updateTime'],
     VideoSize: json['VideoSize'],
     VideoPicPath: json['VideoPicPath'],
     videoScript: json['videoScript'],
   );
 }
}