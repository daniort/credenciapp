import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logs/data/cameras.dart';

import 'package:logs/data/colors.dart';
import 'package:logs/pages/home.dart';
import 'package:logs/providers/appstate.dart';

import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => new AppState()),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: primary),
        debugShowCheckedModeBanner: false,
        title: 'CredenciApp',
        home: HomePage(),
      ),
    );
  }
}
