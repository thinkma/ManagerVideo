import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Home/homePage.dart';
import 'Tools/tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(HomeAPPlication());
}


class HomeAPPlication extends StatefulWidget {
  HomeAPPlication({Key? key}) : super(key: key);

  @override
  State<HomeAPPlication> createState() => _HomeAPPlicationState();
}

class _HomeAPPlicationState extends State<HomeAPPlication> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "视频管理",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home:GestureDetector(
        child: HomePage(),
        onTap: (){
            hideKeyboard(context);
        },
      ),
    );
  }

    void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 当APP打开时我们去获取分享文件的链接

      //
    }
  }



}

class HomeApp extends StatelessWidget with WidgetsBindingObserver {
  const HomeApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "视频管理",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home:GestureDetector(
        child: HomePage(),
        onTap: (){
            hideKeyboard(context);
        },
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

