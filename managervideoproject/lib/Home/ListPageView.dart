import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managervideoproject/Tools/BillSQLManager.dart';
import '../Home/model/videoModel.dart';
import 'HomeVideoPlayer.dart';
import 'package:path_provider/path_provider.dart';
import '../Tools/ConstantUtils.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'HomeRenamePage.dart';

class ListViewPages extends StatefulWidget {


 late final void Function(int) callback; 
 List<videoModel> listValue;
 ListViewPages(this.listValue,this.callback);

 


  @override
  State<ListViewPages> createState() => _ListViewPagesState();
}

class _ListViewPagesState extends State<ListViewPages> {

 late videoModel renameModelSelect;
 late int reNameIndex;
 late String imageRootPath; 

  @override
  void initState() {
        final disre = getApplicationSupportDirectory();
        disre.then((value){
           print("valuevalue = ${value.path}");
           var root = value.path.split("Library").first;
          print("root = ${root}");
          imageRootPath = root + "tmp/";

        });


    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      
      if(index == 0){
        return getHeadListViewBuild(context,index);
      }else{
        videoModel model = widget.listValue[index -1];
        // videoModel model2 = widget.listValue[index+3];

        return InkWell(
          child: getItemListeViewBuild(context,index),
          onTap: (){

          print("model = ${model.VideoPath}");


        final dir = getApplicationDocumentsDirectory();
        dir.then((value){
        var pathvideo = "${value.path}/${model.VideoPath}";
        print("model3 = ${pathvideo}");
          if(model.videoScript == "1"){
          clickGotoVideoPlay(pathvideo,model.VideoName);
                return;
          }

        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeVideoPlayer(pathvideo,model.VideoName)));


        });


          },
        );
      }
    },
    itemCount: widget.listValue.length + 1,);

    
  }

Future<bool>clickUnlockVideoPlay(String path) async {

  final LocalAuthentication auth = LocalAuthentication();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ]);
        if(didAuthenticate == true){
          print("didAuthenticate");
          return true;
        }else{
          print("====didAuthenticate");
          return false;
        }

}


/// 加密后进入
Future<void> clickGotoVideoPlay(String path,String title) async {
  final LocalAuthentication auth = LocalAuthentication();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ]);
        if(didAuthenticate == true){
          print("didAuthenticate");
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeVideoPlayer(path,title)));
        }else{
          print("====didAuthenticate");
        }


}
  
  void removeModel(videoModel dex){
    setState(() {
      widget.listValue.remove(dex);

    });

  }

  Widget getItemListeViewBuild(BuildContext context,int index){

  var _slidableController = new SlidableController();
  videoModel model = widget.listValue[index -1];
  var scriteIconName = model.videoScript == "1"?"home_my_video_edit_unlock.png":"home_my_video_edit_encryption.png";
    return Slidable(
            // showAllActionsThreshold: 0.3,
            //action占全部的比例
            actionExtentRatio: 0.15,
            controller: _slidableController,
            //列表中只有一个能滑动
            key: Key(UniqueKey().toString()),
            //主界面
            
            child:itemListRow(context,index,model),
            
            //滑动的动画
            actionPane: SlidableStrechActionPane(),
            //左侧滑出
            actions: [
            ],
            //右侧滑出
            secondaryActions: [
              buildIconSlideAction("删除", Image.asset("assets/images/home_my_video_edit_delete.png"), Colors.red,model,index - 1),
              buildIconSlideAction("锁住", Image.asset("assets/images/${scriteIconName}"), Colors.blue,model,index -1),
              buildIconSlideAction(
                  "命名", Image.asset("assets/images/home_my_video_edit_rename.png"), Colors.orange,model,index -1)
            ],
            //关闭监听
            dismissal: SlidableDismissal(
              dismissThresholds: <SlideActionType, double>{
                //只能单侧关闭
                SlideActionType.primary: 1.0,
                SlideActionType.secondary: 1.0,
              },
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                print("actionType==$actionType");
                setState(() {
                  //操作
                });
              },
              //即将关闭,可以取消关闭的动作
              onWillDismiss: (actionType) {
                //Fluttertoast.showToast(msg: "无法删除");
                return false;
              },
            ),
          );
  }


   Widget buildIconSlideAction(String title, Image icon, Color color,videoModel model,int index) {
    return Container(
      width: 100,
      child: MaterialButton(
        child: icon,
        onPressed: (){
            if(title == "删除"){
           print("删除${model.VideoName}");
           BillSQLManager manager = BillSQLManager();
           var result =  manager.deleteByParams(ConstantUtils.DB_NAME, "id", model.id);
           result.then((value) {
            if(value != -1){
              removeModel(model);
            }
           });
            }
            if(title == "锁住"){
              print("锁住${model.VideoName}");
if(model.videoScript == "1"){
 var  isluck = clickUnlockVideoPlay("");
 isluck.then((value){
      if(value == true){
        UpdateModelforScript(model,index);
      }
 });
}else{
    UpdateModelforScript(model,index);

}

            }
            if(title == "命名"){
              print("命名${model.VideoName}");
              renameVideo(model,index);
            }
        },
      )
    );
 }

