import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LensPage extends StatefulWidget {
  const LensPage({super.key});

  @override
  State createState() => _LensPageState();
}

class _LensPageState extends State<LensPage> {
  CameraDescription? camera;
  CameraController? cameraController;
  bool cameraInited = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(initStateAsync);
  }

  void initStateAsync(Duration _) async {
    final cameras = await availableCameras();
    camera = cameras.first;
    cameraController = CameraController(camera!, ResolutionPreset.ultraHigh,
        enableAudio: false);
    await cameraController!.initialize();
    cameraInited = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: cameraInited
              ? CameraPreview(cameraController!)
              : const CircularProgressIndicator(),
        ),
        Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 52,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(children: const [
                SizedBox(width: 20),
                Icon(Icons.camera_sharp),
                SizedBox(width: 5),
                Text('8',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Spacer(),
                Icon(Icons.flashlight_on_outlined),
                SizedBox(width: 20),
                Icon(Icons.help_outline),
                SizedBox(width: 20),
              ]),
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 130,
          child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      onPressed: () {},
                      color: const Color(0x2D909090),
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.photo_camera_back,
                        color: Color(0x6D000000),
                        size: 30,
                      ),
                    ),
                    Material(
                        //Wrap with Material
                        shape: const CircleBorder(),
                        color: const Color(0xFF8B8B8B),
                        child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: MaterialButton(
                              elevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              onPressed: () {},
                              color: Colors.white.withAlpha(230),
                              padding: const EdgeInsets.all(20),
                              shape: const CircleBorder(),
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                              ),
                            ))),
                    MaterialButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      onPressed: () {},
                      color: const Color(0x2D909090),
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.sync,
                        color: Color(0x6D000000),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
