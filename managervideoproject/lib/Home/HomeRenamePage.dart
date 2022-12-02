import 'package:flutter/material.dart';

class videoRenamePage extends StatefulWidget {
  // videoRenamePage({Key? key}) : super(key: key);
   late final void Function(String) sureReNamecallback; 

videoRenamePage(this.sureReNamecallback);
  @override
  State<videoRenamePage> createState() => _videoRenamePageState();
}

class _videoRenamePageState extends State<videoRenamePage> {

TextEditingController reNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
      child:  Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.end ,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
              Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(66, 66, 66, 1),
              ),
              width: 384,
              height: 224,
              child: Stack(
              children: [
                  Column(
                    children: [
                      Row(
                        children: [
     Expanded(child: SizedBox()),
                      MaterialButton(
                        onPressed: (){
                            Navigator.of(context).pop();
                        },
                        child: Image.asset("assets/images/rename_close.png"),),
                          
                        ],
                      ),
                      Text("重命名",style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),),
                      Padding(padding: EdgeInsets.only(left: 15,right: 15),
                      child: TextField(
                              controller: reNameController,
                              style: TextStyle(fontSize: 20,
                              color: Colors.white),
                              decoration: InputDecoration(
                              hintText: "请输入新的名称",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(129, 129, 129, 1),
                              ),
                              border:InputBorder.none,
                              )
                      ),),
                      Padding(padding: EdgeInsets.only(left: 15,right: 15),
                      child: Divider(height: 1,color: Colors.grey,),),
                      Padding(padding: EdgeInsets.only(top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(onPressed: (){

                            print( "修改的名字为"+ reNameController.text);
                            if(reNameController.text.length == 0){
                              return;
                            }
                            if(widget.sureReNamecallback != null){
                              widget.sureReNamecallback(reNameController.text);
                              Navigator.of(context).pop();
                            }


                          },child: Text("确定",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),),)]),
                        
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