void renameSucceful(String name){


  Map<String, dynamic>  map = Map<String, dynamic>.from({
  'VideoName': "${name}",
  'VideoPath': '${renameModelSelect.VideoPath}',
  'VideoSize': '${renameModelSelect.VideoSize}',
  'VideoPicPath': '${renameModelSelect.VideoPicPath}',
  'videoScript': (renameModelSelect.videoScript == "0")?"1":"0",
  'updateTime':'${renameModelSelect.updateTime}',
  'password': '0',
  "id":renameModelSelect.id
});

              this.renameModelSelect = videoModel.formJson(map);

              BillSQLManager manager = BillSQLManager();
              manager.updateByParams(ConstantUtils.DB_NAME, "id", renameModelSelect.id, map);
              videoModel newmodesl = videoModel.formJson(map);
              widget.listValue.removeAt(reNameIndex);
              setState(() {
                widget.listValue.insert(reNameIndex, newmodesl);
              });




}

 void renameVideo(videoModel model,int intdex){

  this.reNameIndex = intdex;
  this.renameModelSelect = model;

  showGeneralDialog(
  context: context,
  barrierDismissible:true,
  barrierLabel: '',
  transitionDuration: Duration(milliseconds: 200),
  pageBuilder: (BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
    return videoRenamePage(renameSucceful);  
});




 }
 void UpdateModelforScript(videoModel model,int index ){

       Map<String, dynamic>  map = Map<String, dynamic>.from({
  'VideoName': "${model.VideoName}",
  'VideoPath': '${model.VideoPath}',
  'VideoSize': '${model.VideoSize}',
  'VideoPicPath': '${model.VideoPicPath}',
  'videoScript': (model.videoScript == "0")?"1":"0",
  'updateTime':'${model.updateTime}',
  'password': '0',
  "id":model.id
});

              BillSQLManager manager = BillSQLManager();
              manager.updateByParams(ConstantUtils.DB_NAME, "id", model.id, map);
              videoModel newmodesl = videoModel.formJson(map);
              widget.listValue.removeAt(index);
              setState(() {
                widget.listValue.insert(index, newmodesl);
              });

 }

  Widget getHeadListViewBuild(BuildContext context,int indexPos){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("我的视频",style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: SizedBox()),
                Container(
                  width: 70,
                  height: 45,
                  child: MaterialButton(
                  child: Text("选择",style: TextStyle(
                    color: Color.fromRGBO(250, 196, 145, 1.0),
                    fontSize: 18,
                  ),),
                  onPressed: (){},
                ),
                ),
                Container(
                  width: 70,
                  height: 45,
                  child: MaterialButton(
                  child: Text("排序",
                  style: TextStyle(
                    color: Color.fromRGBO(250, 196, 145, 1.0),
                    fontSize: 18,
                  ),
                  ),
                  onPressed: (){

   _showBasicModalBottomSheet(context,["按照创建时间排序","按照视频大小排序","按照视频名称排序"]);
                  },
                ),
                )
              ],
            ),
          )
        ],
      ),
   
    );
  }

  Future<Future<int?>> _showBasicModalBottomSheet(context, List<String> options) async {
    return showModalBottomSheet<int>(
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color.fromRGBO(45, 45, 45, 1),
          height: 250,
          child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(66, 66, 66, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // color: Color.fromRGBO(66, 66, 66, 1),
                  height: 60,
                  width: 80,
                  child: Center(
                    child: InkWell(
                      onTap: (){
                      },
                      child: MaterialButton(
                        onPressed: (){
                      if(index == 0){
                            print("按照时间排序");
                            if(widget.callback != null){
                                   widget.callback(0);
                            }
                             Navigator.of(context).pop(index);
                        }
                         if(index == 1){
                            print("按照大小排序");
                               if(widget.callback != null){
                                   widget.callback(1);
                            }
                             Navigator.of(context).pop(index);


                        } if(index == 2){
                                 if(widget.callback != null){
                                   widget.callback(2);
                            }
                            print("按照名称排序");
                                            Navigator.of(context).pop(index);

                        }


                        },
                        child: Text(options[index],
                         style: TextStyle(
                                              color: Colors.white,
                                                fontSize: 18,
                                              ),
                         textAlign: TextAlign.center, 
                  ),
                      )
                    )
                  )
                ),
                onTap: () {
                  Navigator.of(context).pop(index);
                });
          },
          itemCount: options.length,
        ),
        );
      },
    );
  }

