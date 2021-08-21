import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logs/data/cameras.dart';

import 'package:logs/data/colors.dart';
import 'package:logs/pages/home.dart';
import 'package:logs/providers/appstate.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

// class Prueba extends StatefulWidget {
//   @override
//   _PruebaState createState() => _PruebaState();
// }

// class _PruebaState extends State<Prueba> {
//   // Notifiers
//   ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
//   ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
//   ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
//   ValueNotifier<Size> _photoSize = ValueNotifier(null);

//   // Controllers
//   PictureController _pictureController = new PictureController();
//   // [...]
//   File mifoto;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             width: 200,
//             child: CameraAwesome(
//               testMode: false,
//               onPermissionsResult: (bool result) {},
//               selectDefaultSize: (List<Size> availableSizes) =>
//                   Size(1920, 1080),
//               onCameraStarted: () {},
//               // zoom: 0.64,
//               // onOrientationChanged: (CameraOrientations newOrientation) {},
//               sensor: _sensor,
//               photoSize: _photoSize,
//               switchFlashMode: _switchFlash,
//               captureMode: _captureMode,
//               orientation: DeviceOrientation.portraitUp,
//               fitted: true,
//             ),
//           ),
//           GestureDetector(
//             onTap: () async {
//               try {
//                 Directory dir = await crearDirectorio('123456');
//                 print(dir.path);
//                 final String filePath =
//                     '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//                 _pictureController.takePicture(filePath);

//                 print("----------------------------------");
//                 print("TAKE PHOTO CALLED");
//                 this.mifoto = File(filePath);
//                 setState(() {});
//               } catch (e) {
//                 print(e);
//               }
//             },
//             child: Container(
//               color: Colors.pink,
//               height: 300,
//               child: Text('tomar foto'),
//             ),
//           ),
//           if (this.mifoto != null)
//             Container(
//                 child: Image.file(
//               File(this.mifoto.path),
//             ))
//         ],
//       ),
//     );
//   }
// }
