
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:managervideoproject/Home/HomeVideoPlayer.dart';
import 'package:managervideoproject/Tools/BillSQLManager.dart';
import 'HomeSetting.dart';
import 'dart:ui';
import 'ListPageView.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../Tools/ConstantUtils.dart';
import '../Home/model/videoModel.dart';
import '../Tools/inputPassword.dart';
import 'package:animations/animations.dart';
import '../Tools/LocalManager.dart';
import 'HomeRenamePage.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

final width = window.physicalSize.width;
final height = window.physicalSize.height;
 List<Map<String, dynamic>> listValue = [];
 List<videoModel> modeList = [];
 int currentDataType = 0;

 


TextEditingController searchController = TextEditingController();

    Future<File> _getLocalDocumentFile(String videoName) async {
    final dir = await getApplicationDocumentsDirectory();
    print("file = ${dir.path}");
    return File('${dir.path}/${videoName}');
  }

   static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

void showBottomSheet(int currentType) {
    showModal(
      context: context,
      //动画过渡配置
      configuration: FadeScaleTransitionConfiguration(
        //阴影背景颜色
        barrierColor: Colors.black54,
        //打开新的Widget 的时间
        transitionDuration: Duration(milliseconds: 1000),
        //关闭新的Widget 的时间
        reverseTransitionDuration: Duration(milliseconds: 1000),
      ),
      builder: (BuildContext context) {
        //显示的Widget
        return PasswordInputContoller(currentType,successful);
    
      },
    );
  }

  
  Future getVideoImage(String videoPath) async{
        var thumbPath;
    //将视频mp4格式的地址转成png格式，判断文件中是否有存在过（插件生成过）
    String thumPhotoPath = videoPath.toString();//video是视频地址
    thumbPath = thumPhotoPath.substring(0, thumPhotoPath.length - 3) + "png";//将地址后面的mp4去掉，再添加png，判断这个地址文件是否存在
    File photoPath = File(thumbPath);

    //返回真假
    var pathBool = await photoPath.exists();
    //如果已经存在就直接将mp4格式地址转成png格式地址
    if (pathBool) {
      String path = videoPath.toString();
      thumbPath = path.substring(0, path.length - 3) + "png";//如果存在就直接用
    } else if (!pathBool) {
      //如果没有存在就重新获取视频缩略图
      String thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: videoPath,
          imageFormat: ImageFormat.PNG,
          maxWidth: 128,
          quality: 25).toString();
      thumbPath = thumbnailPath;
      print("thumbPath = ${thumbPath}");
    }

  }

  final picker = ImagePicker();
  var _imgPath;
  late PickedFile pcikeFiless;

  Future getImage(bool isTakePhoto) async {
    try {
      // pcikeFiless = await picker.getVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 60));
    var videoName = "video" + "${currentTimeMillis()}" + ".mp4";

      // pcikeFiless = await picker.getVideo(source: source)
      XFile? videoPath = await picker.pickVideo(source: ImageSource.gallery,maxDuration: const Duration(seconds: 60));
      var pathvideo = await _getLocalDocumentFile(videoName);
    

      String? thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath!.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 180,
      quality: 25);

/*
/private/var/mobile/Containers/Data/Application/52E313E1-F244-49DF-A438-A8D21F6C2A20/tmp/trim.8FE8F28B-0321-457F-9316-7AEB615F8971.png
*/
      var thumbnailPathName = thumbnailPath!.split("/").last;
      if(Platform.isAndroid){
        thumbnailPathName = thumbnailPath;
      }

      print("thumbnailPath = ${thumbnailPath}");
      videoPath?.saveTo(pathvideo.path);
      print(videoPath!.name);
      videoPath.length().then((value){
       print(value);
       var VideoM = value/1000000;
       print(VideoM);
       print(videoName);

      BillSQLManager manager1 = new BillSQLManager();

/*
      "VideoName TEXT,"
      "VideoPath TEXT,"
      "VideoSize TEXT,"
      "VideoPicPath TEXT,"
      "videoScript TEXT,"
      "password TEXT)";

*/
   Map<String, dynamic>  map = Map<String, dynamic>.from({
  'VideoName': videoName,
  'VideoPath': '${videoName}',
  'VideoSize': '${VideoM}',
  'VideoPicPath': "${thumbnailPathName}",
  'videoScript': '0',
  'updateTime':'${currentTimeMillis()}',
  'password': '0'
});
  var pathBool =  manager1.insertByMap(ConstantUtils.DB_NAME,map);
  pathBool.then((value){
  updateUpListView();
      print(value);
    if(value == 1){
      
      

    }
  });
});
    } catch (e) {
      print("该手机不支持相机");
    }
  }

     void updateUpListView (){
      BillSQLManager manager1 = new BillSQLManager();

      var lists;
      if(currentDataType == 0){
          lists = manager1.queryList(ConstantUtils.DB_NAME,orderBy: "DESC");
      }
        if(currentDataType == 1){
          lists = manager1.queryList(ConstantUtils.DB_NAME,keys: "VideoSize",orderBy: "DESC");
      }  if(currentDataType == 2){
          lists = manager1.queryList(ConstantUtils.DB_NAME,keys: "VideoName",orderBy: "DESC");
      }

      print('list1111 = ${lists}');
      lists.then((value){
        modeList.clear();
        List<Map<String, dynamic>> listValue = value as List<Map<String, dynamic>>;
        print('list22222 = ${listValue.length}');
         List<videoModel> listss = [];
        for (var maps in listValue) {
          var model = videoModel.formJson(maps);
          listss.add(model);
        }
        setState(() {
            modeList = listss;
        });

      });

  }
  

   loadCamera() async{
    if (await Permission.camera.request().isGranted) {
      ///如果相机权限申请成功，下面写接下来要做的处理
      //do some thing...
      print("do some thing...");

    } else {
     ///如果相机权限申请失败，下面给出提示
     //OwonToast.show(S.of(context).permission_no_camera);
      print("do not thing...");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BillSQLManager manager1 = new BillSQLManager();
    var result =  manager1.initDB();

    result.then((value){
      updateUpListView();

       var showPwd = passwordManager.isVialAddScript();
       showPwd.then((value){
        if(value == true){

        var ps =passwordManager.isFristSetPassword();
        ps.then((value) =>{

            if(value == "1"){
              showBottomSheet(1)
            }else{
              showBottomSheet(3)
            }


        });




        }
       });

        
      
    });

   
   // 
  }

/// 选择排序
  void didClickSelect(int index){
      if(index == 0){
      currentDataType = 0;
      }
      if(index == 1){
      currentDataType = 1;

      }
      if(index == 2){
      currentDataType = 2;

      }
      updateUpListView();

  }

/// 密码验证 currentType：验证类型（1:代表验证密码 2.重置密码 3.第一次设置密码）  successful：是否成功
  void successful(int currentType,int successful){
      if(currentDataType == 3){

      }
      if(currentDataType == 1){
        /// 验证通过
      }if(currentDataType == 2){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(3,resetsuccessful)));

      }
  }

  void resetsuccessful(int currentType,int successful){
      if(currentDataType == 3){
/// 设置密码成功

      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(47, 47, 47, 1.0),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("视频管理"),
        backgroundColor: Color.fromRGBO(47, 47, 47, 1.0),
        actions: [
         Padding(
          padding: EdgeInsets.only(top: 5,right: 0),
          child:  Container(
            width: 60,
            height: 60,
            child: MaterialButton(
            splashColor:Color.fromRGBO(0, 0, 0, 0),
            child: Image.asset("assets/images/icon_home_setting.png"
            ,scale: 1,
            fit: BoxFit.cover,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage()));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>videoRenamePage()));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context){
              //   return videoRenamePage();
              // },
              // fullscreenDialog: true));
              // // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(2,successful)));
                //final file = _getLocalDocumentFile();
            },
            )
         )
          )
        ],
      ),
      
      body:Column(
        children: [
          Container(
            width: width,
            height: 90,
            child: Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 5),
            child: Container(
                   decoration: BoxDecoration(
                   color: Color.fromRGBO(66, 66, 66, 1.0),
                  borderRadius: BorderRadius.circular(10),
    ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 15
                              ),
                              child: TextField(
                              controller: searchController,
                              style: TextStyle(fontSize: 20,
                              color: Colors.white),
                              decoration: InputDecoration(
                              hintText: "请输入视频名称",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(129, 129, 129, 1),
                              ),
                              border:InputBorder.none,
                              ),
                            ),
                            )
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 90,
                          child: MaterialButton(
                            splashColor:Color.fromRGBO(0, 0, 0, 0),
                            highlightColor: Color.fromRGBO(0, 0, 0, 0),
                            child: Image.asset("assets/images/home_search_icon.png"),
                            onPressed: (){
                              print("object" + searchController.text);//
      BillSQLManager manager1 = new BillSQLManager();
      var lists = manager1.querySearchList(ConstantUtils.DB_NAME, searchController.text);
      lists.then((value){
        modeList.clear();
        List<Map<String, dynamic>> listValue = value as List<Map<String, dynamic>>;
        print('list22222 = ${listValue.length}');
         List<videoModel> listss = [];
        for (var maps in listValue) {
          var model = videoModel.formJson(maps);
          listss.add(model);
        }
        setState(() {
            modeList = listss;
        });

      });



                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeVideoPlayer("https://media.w3.org/2010/05/sintel/trailer.mp4")));
                            },
                          ),
                        ),                        
                    ],
                  ),
              ),),),
              Expanded(
                child:ListViewPages(modeList,didClickSelect),
                // child:Text("2"),

                ),
                FloatingActionButton(onPressed: (){
                  loadCamera();
                  getImage(false);
                },
                child: Image.asset("assets/images/home_add_icon.png"),
                backgroundColor: Color.fromRGBO(47, 47, 47, 1.0),
                elevation: 0,),
                
        ],
         
      ),
    );
  }
}