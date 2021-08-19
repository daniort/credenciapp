import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logs/data/colors.dart';
import 'package:logs/pages/historial.dart';
import 'package:logs/data/widgets.dart';
import 'package:logs/providers/appstate.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // await DataBase().initDataBase();
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
        title: 'Registro de Alumnos',
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PainterController painterController = PainterController();
  CameraController cameraControllerTrasera;
  // CameraController cameraControllerFrontal =
  //     CameraController(cameras[0], ResolutionPreset.low, enableAudio: false);
  TextEditingController controllerNumber = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> keyScaff = GlobalKey<ScaffoldState>();
  AppState state;
  Size size;
  bool listo = false;
  bool firma = false;
  bool foto = false;
  bool cargando = false;
  bool cambiarCamara = true;
  XFile mifoto;
  @override
  void initState() {
    super.initState();
    this.painterController.thickness = 3.0;
    this.painterController.backgroundColor = Colors.transparent;

    // cameraControllerFrontal.initialize().then((_) {
    //   if (!mounted) return;
    //   setState(() {});
    // });

    this.cameraControllerTrasera =
        CameraController(cameras[1], ResolutionPreset.low, enableAudio: false);

    cameraControllerTrasera.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    this.state = Provider.of<AppState>(context, listen: true);
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      key: keyScaff,
      appBar: AppBar(title: Text('Registro de Alumnos'), centerTitle: true),
      body: Column(children: [camara(), pizarron(), botones(), boton()]),
    );
  }

  Widget botones() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          btnBorrarFirma(),
          btnBorrarFoto(),
          btnCambiarCamara(),
          btnHistorial(),
        ],
      ),
    );
  }

  Widget pizarron() {
    return Expanded(
      child: Container(
        color: Colors.grey[300],
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Painter(painterController),
      ),
    );
  }

  Widget camara() {
    return Expanded(
        child: Container(
            width: this.size.width,
            child: (this.mifoto != null)
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Center(
                        child: Image.asset(this.mifoto.path,
                            fit: BoxFit.fitWidth)))
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: !cameraControllerTrasera.value.isInitialized
                        ? spinner()
                        : Center(
                            child: CameraPreview(cameraControllerTrasera)))));
  }

  Widget boton() {
    return InkWell(
      onTap: () async {
        if (this.mifoto != null && this.firma) {
          return showDialog(
            context: context,
            builder: (context) => dialogNumControl(),
          );
        }
        if (cameraControllerTrasera.value.isInitialized &&
            this.mifoto == null) {
          this.cargando = true;
          setState(() {});
          this.mifoto = await cameraControllerTrasera.takePicture();
          this.cargando = false;
          setState(() {});
        }
      },
      child: Container(
        height: this.size.height * 0.075,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 15),
        color: (this.mifoto != null && !this.painterController.isEmpty)
            ? Colors.blue
            : Colors.green,
        child: this.cargando
            ? spinner()
            : (this.mifoto != null && this.firma)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.camera_alt, color: Colors.white),
                      // SizedBox(width: 10),
                      Text(
                        'Continuar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Tomar foto',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
      ),
    );
  }

  InkWell btnBorrarFirma() {
    return InkWell(
      onTap: () {
        this.painterController.clear();
        this.firma = false;
        setState(() {});
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[200], Colors.grey[300]],
            ),
          ),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.eraser, color: Colors.red),
              SizedBox(width: 5),
              Text('Firma'),
            ],
          )),
    );
    // return InkWell(
    //   onTap: () {
    //     if (!this.painterController.isEmpty) this.firma = true;
    //     setState(() {});
    //   },
    //   child: Container(
    //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //       decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(color: Colors.grey, blurRadius: 0.5),
    //         ],
    //         gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [Colors.grey[100], Colors.grey[300]],
    //         ),
    //       ),
    //       child: Row(
    //         children: [
    //           Icon(FontAwesomeIcons.check, color: Colors.green),
    //           SizedBox(width: 5),
    //           Text('Firma'),
    //         ],
    //       )),
    // );
  }

  InkWell btnHistorial() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistorialPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100], Colors.grey[300]],
          ),
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.history, color: Colors.grey[800]),
            SizedBox(width: 5),
            Text('Historial'),
          ],
        ),
      ),
    );
  }

  InkWell btnCambiarCamara() {
    return InkWell(
      onTap: () {
        // this.cambiarCamara = !this.cambiarCamara;
        // setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100], Colors.grey[300]],
          ),
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.syncAlt, color: Colors.blue),
            SizedBox(width: 5),
            Text('Cámara'),
          ],
        ),
      ),
    );
  }

  InkWell btnBorrarFoto() {
    return InkWell(
      onTap: () {
        this.mifoto = null;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 0.5)],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[100], Colors.grey[300]],
          ),
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.eraser, color: Colors.red),
            SizedBox(width: 5),
            Text('Foto'),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   this.cameraControllerTrasera?.dispose();
  //   this.painterController?.dispose();
  //   super.dispose();
  // }

  AlertDialog dialogNumControl() {
    return AlertDialog(
      title: Center(child: Text('No. Control')),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        MaterialButton(
          onPressed: () async {
            if (keyForm.currentState.validate()) {
              try {
                String numControl = this.controllerNumber.text;
                if (await pidePermiso(Permission.storage)) {
                  // Directory dir = await crearDirectorio(numControl);
                  // // GUARDAMOS LA FOTO
                  // File fotoSave = File(dir.path + '/foto_$numControl.jpg');
                  // await fotoSave.writeAsBytes(await this.mifoto.readAsBytes());
                  // // GUARDAMOS LA FIRMA
                  // PictureDetails firmaDetalle = this.painterController.finish();
                  // Uint8List data = await firmaDetalle.toPNG();
                  // File firmaSave = File(dir.path + '/firma_$numControl.png');
                  // firmaSave.writeAsBytesSync(data.toList());
                  // this.db.guardarNuevoNumero(numControl);
                  // this.keyForm.currentState.reset();
                  // this.mifoto = null;
                  // this.painterController.clear();

                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HistorialPage(),
                  //   ),
                  // );
                }
              } catch (e) {
                snack(e.toString(), Colors.red, keyScaff);
                Navigator.pop(context);
              }
            }
          },
          color: Colors.blue,
          child: Text(
            'Continuar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      content: Form(
        key: keyForm,
        child: TextFormField(
          controller: controllerNumber,
          autofocus: true,
          keyboardType: TextInputType.number,
          maxLength: 8,
          validator: (String val) {
            if (val.length < 8 || val.length > 8) return 'Número invalido';
          },
        ),
      ),
    );
  }
}
