
import 'package:flutter/material.dart';
import '../Tools/LocalManager.dart';
import 'dart:math';

const shakeCount = 4;
const shakeDuration = Duration(milliseconds: 500);


class PasswordInputContoller extends StatefulWidget {

 late final void Function(int,int) Successfulcallback; 


  // PasswordInputContoller({Key? key}) : super(key: key);
  int controllerType = 1;///1:代表验证密码 2.重置密码 3.第一次设置密码

  PasswordInputContoller(this.controllerType,this.Successfulcallback);

  @override
  State<PasswordInputContoller> createState() => _PasswordInputContollerState();
}

class _PasswordInputContollerState extends State<PasswordInputContoller>  with TickerProviderStateMixin {

 final List<String> numberList = [];
 late String showTitle;
 late final AnimationController _shakeController =
      AnimationController(vsync: this, duration: shakeDuration);

  
  @override
  void initState() {
    
      _shakeController.addListener(() {
      if (_shakeController.status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(widget.controllerType == 1){
      showTitle = "请输入密码";
    }
     if(widget.controllerType == 2){
      showTitle = "请输入原密码";
    }
      if(widget.controllerType == 3){
      showTitle = "请设置新的密码";
    }
  
    return Scaffold(
      backgroundColor: Color.fromRGBO(45, 45, 45, 1),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(45, 45, 45, 1),
        title: Text(""),
        actions: [
         (widget.controllerType == 2)? MaterialButton(
            splashColor:Color.fromRGBO(0, 0, 0, 0),
            highlightColor: Color.fromRGBO(0, 0, 0, 0),
            child: Text("下一步",style: TextStyle(
              color: Colors.white
            ),),
            onPressed: (){

            },
          ):Text(""),
        ],
        leading:(widget.controllerType == 2)? MaterialButton(
          child: Image.asset("assets/images/common_rewind.png"),
          onPressed: (){
              Navigator.of(context).pop();
          },
        ):Text(""),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20),
            child: Text("${showTitle}",style: TextStyle(
              color: Colors.white,
              fontSize: 22
            ),)),
            Padding(padding: EdgeInsets.only(left: 70,right: 70,top: 40),
            child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final sineValue =
                  sin(shakeCount * 2 * pi * _shakeController.value);
              return Transform.translate(
                offset: Offset(sineValue * 10, 0),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                inputPasswordItem((numberList.length > 0)?"*":""),
                inputPasswordItem((numberList.length > 1)?"*":""),
                inputPasswordItem((numberList.length > 2)?"*":""),
                inputPasswordItem((numberList.length > 3)?"*":""),
              ],
            ),
          ),),
            Padding(
              padding: EdgeInsets.only(top: 70),
              child:Column(
                children: [
                 Padding(
                  padding: EdgeInsets.only(left: 50,right: 50),
                  child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      numberInput("1"),
                      numberInput("2"),
                      numberInput("3"),
                    ],
                  ),
                 ),
                   Padding(
                  padding: EdgeInsets.only(left: 50,right: 50,top: 60),
                  child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      numberInput("4"),
                      numberInput("5"),
                      numberInput("6"),
                    ],
                  ),
                 ),  Padding(
                  padding: EdgeInsets.only(left: 50,right: 50,top: 60),
                  child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      numberInput("7"),
                      numberInput("8"),
                      numberInput("9"),
                    ],
                  ),
                 ),
                 Padding(
                  padding: EdgeInsets.only(left: 50,right: 50,top: 60),
                  child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      numberfunctionInput("assets/images/password_cancel.png",true),
                      numberInput("0"),
                      numberfunctionInput("assets/images/password_delete.png",false),
                    ],
                  ),
                 )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget numberInput(String item){
    return Container(
      decoration: BoxDecoration(
        color:Color.fromRGBO(66,66,66,1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.0, color: Color.fromRGBO(26,245,212,1)),
      ),
      width: 60,
      height: 60,
      child: Center(
        child: MaterialButton(
        splashColor:Color.fromRGBO(0, 0, 0, 0),
        highlightColor: Color.fromRGBO(0, 0, 0, 0),
            onPressed: (){
          setState(() {
            print("item = ${item}");
            if(numberList.length < 4){
               numberList.add(item);
            }
            if(numberList.length == 4){
                   /// 验证密码
              if(widget.controllerType == 1 || widget.controllerType == 2){
                var pas = "";
                for (var element in numberList) {
                  pas = pas + element;
                }

                var isOk = passwordManager.isVialPassword(pas);
                isOk.then((value){

                  if(value == true){
                    if(widget.Successfulcallback != null){
                      widget.Successfulcallback(1,1);
                      if(widget.controllerType == 1){
                            Navigator.of(context).pop();

                      }
                      if(widget.controllerType == 2){
                        // Navigator.of(context).push(route)
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PasswordInputContoller(3,widget.Successfulcallback)));

          //     Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => PasswordInputContoller(3,widget.Successfulcallback)
          //     ),
          //     (route) => route == null
          // );
                      }
                    }
                  }else{
                    numberList.clear();
                    _shakeController.forward();
                  }
                });
                    

              }
              if(widget.controllerType == 2){

              }
              if(widget.controllerType == 3){
                var pas = "";
                for (var element in numberList) {
                  pas = pas + element;
                }
                passwordManager.setnewLocalPassword(pas);
                Navigator.of(context).popUntil((route) => route.isFirst);
                
              }
            }
          });
            },
            child: Text(item,style: TextStyle(
          fontSize: 25,
          color: Colors.white
        ),),
          ),
      ),
    );
  }

Widget numberfunctionInput(String icon,bool deleteAll){
      return Container(
      decoration: BoxDecoration(
        color:Color.fromRGBO(66,66,66,1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.0, color: Color.fromRGBO(26,245,212,1)),
      ),
      width: 60,
      height: 60,
      child: Center(
        child: MaterialButton(
          child: Image.asset(icon),
          onPressed: (){
            setState(() {
               if(deleteAll == true){
              numberList.clear();
            }else{
              numberList.removeLast();
            }
            });
           
          })),
      );
  }

  Widget inputPasswordItem(String item){
    return Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Color.fromRGBO(66,66,66,1),
                  ),
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text(item,style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(26,245,212,1),

                ),),
                  ),
                );
  }
}