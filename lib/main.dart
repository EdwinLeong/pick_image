import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  File? _image;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = await saveImage(image.path);
      setState(() {
        // print('What imageTemp here $imageTemp');
        _image = imageTemp;
        // print('What image here $_image');
      });
    } on PlatformException catch (e) {
      print('What the error here $e');
    }
  }

// Save Image in your device
  Future<File> saveImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    print('What directory here =====> $directory');
    final name = basename(imagePath);
    print('What name here =====> $name');
    final image = File('${directory.path}/$name');
    print('What image here =====> $image');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(_image!,
                    width: 250, height: 240, fit: BoxFit.cover)
                : Image.network('https://picsum.photos/250?image=4'),
            const SizedBox(
              height: 40,
            ),
            // ignore: avoid_print
            CustomButton(
                title: 'Pick Image',
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery)),
            CustomButton(
                title: 'Pick From Camera',
                icon: Icons.camera,
                onClick: () => getImage(ImageSource.camera))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onClick})
      : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onClick;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 320,
        child: ElevatedButton(
          onPressed: widget.onClick,
          child: Row(
            children: <Widget>[
              Icon(widget.icon),
              const SizedBox(
                width: 20,
              ),
              Text(widget.title),
            ],
          ),
        ));
  }
}
