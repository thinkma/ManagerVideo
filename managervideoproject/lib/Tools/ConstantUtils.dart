class ConstantUtils {
  static String DB_NAME = "videoDB";
  static int DB_VERSION = 1;
  static String CREATE_BILL_SQL = "CREATE TABLE videoDB("
      "id INTEGER PRIMARY KEY,"
      "VideoName TEXT,"
      "VideoPath TEXT,"
       "updateTime TEXT,"
      "VideoSize TEXT,"
      "VideoPicPath TEXT,"
      "videoScript TEXT,"
      "password TEXT)";


}