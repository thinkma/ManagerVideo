import 'dart:math';
import 'dart:async';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final FijkData data;
  final BuildContext context;
  final Size viewSize;
  final Rect texturePos;
  final String title;
  const CustomFijkPanel({
    required this.player,
    required this.data,
    required this.context,
    required this.viewSize,
    required this.texturePos,
    required this.title,

    
  });

  @override
  _CustomFijkPanelState createState() => _CustomFijkPanelState();
}

class _CustomFijkPanelState extends State<CustomFijkPanel> {
  FijkPlayer get player => widget.player;
  bool _playing = false;
  double sliderValue = 0;
  double sliderVolumnValue = 0;

  bool _showrate = false;// 显示倍速
  bool _showVolumn = false;// 显示倍速
  bool issliderDrag = false;

  String totleTime = "--:--:--";
  String currentTime = "--:--:--";
  int seekTime = 0;
  bool isCancle = false;

  double rate = 1.0;
 late final Timer timer;
  @override
  void initState() {
    super.initState();
    widget.player.addListener(_onValueChanged);
    const timeout = const Duration(milliseconds: 500);
    timer = Timer.periodic(timeout, (timer) { //callback function
  //1s 回调一次
      print('afterTimer='+DateTime.now().toString());
      if(this.isCancle == true){
        timer.cancel();
      }
      // time = timer;
      String currents = "${player.currentPos}";
    if(player.currentPos.inSeconds > 0){

    FijkValue value = player.value;

    print("当前总时间 =${player.currentPos}");
    String durations = '${value.duration}';
    // Array times = 
    String gfg = "durations";
    durations = durations.substring(0,7);
    print("当前总时间 =${player.currentPos.inHours}");

    int totleint = value.duration.inHours * 3600 + value.duration.inHours * 60 + value.duration.inSeconds;
    int currentint = player.currentPos.inHours * 3600 + player.currentPos.inHours * 60 + player.currentPos.inSeconds;
    
    
   
   
      if(player.currentPos != null){
        setState(() {
          currents = currents.substring(0,7);
          currentTime = currents;
          totleTime = durations;
          if(issliderDrag == false && currentint > seekTime){
          sliderValue = (currentint * 100) / (totleint);

          }
          
        });
      }




    }
    });
  }

