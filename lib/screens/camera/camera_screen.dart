import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoey/screens/camera/camera_widgets/camera_control_widget.dart';
import 'package:todoey/screens/camera/camera_widgets/camera_preview_widget.dart';
import 'package:todoey/services/location.dart';
import 'package:todoey/services/database.dart';

class CameraScreen extends StatefulWidget {
  final Function cameraCallback;
  CameraScreen({this.cameraCallback});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List _cameras;
  int _selectedCameraIdx;
  Location locationService = Location();
  DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      _cameras = availableCameras;
      if (_cameras.length > 0) {
        setState(() {
          _selectedCameraIdx = 0;
        });
        _initCameraController(_cameras[_selectedCameraIdx]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_controller.value.hasError) {
        print('Camera error');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }

  void onCapture(context) async {
    try {
      final p = await getTemporaryDirectory();
      final name = DateTime.now();
      final path = "${p.path}/$name.png";
      await locationService.setCurrentLocation().then((value) async =>
          await _controller.takePicture(path).then((value) async {
            widget.cameraCallback(
              path: path,
              location: locationService.location,
            );
            Navigator.pop(context);
          }));
    } catch (e) {
      print(e);
    }
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    _selectedCameraIdx =
        _selectedCameraIdx < _cameras.length - 1 ? _selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraPreviewWidget(
          controller: _controller,
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            CameraControlWidget(
              onCaptureCallback: onCapture,
            ),
            _cameraTogglesRowWidget(),
          ],
        ),
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  Widget _cameraTogglesRowWidget() {
    if (_cameras == null || _cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: FloatingActionButton(
            heroTag: 'btn2',
            child: Icon(
              _getCameraLensIcon(lensDirection),
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              _onSwitchCamera();
            }),
      ),
    );
  }
}
