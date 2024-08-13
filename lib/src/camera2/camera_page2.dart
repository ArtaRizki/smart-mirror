import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart-mirror/common/helper/constant.dart';
import 'package:smart-mirror/utils/utils.dart';

import 'image_processor.dart';

const xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);

class OcrCameraPage2 extends StatefulWidget {
  const OcrCameraPage2({Key? key}) : super(key: key);

  @override
  State<OcrCameraPage2> createState() => _OcrCameraPage2State();
}

class _OcrCameraPage2State extends State<OcrCameraPage2> {
  late CameraController controller;
  Completer<String?> cameraSetupCompleter = Completer();
  Completer? isFlippingCamera;
  late List<Permission> permissions;
  bool isRearCamera = true;
  bool isFlipCameraSupported = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((value) {
        if (value.version.sdkInt >= 32) {
          permissions = [
            Permission.camera,
            Permission.microphone,
          ];
        } else {
          permissions = [
            Permission.camera,
            Permission.microphone,
            Permission.storage
          ];
        }
      }).then((value) {
        // _initCamera();
        checkPermissionStatuses().then((allclear) {
          if (allclear) {
            _initCamera();
          } else {
            permissions.request().then((value) {
              checkPermissionStatuses().then((allclear) {
                if (allclear) {
                  _initCamera();
                } else {
                  Utils.showToast(
                      'Mohon izinkan Janissari untuk mengakses Kamera dan Mikrofon');
                  Navigator.of(context).pop();
                }
              });
            });
          }
        });
      });
    } else {
      _initCamera();
      // permissions = [
      //   Permission.camera,
      //   Permission.microphone,
      //   Permission.storage
      // ];
      // checkPermissionStatuses().then((allclear) {
      //   if (allclear) {
      //     _initCamera();
      //   } else {
      //     permissions.request().then((value) {
      //       checkPermissionStatuses().then((allclear) {
      //         if (allclear) {
      //           _initCamera();
      //         } else {
      //           Utils.showToast(
      //               'Mohon izinkan Janissari untuk mengakses Kamera dan Mikrofon');
      //           Navigator.of(context).pop();
      //         }
      //       });
      //     });
      //   }
      // });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (cameraSetupCompleter.isCompleted) {
      controller.dispose();
    }
  }

  Future<bool> checkPermissionStatuses() async {
    for (var permission in permissions) {
      if (await permission.status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> _initCamera({CameraDescription? camera}) async {
    Future<void> selectCamera(CameraDescription camera) async {
      controller = CameraController(camera, ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg);
      await controller.initialize();
      cameraSetupCompleter.complete();
    }

    if (camera != null) {
      selectCamera(camera);
    } else {
      await availableCameras().then((value) async {
        isFlipCameraSupported = value.indexWhere((element) =>
                element.lensDirection == CameraLensDirection.front) !=
            -1;

        for (var camera in value) {
          if (camera.lensDirection == CameraLensDirection.back) {
            await selectCamera(camera);
            return;
          }
        }

        cameraSetupCompleter
            .complete("Tidak dapat menemukan kamera yang cocok.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // toolbarHeight: 0,
        leadingWidth: 84,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.only(top: 8),
            // padding: EdgeInsets.all(8),
            // width: 64,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black26),
            child: Icon(
              Platform.isAndroid
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<String?>(
        future: cameraSetupCompleter.future,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState != ConnectionState.done;

          if (isLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.data != null) {
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Setup Camera Failed'),
                Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ));
          } else {
            return LayoutBuilder(
              builder: (p0, p1) {
                final width = p1.maxWidth;
                final height = p1.maxHeight;

                late double scale;

                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  final screenRatio = width / height;
                  final cameraRatio = controller.value.aspectRatio;
                  scale = 1 / (cameraRatio * screenRatio);
                } else {
                  final screenRatio = (height) / width;
                  final cameraRatio = controller.value.aspectRatio;
                  scale = 1 / (cameraRatio * screenRatio);
                }

                return Stack(
                  children: [
                    Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: Container(
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: CameraPreview(
                            controller,
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: xHEdgeInsets12.add(EdgeInsets.only(bottom: 12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: isFlipCameraSupported,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Card(
                                    shape: CircleBorder(),
                                    color: Colors.blue,
                                    margin: EdgeInsets.only(bottom: 24),
                                    child: IconButton(
                                      icon: Icon(controller
                                                  .description.lensDirection ==
                                              CameraLensDirection.front
                                          ? Icons.camera_rear
                                          : Icons.camera_front),
                                      color: Colors.white,
                                      onPressed: () async {
                                        ///[Flip Camera]
                                        if (isFlippingCamera == null ||
                                            isFlippingCamera!.isCompleted) {
                                          isFlippingCamera = Completer();
                                          isFlippingCamera!.complete(
                                              await availableCameras()
                                                  .then((value) async {
                                            for (var camera in value) {
                                              if (camera.lensDirection ==
                                                  (controller.description
                                                              .lensDirection ==
                                                          CameraLensDirection
                                                              .front
                                                      ? CameraLensDirection.back
                                                      : CameraLensDirection
                                                          .front)) {
                                                await controller.dispose();
                                                cameraSetupCompleter =
                                                    Completer();

                                                await _initCamera(
                                                    camera: camera);
                                                setState(() {});
                                                break;
                                              }
                                            }

                                            await Future.delayed(Duration(
                                                seconds: 1, milliseconds: 500));
                                          }));
                                        } else {
                                          print('Not completed!');
                                        }
                                      },
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                  shape: CircleBorder(),
                                  color: Constant.primaryColor,
                                  margin: EdgeInsets.only(bottom: 24),
                                  child: IconButton(
                                    icon: controller.value.flashMode !=
                                            FlashMode.off
                                        ? Icon(Icons.flash_auto)
                                        : Icon(Icons.flash_off),
                                    color: Colors.white,
                                    onPressed: () {
                                      controller
                                          .setFlashMode(
                                              controller.value.flashMode !=
                                                      FlashMode.off
                                                  ? FlashMode.off
                                                  : FlashMode.auto)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                  )),
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    controller
                                        .takePicture()
                                        .then((imageFile) async {
                                      // File tmp = await compressImage(
                                      //     File(imageFile.path));

                                      await controller.pausePreview();
                                      Navigator.pop(context, imageFile);
                                      // Navigator.pop(context, tmp);
                                    });
                                  },
                                  child: Text('Ambil Foto')),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
