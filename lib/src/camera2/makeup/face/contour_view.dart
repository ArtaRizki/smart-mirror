import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_mirror/common/component/custom_navigator.dart';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:smart_mirror/generated/assets.dart';
import 'package:smart_mirror/src/camera2/camera_page2.dart';
import 'package:smart_mirror/src/camera2/camera_video_page.dart';
import 'package:smart_mirror/src/camera2/makeup/face/highlighter_view.dart';
import 'package:smart_mirror/src/camera2/makeup_page.dart';
import 'package:smart_mirror/utils/utils.dart';

const xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);

class ContourView extends StatefulWidget {
  const ContourView({super.key});

  @override
  State<ContourView> createState() => _ContourViewState();
}

class _ContourViewState extends State<ContourView> {
  late CameraController controller;
  Completer<String?> cameraSetupCompleter = Completer();
  Completer? isFlippingCamera;
  late List<Permission> permissions;
  bool isRearCamera = true;
  bool isFlipCameraSupported = false;
  File? file;
  bool makeupOrAccessories = false;
  bool oneOrDual = false;
  bool onOffVisibel = false;
  bool onOffVisibel1 = false;
  int? skinSelected = 0;
  int? colorSelected = 0;

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
            // Permission.storage
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
                      'Mohon izinkan untuk mengakses Kamera dan Mikrofon');
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
      //   // Permission.storage
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
      //               'Mohon izinkan untuk mengakses Kamera dan Mikrofon');
      //           Navigator.of(context).pop();
      //         }
      //       });
      //     });
      //   }
      // });
    }
  }

  List<String> skinList = [
    "Light skin",
    "Medium skin",
    "Dark skin",
  ];
  List<Color> skinColorList = [
    Color(0xFFFDD8B7),
    Color(0xFFD08A59),
    Color(0xFF45260D),
  ];
  List<Color> colorChoiceList = [
    Color(0xFF3D2B1F),
    Color(0xFF5C4033),
    Color(0xFF694B3A),
    Color(0xFF8A4513),
    Color(0xFF7A3F00),
    Color(0xFF4F300D),
    Color(0xFF483C32),
    Color(0xFF342112),
    Color(0xFF4A2912),
  ];
  List<String> bronzerList = [
    Assets.imagesImgBronzer,
    Assets.imagesImgBronzer1,
    Assets.imagesImgBronzer2,
    Assets.imagesImgBronzer3,
    Assets.imagesImgBronzer4,
  ];

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

  Widget pictureTaken() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Edit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Constant.xSizedBox24,
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xffCA9C43),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Share',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Constant.xSizedBox16,
                    Icon(Icons.share_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noPictureTaken() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  controller.takePicture().then((imageFile) async {
                    // File tmp = await compressImage(
                    //     File(imageFile.path));
                    file = File(imageFile.path);
                    // if (controller
                    //     .value.isPreviewPaused)
                    //   await controller.resumePreview();
                    // else
                    await controller.pausePreview();
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      width: 60,
                      height: 60,
                    ),
                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Visibility(
                visible: isFlipCameraSupported,
                child: InkWell(
                  onTap: () async {
                    ///[Flip Camera]
                    if (isFlippingCamera == null ||
                        isFlippingCamera!.isCompleted) {
                      isFlippingCamera = Completer();
                      isFlippingCamera!.complete(
                          await availableCameras().then((value) async {
                        for (var camera in value) {
                          if (camera.lensDirection ==
                              (controller.description.lensDirection ==
                                      CameraLensDirection.front
                                  ? CameraLensDirection.back
                                  : CameraLensDirection.front)) {
                            await controller.dispose();
                            cameraSetupCompleter = Completer();

                            await _initCamera(camera: camera);
                            setState(() {});
                            break;
                          }
                        }

                        await Future.delayed(
                            const Duration(seconds: 1, milliseconds: 500));
                      }));
                    } else {
                      print('Not completed!');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 35,
                    height: 35,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black26),
                    child: Icon(Icons.autorenew_rounded, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorChip() {
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: skinList.length,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: index == 0 ? Colors.white : Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 8, backgroundColor: skinColorList[index]),
                Constant.xSizedBox4,
                Text(
                  skinList[index],
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget colorChoice() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: colorChoiceList.length,
          separatorBuilder: (_, __) => Constant.xSizedBox12,
          itemBuilder: (context, index) {
            if (index == 0)
              return InkWell(
                onTap: () async {
                  setState(() {
                    colorSelected = 0;
                    onOffVisibel = true;
                  });
                },
                child: Icon(Icons.do_not_disturb_alt_sharp,
                    color: Colors.white, size: 25),
              );
            return InkWell(
                onTap: () async {
                  setState(() {
                    colorSelected = index;
                    onOffVisibel = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: index == colorSelected && onOffVisibel == false
                            ? Colors.white
                            : Colors.transparent),
                  ),
                  child: CircleAvatar(
                      radius: 12, backgroundColor: colorChoiceList[index]),
                ));
          },
        ),
      ),
    );
  }

  Widget bronzerChoice() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 55,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: oneOrDual == false ? bronzerList.length : 1,
          separatorBuilder: (_, __) => Constant.xSizedBox12,
          itemBuilder: (context, index) {
            // if (index == 0)
            //   return InkWell(
            //     onTap: () async {},
            //     child: Icon(Icons.do_not_disturb_alt_sharp,
            //         color: Colors.white, size: 25),
            //   );
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: index == skinSelected && onOffVisibel1 == false
                        ? Colors.white
                        : Colors.transparent),
              ),
              child: InkWell(
                  onTap: () async {
                    setState(() {
                      skinSelected = index;
                      onOffVisibel1 = false;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.asset(bronzerList[index]),
                      ),
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget lipstickChoice() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 150,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (_, __) => Constant.xSizedBox12,
          itemBuilder: (context, index) {
            // if (index == 0)
            //   return InkWell(
            //     onTap: () async {},
            //     child: Icon(Icons.do_not_disturb_alt_sharp,
            //         color: Colors.white, size: 25),
            //   );
            return InkWell(
                onTap: () async {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 15, 10),
                      color: Colors.white,
                      width: 120,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 9,
                              child: Image.asset(Assets.imagesImgLipstick)),
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                                size: 18,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Item name Tom Ford",
                      style: Constant.whiteBold16.copyWith(fontSize: 12),
                    ),
                    Text(
                      "Brand name",
                      style: Constant.whiteRegular12
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                    Row(
                      children: [
                        Text("\$15", style: Constant.whiteRegular12),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: Color(0xFFC89A44),
                          child: Center(
                              child: Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          )),
                        )
                      ],
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget separator() {
    return Divider(thickness: 1, color: Colors.white);
  }

  Widget typeChip() {
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Text(
                'Sheer',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget typeText() {
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              'Ombre',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                shadows: index != 0
                    ? null
                    : [
                        BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.white,
                          spreadRadius: 0,
                          blurRadius: 10,
                        ),
                      ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget sheet() {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Constant.xSizedBox8,
            // colorChip(),
            colorChoice(),
            Constant.xSizedBox8,
            separator(),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        oneOrDual = true;
                      });
                    },
                    child: Text(
                      "One",
                      style: oneOrDual == true
                          ? Constant.whiteBold16.copyWith(fontSize: 12)
                          : Constant.whiteRegular12,
                    )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        oneOrDual = false;
                      });
                    },
                    child: Text(
                      "Two",
                      style: oneOrDual == false
                          ? Constant.whiteBold16.copyWith(fontSize: 12)
                          : Constant.whiteRegular12,
                    )),
              ],
            ),
            separator(),
            bronzerChoice(),
            Constant.xSizedBox4,
            separator(),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "View All",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
            Constant.xSizedBox4,
            lipstickChoice(),
            // Constant.xSizedBox8,
          ],
        ),
      ),
    );
  }

  Widget cameraPreview(double scale) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: CameraPreview(controller),
      ),
    );
  }

  Widget iconSidebar(GestureTapCallback? onTap, String path) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        path,
        width: 24,
        height: 24,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        // toolbarHeight: 0,
        leadingWidth: 84,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            CusNav.nPop(context);
            CusNav.nPushReplace(context, OcrCameraPage2(makeUpOn: true));
          },
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            // padding: EdgeInsets.all(8),
            // width: 64,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.black26),
            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              // padding: EdgeInsets.only(right: 16, left: 16),
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black26),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<String?>(
        future: cameraSetupCompleter.future,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState != ConnectionState.done;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.data != null) {
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Setup Camera Failed'),
                Text(
                  snapshot.data!,
                  style: const TextStyle(
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
                    cameraPreview(scale),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        // margin: xHEdgeInsets12
                        //     .add(const EdgeInsets.only(bottom: 12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 16),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    iconSidebar(() async {
                                      CusNav.nPush(context, CameraVideoPage());
                                    }, Assets.iconsIcCamera),
                                    Constant.xSizedBox12,
                                    iconSidebar(() async {
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

                                              await _initCamera(camera: camera);
                                              setState(() {});
                                              break;
                                            }
                                          }

                                          await Future.delayed(const Duration(
                                              seconds: 1, milliseconds: 500));
                                        }));
                                      } else {
                                        print('Not completed!');
                                      }
                                    }, Assets.iconsIcFlipCamera),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                        () async {}, Assets.iconsIcScale),
                                    Constant.xSizedBox12,
                                    iconSidebar(() async {
                                      setState(() {
                                        makeupOrAccessories = true;
                                      });
                                    }, Assets.iconsIcCompareOff),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                        () async {}, Assets.iconsIcResetOff),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                        () async {}, Assets.iconsIcChoose),
                                    Constant.xSizedBox12,
                                    iconSidebar(() async {
                                      CusNav.nPush(context, HighlighterView());
                                    }, Assets.iconsIcShare),
                                  ],
                                ),
                              ),
                            ),
                            Constant.xSizedBox16,
                            sheet(),
                            // file != null ? pictureTaken() : noPictureTaken(),
                            // pictureTaken(),
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
