import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:logs/data/cameras.dart';
import 'package:logs/data/colors.dart';
import 'package:logs/data/widgets.dart';
import 'package:logs/pages/historial.dart';
import 'package:logs/providers/appstate.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PainterController painterController = PainterController();
  TextEditingController controllerNumber = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> keyScaff = GlobalKey<ScaffoldState>();
  CameraController cameraControllerTrasera;
  bool cargando = false;
  AppState state;
  Size size;

  bool listo = false;
  bool firma = false;
  bool foto = false;
  XFile mifoto;
  double bott;

  @override
  void initState() {
    super.initState();
    this.painterController.thickness = 3.0;
    this.painterController.backgroundColor = Colors.transparent;

    this.cameraControllerTrasera =
        CameraController(cameras[1], ResolutionPreset.low, enableAudio: false);

    cameraControllerTrasera.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    painterController.dispose();
    controllerNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.state = Provider.of<AppState>(context, listen: true);
    this.size = MediaQuery.of(context).size;
    this.bott = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: keyScaff,
      appBar: AppBar(title: Text('CredenciApp'), centerTitle: true),
      body: Column(children: [camara(), pizarron(), botones(), boton()]),
    );
  }

  Widget botones() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // this.painterController.isEmpty ? btnGuardarFirma() :
          btnBorrarFirma(),
          // this.mifoto == null ? btnTomarFoto() :
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
    return bott > 0
        ? SizedBox()
        : Expanded(
            child: Container(
              width: this.size.width,
              child: (this.mifoto != null)
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Center(child: getImageCache()
                          // Image.memory(await this.mifoto.readAsBytes() ,
                          //     errorBuilder: (_, obj, stac) => Text('error'),
                          //     fit: BoxFit.fitWidth),
                          ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: !cameraControllerTrasera.value.isInitialized
                          ? spinner()
                          : Center(
                              child: CameraPreview(cameraControllerTrasera)),
                    ),
            ),
          );
  }

  Widget boton() {
    // BOTON GUARDAR FOTO
    if (this.mifoto == null) {
      return InkWell(
        onTap: () async {
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
          color: primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Tomar foto',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }
    if (this.painterController.isEmpty) {
      return InkWell(
        onTap: () async {
          this.firma = true;
          setState(() {});
        },
        child: Container(
          height: this.size.height * 0.075,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 15),
          color: primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Guardar firma',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }
    if (this.mifoto != null && !this.painterController.isEmpty)
      return InkWell(
        onTap: () async {
          if (this.mifoto != null && this.firma) {
            return showDialog(
              context: context,
              builder: (context) => dialogNumControl(),
            );
          }
        },
        child: Container(
            height: this.size.height * 0.075,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 15),
            color: Colors.blue,
            child: Row(
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
            )),
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
  }

  InkWell btnGuardarFirma() {
    return InkWell(
      onTap: () {
        if (!this.painterController.isEmpty) this.firma = true;
        setState(() {});
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 0.5),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey[100], Colors.grey[300]],
            ),
          ),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.check, color: Colors.green),
              SizedBox(width: 5),
              Text('Firma'),
            ],
          )),
    );
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

  void voltearCamara() {
    try {
      if (cameraControllerTrasera.description.name == '0') {
        CameraController _camera = CameraController(
            cameras[1], ResolutionPreset.low,
            enableAudio: false);
        this.cameraControllerTrasera = _camera;
        // _camera.dispose();
      } else {
        CameraController _camera = CameraController(
            cameras[0], ResolutionPreset.low,
            enableAudio: false);
        this.cameraControllerTrasera = _camera;
        // _camera.dispose();
      }

      cameraControllerTrasera.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });

      setState(() {});
    } catch (e) {
      print('ERRORR AL CAMBIAR LA CAMARA?');
      print(e);
    }
  }

  InkWell btnCambiarCamara() {
    return InkWell(
      onTap: voltearCamara,
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
              bool res = await this.state.saveNewAlumno(
                  this.controllerNumber.text,
                  this.painterController.finish(),
                  this.mifoto);

              if (res) {
                this.mifoto = null;
                resetPizarron();
                this.keyForm.currentState.reset();
                // snack('TODO GOOD', Colors.blue, keyScaff);
                setState(() {});
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialPage(),
                  ),
                );
              } else {
                snack('Algo salió mal', Colors.red, keyScaff);
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

  btnTomarFoto() {
    return InkWell(
      onTap: () async {
        this.cargando = true;
        setState(() {});
        this.mifoto = await cameraControllerTrasera.takePicture();
        this.cargando = false;
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
            Icon(FontAwesomeIcons.check, color: Colors.green),
            SizedBox(width: 5),
            Text('Foto'),
          ],
        ),
      ),
    );
  }

  void resetPizarron() {
    try {
      if (!this.painterController.isFinished()) {
        print('AUN NO ESTA FINALIZADO?');
        this.painterController.clear();
      } else {
        print('ya esta finalizado?');
        this.painterController = new PainterController();
        this.painterController.thickness = 3.0;
        this.painterController.backgroundColor = Colors.transparent;
      }
    } catch (e) {
      print('ERRORR?');
      print(e);
    }
  }

  Widget getImageCache() {
    return FutureBuilder(
      future: this.mifoto.readAsBytes(),
      builder: (_, AsyncSnapshot<Uint8List> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return spinner();
          case ConnectionState.done:
            try {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Image.memory(snap.data),
                color: Colors.white,
              );
            } catch (e) {
              print(e);
              return Text('No encontramos las fotos');
            }
            break;
          default:
            return Text('No encontramos las fotos');
        }
      },
    );
  }
}
