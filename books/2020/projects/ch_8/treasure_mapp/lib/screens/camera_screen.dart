import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/place.dart';
import 'picture_screen.dart';

class CameraScreen extends StatefulWidget {
  final Place place;

  CameraScreen(this.place);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Place place;
  CameraController _controller;
  List<CameraDescription> cameras;
  CameraDescription camera;
  Widget cameraPreview;
  //Image image;

  @override
  void initState() {
    // Call setCamera and when the async method returns
    setCamera().then((_) {
      // create a new CameraController passing the specific camera we will
      // use for this controller and defining the resolution to use
      _controller = CameraController(
        // Get a specific camera from the list of available cameras
        camera,
        // Define the resolution to use
        ResolutionPreset.medium,
      );

      // call the async method initialize for the CameraController
      _controller.initialize().then((snapshot) {
        cameraPreview = Center(child: CameraPreview(_controller));
        // call the setState method to set the cameraPreview widget to a
        // CameraPreview widget of the controller
        setState(() => cameraPreview = cameraPreview);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              // Attempt to take a picture and log where it's been saved
              final image = await _controller.takePicture();

              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => PictureScreen(image.path, place),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Container(
        child: cameraPreview,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Sets the camera to be the first camera on the device (which is
  // generally the main one), on the back of the device
  Future setCamera() async {
    cameras = await availableCameras();
    if (cameras.length != 0) camera = cameras.first;
  }
}