  void _onValueChanged() {
    
    FijkValue value = player.value;
    print("value + ${value}");
    bool playing = (value.state == FijkState.started);
    
    if (playing != _playing) {
      setState(() {
        _playing = playing;
      });
    }

  // Splitting each character
  // of the string

    


  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: InkWell(
        child: Stack(
          children: [
            videoPlayController(context),
            videoPlayItemRate(context)
          ],
        ),
        onTap: () {
          if(_showrate == true){

    setState(() {
      _showrate = false;
    });

            return;
          }

    if(_showVolumn == true){
      _showVolumn = false;
       return;

    }
          _playing ? widget.player.pause() : widget.player.start();
        },
      ),
    );
  }

  Widget videoPlayVolume(BuildContext context){
    return Row(
      children: [
        Expanded(child: SizedBox()),
        Container(
          width: 230,
          color: Color.fromARGB(45, 45, 45, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("-",style: TextStyle(
                color: Colors.white,fontSize: 25
              ),),
              Container(
                width: 250,
                height: 200,
                child: Transform.rotate(
              angle: pi / 2,
              child: _volumeslider(),),
              ),
              Padding(padding: EdgeInsets.only(bottom: 40),
              child: Text("+",style: TextStyle(color: Colors.white,fontSize: 25),),)
            ]
          ),
        )
      ],
    );
  }


  Widget videoPlayItemRate(BuildContext context){

    if(_showVolumn == true){
        return videoPlayVolume(context);
    }

  if(_showrate == false){
      return SizedBox();
    }else{

    }
    return 
                Container(  
             child:  Row(
                children: [
                  Expanded(child: SizedBox()),
                  Container(
                    width: 230,
                    color: Color.fromARGB(45, 45, 45, 1),
                    child: Center(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: (){
                              player.setSpeed(0.5);
                              setState(() {
                                rate = 0.5;
                              });
                            },
                            child: Text("0.5x",style: TextStyle(color: rateSet(0.5)),),
                          ),
                             MaterialButton(
                            onPressed: (){
                               player.setSpeed(0.75);
                                 setState(() {
                                rate = 0.75;
                              });
                            },
                            child: Text("0.75x",style: TextStyle(color: rateSet(0.75)),),
                          ),   MaterialButton(
                            onPressed: (){
                            player.setSpeed(1);
                              setState(() {
                                rate = 1;
                              });

                            },
                            child: Text("1x",style: TextStyle(color: rateSet(1)),),
                          ),   MaterialButton(
                            onPressed: (){
                              player.setSpeed(1.25);
                                  setState(() {
                                rate = 1.25;
                              });
                              
                            },
                            child: Text("1.25x",style: TextStyle(color:rateSet(1.25)),),
                          ),   MaterialButton(
                            onPressed: (){
                            player.setSpeed(2);
                                    setState(() {
                                rate = 2;
                              });

                            },
                            child: Text("2x",style: TextStyle(color: rateSet(2)),),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
  }


  Color rateSet(double currentrate){
    if(currentrate == this.rate){
      return Color.fromRGBO(26, 245, 212,1);
    }else{
      return Colors.white;
    }
  }

  Widget videoPlayController(BuildContext context){

  

    return Column(
          children: [
            Container(
              height: 44,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: MaterialButton(
                    splashColor:Color.fromRGBO(0, 0, 0, 0),
                    highlightColor: Color.fromRGBO(0, 0, 0, 0),
                    child: Image.asset("assets/images/common_rewind.png"),
                    onPressed: (){
                 
                      timer.cancel();
                      this.isCancle = true;
                       Future.delayed(Duration(milliseconds: 10), () {
                      player.exitFullScreen();

});

                      Future.delayed(Duration(milliseconds: 10), () {
                                Navigator.of(context).pop();

});
                    },
                  ),
                  ),
                  Text(widget.title,style: TextStyle(
                    fontSize: 18,color: Colors.white
                  ),),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 35,
                  height: 35,
                  child: _playing?Image.asset("assets/images/play_page_Pause.png",fit: BoxFit.fill,):Image.asset("assets/images/play_page_play.png",fit: BoxFit.fill,)///play_page_Pause.png
                ),
              ),
            ),
              Container(
              height: 20,
              child: Padding(padding: EdgeInsets.only(left: 25,right: 25,bottom: 15),
              child: _slider(),),
            ),
            Container(
              height: 64,
              child: Row(
                children: [
                 Padding(padding: EdgeInsets.only(left: 25,bottom: 34,right: 10),
                 child:  MaterialButton(
                    onPressed: (){
                                  _playing ? widget.player.pause() : widget.player.start();

                    },
                    child: _playing?Image.asset("assets/images/play_page_Pause.png",fit: BoxFit.fill,):Image.asset("assets/images/play_page_play.png",fit: BoxFit.fill,),
                    ),
                  ),
                  Container(
                    height: 64,
                    child: Padding(padding: EdgeInsets.only(top: 6),child: Text('${currentTime} / ${totleTime}',style: TextStyle(color: Colors.white),)),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    child:Padding(
                      padding: EdgeInsets.only(
                        right: 5,bottom: 25
                      ),
                      child:  MaterialButton(
                      minWidth: 40,
                      child: Text("倍速",style: TextStyle(
                        color: _showrate?Color.fromRGBO(26, 245, 212,1):Colors.white,
                        fontSize: 15,
                      ),),
                      onPressed: (){
                        setState(() {
                          _showrate = !_showrate;
                        });
                      },),)
                  ),
                   Container(
                    child:Padding(
                      padding: EdgeInsets.only(
                        right: 25,bottom: 25
                      ),
                      child:  MaterialButton(
                      minWidth: 40,
                      child: Text("音量",style: TextStyle(
                        color: _showrate?Color.fromRGBO(26, 245, 212,1):Colors.white,
                        fontSize: 15,
                      ),),
                      onPressed: (){
                        setState(() {
                          _showVolumn = !_showVolumn;
                        });

                      },),)
                  ),
                ],
              ),
            ),
          ],
        );
  }



  @override
  void dispose() {
    player.removeListener(_onValueChanged);
    super.dispose();
  }


     Slider _volumeslider(){
    return Slider(
      value: sliderVolumnValue,
      max: 100,
      onChanged: (value){
        print("onChanged : $value");
        player.setVolume(value/100);
        updatevolumeSlider(value, "onChanged : $value");
      },
      onChangeStart: (value){
        print("onChangeStart : $value");
        updatevolumeSlider(value, "onChangeStart : $value");
      },
      onChangeEnd: (value){
        print("onChangeEnd : $value");
        updatevolumeSlider(value, "onChangeEnd : $value");
      },
    );

  }
   void updatevolumeSlider(value, text){
    sliderVolumnValue = value;

    setState(() {

    });
  }




    Slider _slider(){
    return Slider(
      value: sliderValue,
      max: 100,
      onChanged: (value){
        print("onChanged : $value");
        updateSlider(value, "onChanged : $value");
      },
      onChangeStart: (value){
        print("onChangeStart : $value");
        issliderDrag = true;
        updateSlider(value, "onChangeStart : $value");
      },
      onChangeEnd: (value){
        print("onChangeEnd : $value");
        updateSlider(value, "onChangeEnd : $value");
        FijkValue values = player.value;
        int totleint = values.duration.inHours * 3600 + values.duration.inHours * 60 + values.duration.inSeconds;
        int intVlaue = value.toInt();
        int seekint = (totleint * intVlaue / 100).toInt() * 1000;
        player.seekTo(seekint);
        seekTime = (seekint / 1000).toInt();
        // issliderDrag = false;

      },
    );

  }
   void updateSlider(value, text){
    sliderValue = value;

    setState(() {

    });
  }
}