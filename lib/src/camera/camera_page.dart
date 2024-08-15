import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:smart_mirror/utils/utils.dart';

class CameraPage extends StatefulWidget {
  late List<CameraDescription> cameras;
  final delay = const Duration(milliseconds: 700);
  final Future Function(String) onResult;
  final bool isUseFaceDetection;
  CameraPage(
      {super.key, required this.onResult, required this.isUseFaceDetection});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  late Completer<CameraController> cController = Completer();
  bool controllerAssigned = false;
  late CameraDescription selectedCamera;
  bool isScanSuccess = false;
  bool isSoundEnabled = true;
  CameraLensDirection lensDirection = CameraLensDirection.front;
  bool isReadyToProcessImage = true;

  Color get mainColor => Constant.primaryColor;
  BorderRadius get cardRadius => BorderRadius.circular(4);
  bool isFaceDetected = false;

  Completer isReadyToCapture = Completer<bool>();
  final Future<bool> captureDelay =
      Future.delayed(const Duration(seconds: 1), () => true);
  bool isCapturing = false;

  Toast(String message) {
    return Utils.showToast(message, duration: const Duration(milliseconds: 400));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      CameraDescription? camera = await findCamera(CameraLensDirection.front);
      if (camera != null) {
        onNewCameraSelected(camera).then((value) => setState(() {}));
      } else {
        Toast('Tidak ada kamera yang cocok.');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
// App state changed before we got the chance to initialize.
    if (!cController.isCompleted) {
      return;
    }

    cController.future.then((controller) {
      if (state == AppLifecycleState.inactive) {
        controller.dispose();
      } else if (state == AppLifecycleState.resumed) {
        if (controllerAssigned) {
          findCamera(lensDirection).then((value) {
            if (value == null) {
              Toast('Tidak ada kamera yang cocok.');
            } else {
              cController = Completer();
              onNewCameraSelected(value).then((value) => setState(() {}));
            }
          });
        }
      }
    });
  }

  Future onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cController.isCompleted && widget.isUseFaceDetection) {
      (await cController.future).stopImageStream();
    }

    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controllerAssigned = true;
    selectedCamera = cameraDescription;

    await controller.initialize();
    captureDelay.then((value) {
      isReadyToCapture.complete(value);
    });
    if (!mounted) {
      return;
    }

    if (widget.isUseFaceDetection) {
      controller.startImageStream(_imageStream);
    }
    cController.complete(controller);
  }

  Future<CameraDescription?> findCamera(
      CameraLensDirection lensDirection) async {
    final cameras = await availableCameras();
    for (var value in cameras) {
      if (value.lensDirection == lensDirection) return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    wGuide() {
      return Positioned(
        bottom: 112,
        right: 0,
        left: 0,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/ic_dont_wear_glasses.png',
                    width: 42,
                    height: 42,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/ic_dont_wear_hat.png',
                    width: 42,
                    height: 42,
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/ic_dont_wear_mask.png',
                    width: 42,
                    height: 42,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    wButtonCapture() {
      return StatefulBuilder(
        builder: (context, setState) {
          captureText() {
            return Text(!isFaceDetected && widget.isUseFaceDetection
                ? 'Wajah tidak terdeteksi'
                : 'Ambil foto');
          }

          progress() {
            return const Padding(
              padding: EdgeInsets.all(4),
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 1),
            );
          }

          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 18)
                  .add(EdgeInsets.only(bottom: 32)),
              child: ElevatedButton(
                onPressed: () async {
                  if ((!isFaceDetected && widget.isUseFaceDetection) ||
                      isCapturing) {
                    return;
                  }

                  setState(() => isCapturing = true);
                  Toast('Sedang mengambil foto..');
                  await cController.future.then((value) async {
                    if (!isReadyToCapture.isCompleted) {
                      return;
                    }
                    if (widget.isUseFaceDetection) {
                      await value.stopImageStream();
                    }
                    dynamic result;
                    try {
                      await Future.delayed(const Duration(milliseconds: 500));
                      result = await value.takePicture();
                    } catch (e) {
                      result = await value.takePicture();
                    }
                    Navigator.of(context).pop(result);
                  });
                  setState(() => isCapturing = false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !isFaceDetected && widget.isUseFaceDetection
                            ? Colors.red
                            : Constant.primaryColor),
                child: isCapturing ? progress() : captureText(),
              ),
            ),
          );
        },
      );
    }

    return FutureBuilder<CameraController>(
      future: cController.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final controller = snapshot.data!;
        final scale = 1 / (controller.value.aspectRatio * deviceRatio);

        var isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        Size mediaSize = MediaQuery.of(context).size;
        return Stack(
          children: [
            SizedBox(
              width: mediaSize.width,
              height: mediaSize.height,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                    width: isPortrait
                        ? controller.value.previewSize!.height
                        : controller.value.previewSize!.width,
                    height: isPortrait
                        ? controller.value.previewSize!.width
                        : controller.value.previewSize!.height,
                    child: CameraPreview(
                      controller,
                    )),
              ),
            ),
            wGuide(),
            wButtonCapture(),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 32, right: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (controllerAssigned) {
      cController.future.then((value) => value.dispose());
    }
    super.dispose();
  }

  _imageStream(CameraImage cameraImage) {
    if (isReadyToProcessImage) {
      isReadyToProcessImage = false;
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done();
      final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      if (Platform.isIOS) {
        ///
      } else {
        final raw = cameraImage.format.raw;
        const MethodChannel(Constant.APP_NAME).invokeMethod('scanforface', [
          bytes.buffer.asUint8List(),
          imageSize.width.toInt(),
          imageSize.height.toInt(),
          selectedCamera.sensorOrientation,
          17,
        ]).then((value) {
          if (value is bool) {
            isReadyToProcessImage = true;
            if (isFaceDetected != value) {
              setState(() {
                isFaceDetected = value;
              });
            }
          }
        });
      }
    }
  }
}
