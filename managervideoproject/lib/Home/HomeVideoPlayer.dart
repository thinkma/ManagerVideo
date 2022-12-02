import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'CustomFijkPanel.dart';

class HomeVideoPlayer extends StatefulWidget {
  final String url;
  final String title;
  HomeVideoPlayer(this.url,this.title);
  // HomeVideoPlayer({Key? key}) : super(key: key);

  @override
  State<HomeVideoPlayer> createState() => _HomeVideoPlayerState();
}

class _HomeVideoPlayerState extends State<HomeVideoPlayer> {

  final FijkPlayer player = FijkPlayer();
  
 final height = 800;
 final width = window.physicalSize.width;


  @override
  void initState() {
    super.initState();
    player.setLoop(0);
    player.setDataSource(widget.url,autoPlay: true);
    player.enterFullScreen();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pakyer"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FijkView(player: player,
        color: Colors.black,
        fit: FijkFit.fill,
        panelBuilder: ((player, data, context, viewSize, texturePos){
          return CustomFijkPanel(player: player, data: data, context: context, viewSize: viewSize, texturePos: texturePos,title: widget.title);
        }
      ),
      ),
    ));
  }


  void dispose() {
    // 强制竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    player.release();
    super.dispose();
  }
}