Widget itemListRow(BuildContext context,int index, videoModel model){

  final size =MediaQuery.of(context).size;
  final width =size.width;

  var videotempPic = "${this.imageRootPath}/${model.VideoPicPath}";
  if(Platform.isAndroid){
    videotempPic = model.VideoPicPath;
  }
  
  return Padding(
      padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child:Container(
        height: 120, 
        child: Row(
          children: [
            Container(
              child:Stack(
                children: [
                  Column(
                    children: [
          Expanded(
                  child: Container(
                    width: width-40,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox()),
                        Container(
                  decoration: BoxDecoration(
                   color: Color.fromRGBO(66, 66, 66, 1.0),
                  borderRadius: BorderRadius.circular(10),
    ),
                          width: width - 80,
                          height: 120,
                        )
                      ],
                    )
                  ),
                 ),
                    ],
                  ),
                Column(
                  children:[
                                     Expanded(
                  child: Row(
                    children: [
                      Stack(
                    children: [
                      Container(
                           decoration: BoxDecoration(
                   color: Color.fromRGBO(66, 66, 66, 1.0),
                  borderRadius: BorderRadius.circular(20),
    ),
                        width: 180,
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child:ClipRect(
                            child: Stack(
                            children: [
                           Container(
                           width: 170,
                          height: 100,
                            child:   Image.file(
                              File("${videotempPic}"),fit:BoxFit.fitWidth
                             ),

                           ),
                          // Image.network("https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.580-8.com%2Freptile%2Fgirl%2F20224%2F31_608290150.jpg&refer=http%3A%2F%2Fimage.580-8.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1669191381&t=c580d68a8b1bbfebd23d8cd4ec12e49d"),
                                         BackdropFilter(
          	/// 过滤器
            filter: ImageFilter.blur(sigmaX: model.videoScript == "1"?10:0, sigmaY: model.videoScript == "1"?10:0),
            /// 必须设置一个空容器
            child: Container(
              width: 100,
              height: 100,
            ),
          ),
                            ],
                          ) ,
                          ),
                       
                        ),

                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 70,right: 70,top: 40,bottom: 40),
                          child: Image.asset("assets/images/home_my_video_play_icon.png"),
                        ),
                      )
                    ],
                  ),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start, 
                        
                    children: [
                      Container(
                        height: 70,
                        width: width - 180 - 50,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10,right: 40),
                          child: Text("${model.VideoName}",
                              maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                          ),),
                        ),
                      ),
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text('${model.VideoSize}',style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey
                        ),),
                        // Padding(padding: EdgeInsets.only(
                        //   right: 10,left: 50,bottom: 5
                        // ),child:Container(
                        //   width: 35,
                        //   height: 35,
                        //   child: Image.asset("assets/images/home_my_video_edit.png"),
                        // ),)
                          ],
                        ),
                      )
                    ],
                  )
                    ],
                  )
                 ),
                  ]

                )

                ],
              ),
            ),
          ],
        ),
      ),
      
    );
}


}








