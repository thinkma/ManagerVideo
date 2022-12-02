import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:managervideoproject/Tools/LocalManager.dart';
import 'package:managervideoproject/Tools/inputPassword.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Tools/tools.dart';


class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

final width = window.physicalSize.width;
final height = window.physicalSize.height;

 bool isAddScript = true;



 List<String> titleList = ["开启密码","修改密码","版本","反馈","分享"];

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String versionS =  "版本:" + "${Platform.version}";
    var isScript = passwordManager.isVialAddScript();
    isScript.then((value){
      setState(() {
        isAddScript = value;
        var v = versionS.split(" ")[0];
        titleList = ["开启密码","修改密码","${v}","反馈","分享"];

      });
    });
  }

    getLastShareFilePath () async {
    String path = await Tools().lastShareFilePath;
    print(path);
    // 这里记得将最后一次分享的文件链接清空
    await Tools().clearLastShareFilePath;
  }

  getSendMessageFilePath()async{
    String path = await Tools().lastMessageFilePath;
    print(path);
    // 这里记得将最后一次分享的文件链接清空
    await Tools().clearMessageFilePath;

  }

  shareAppFilePath() async {
    String path = await Tools().lastShareFilePath;
    print(path);
    // 这里记得将最后一次分享的文件链接清空
    await Tools().clearLastShareFilePath;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(45, 45, 45, 1.0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(45, 45, 45, 1.0),
        title: Text("设置"),
        leading: Container(
          width: 66,
          height: 66,
          child: MaterialButton(
          child: Image.asset("assets/images/common_rewind.png",
          scale: 1.0,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        )
      ),
      body: Container(
            child: Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 5),
            child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {

                if(index == 1){
                                  return Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Divider(height: 0,color: Color.fromRGBO(45, 45, 45, 1),));

                }
                return Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Divider(height: 1,color: Color.fromRGBO(105, 105, 105, 1),));
            },
            itemBuilder: (BuildContext context, int index) {
            if(index == 0){
                return switchPasswordButton(index);
            }
            if(index == 1){
                BorderRadius radius = BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10));
                return InkWell(
                  child: arrowSwitchButton(index,radius,0),
                  onTap: (){
                    var setV = passwordManager.isFristSetPassword();

                    setV.then((value){
                      if(value == false){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(3,changePassword)));
                      }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(2,changePassword)));
                      }
                    });
                  },
                );

            }
            if(index == 2){
            BorderRadius radius = BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10));
            return arrowSwitchButton(index,radius,20);
            }
             if(index == 3){
            BorderRadius radius = BorderRadius.circular(0);
            return InkWell(
              onTap: (){
        if (Platform.isIOS) {
  //   launch("message://").catchError((e){
    
  // });
  getSendMessageFilePath();
}if(Platform.isAndroid){

}


              },
              child: arrowSwitchButton(index,radius,0),
            );
            }
            BorderRadius radius = BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10));
            return InkWell(
              child: arrowSwitchButton(index,radius,0),
              onTap: (){

                if (Platform.isIOS) {
                  shareAppFilePath();
                }

              },
            );
            },
            itemCount: 5,
            ),
          ),
          )
    );
  }


 void changePassword(int type,int successful){
      if(type == 1){
        if(successful == 1){
            passwordManager.setScriptStatue();

             setState(() {
                          isAddScript = !isAddScript;
                        });
        }
      }
 }

 Widget arrowSwitchButton(int index,BorderRadius radius,double top){
  return Padding(padding: EdgeInsets.only(left: 20,right: 20,top: top),
            child: Container(
             decoration: BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1.0),
                  borderRadius: radius),
                height: 88,
                child: Row(
                  children: [
                   Padding(
                    padding: EdgeInsets.only(
                    left: 15),
                    child:  Text(titleList[index],style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),),
                   ),
                   const Expanded(child:  SizedBox()),
                   Padding(padding: EdgeInsets.only(right: 10),
                   child: ElevatedButton(
                    
                    style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                            backgroundColor: 	MaterialStateProperty.all(Colors.transparent)),
                    onPressed: (){

                   
                  }, 
                  child: Image.asset("assets/images/set_up_right_click.png"),
                  ),
                  )
                  ],
                ),
              ));
  }
 
 




  Widget switchPasswordButton(int index){
    return Padding(padding: EdgeInsets.only(left: 20,right: 20),
              child: Container(
             decoration: BoxDecoration(
                  color: Color.fromRGBO(66, 66, 66, 1.0),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10)),
    ),
                height: 88,
                child: Row(
                  children: [
                   Padding(
                    padding: EdgeInsets.only(
                    left: 15),
                    child:  Text(titleList[index],style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),),
                   ),
                   const Expanded(child:  SizedBox()),
                   Padding(padding: EdgeInsets.only(right: 10),
                   child: ElevatedButton(
                    style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                            backgroundColor: 	MaterialStateProperty.all(Colors.transparent)),
                    onPressed: (){
                        /// 是否软件加密
                       if(isAddScript == true){


                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(1,changePassword)));




                       }else{
                        passwordManager.setScriptStatue();

                        setState(() {
                          isAddScript = !isAddScript;
                        });

                       }
                  }, 
                  child: isAddScript?Image.asset("assets/images/set_up_switch_open.png"):Image.asset("assets/images/set_up_switch_close.png"),
                  ),
                  )
                  ],
                ),
              ));
  }
}