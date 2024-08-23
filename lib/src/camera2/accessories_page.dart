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
import 'package:smart_mirror/src/camera2/camera_video_page.dart';
import 'package:smart_mirror/src/camera2/eyes/eyebrows_view.dart';
import 'package:smart_mirror/src/camera2/eyes/eyeliner_view.dart';
import 'package:smart_mirror/src/camera2/eyes/eyeshadow_view.dart';
import 'package:smart_mirror/src/camera2/eyes/lashes_mascara_view.dart';
import 'package:smart_mirror/src/camera2/eyes/lenses_view.dart';
import 'package:smart_mirror/src/camera2/face/blusher_view.dart';
import 'package:smart_mirror/src/camera2/face/bronzer_view.dart';
import 'package:smart_mirror/src/camera2/face/concealer_view.dart';
import 'package:smart_mirror/src/camera2/face/contour_view.dart';
import 'package:smart_mirror/src/camera2/face/foundation_view.dart';
import 'package:smart_mirror/src/camera2/face/highlighter_view.dart';
import 'package:smart_mirror/src/camera2/hair/hair_view.dart';
import 'package:smart_mirror/src/camera2/lips/lip_color_view.dart';
import 'package:smart_mirror/src/camera2/lips/lip_liner_view.dart';
import 'package:smart_mirror/src/camera2/lips/lip_plumber_view.dart';
import 'package:smart_mirror/src/camera2/nails/nail_polish_view.dart';
import 'package:smart_mirror/src/camera2/nails/presonnails_view.dart';
import 'package:smart_mirror/utils/utils.dart';

const xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);

class AccessoriesPage extends StatefulWidget {
  const AccessoriesPage({super.key});

  @override
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  late CameraController controller;
  Completer<String?> cameraSetupCompleter = Completer();
  Completer? isFlippingCamera;
  late List<Permission> permissions;
  bool isRearCamera = true;
  bool isFlipCameraSupported = false;
  File? file;
  bool lipsClick = false;
  bool eyesClick = false;
  bool faceClick = false;
  bool nailsClick = false;
  bool hairClick = false;

  List<String> lipsType = ['Lip Color', 'Lip Liner', 'Lip Plumper'];
  List<String> eyesType = [
    'Eyebrows',
    'Eye Shadow',
    'Eye Liner',
    'Lenses',
    'EyeLashes'
  ];

  List<String> faceType = [
    'Foundation',
    'Concealar',
    'Contour',
    'Blusher',
    'Bronzer',
    'Highlighter'
  ];
  List<String> nailsType = [
    'Nail Polish',
    'Press-on Nails',
  ];
  List<String> hairType = [
    'Hair Color',
  ];

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

  clearAll() {
    lipsClick = false;
    eyesClick = false;
    faceClick = false;
    nailsClick = false;
    hairClick = false;
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

  Widget makeupOrAccessoriesChoice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'Make Up',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'Accessories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget separator() {
    return Divider(thickness: 1, color: Colors.white);
  }

  Widget itemMakeup(String path, GestureTapCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(path, width: 42, height: 56),
    );
  }

  Widget lipsItem(String type, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          type,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget lipsList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: lipsType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return lipsItem(lipsType[index], () {
              if (index == 0) CusNav.nPush(context, LipColorView());
              if (index == 1) CusNav.nPush(context, LipLinerView());
              if (index == 2) CusNav.nPush(context, LipPlumberView());
            });
          },
        ),
      ),
    );
  }

  Widget eyesItem(String type, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          type,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget eyesList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: eyesType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return eyesItem(eyesType[index], () {
              if (index == 0) CusNav.nPush(context, EyebrowsView());
              if (index == 1) CusNav.nPush(context, EyeshadowView());
              if (index == 2) CusNav.nPush(context, EyelinerView());
              if (index == 3) CusNav.nPush(context, LensesView());
              if (index == 4)
                CusNav.nPush(context, LashesMascaraView(lashes: false));
            });
          },
        ),
      ),
    );
  }

  Widget faceItem(String type, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          type,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget faceList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: faceType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return faceItem(faceType[index], () {
              if (index == 0) CusNav.nPush(context, FoundationView());
              if (index == 1) CusNav.nPush(context, ConcealerView());
              if (index == 2) CusNav.nPush(context, ContourView());
              if (index == 3) CusNav.nPush(context, BlusherView());
              if (index == 4) CusNav.nPush(context, BronzerView());
              if (index == 5) CusNav.nPush(context, HighlighterView());
            });
          },
        ),
      ),
    );
  }

  Widget nailsItem(String type, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          type,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget nailsList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: nailsType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return nailsItem(nailsType[index], () {
              if (index == 0) CusNav.nPush(context, NailPolishView());
              if (index == 1) CusNav.nPush(context, PresOnNailsView());
            });
          },
        ),
      ),
    );
  }

  Widget hairItem(String type, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          type,
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget hairList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: hairType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return hairItem(hairType[index], () {
              if (index == 0) CusNav.nPush(context, HairView());
            });
          },
        ),
      ),
    );
  }

  Widget sheet() {
    return Container(
      // height: 100,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 55,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          Constant.xSizedBox24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemMakeup(
                  (lipsClick == false
                      ? Assets.iconsIcLips
                      : Assets.iconsIcLipsOn), () {
                setState(() {
                  clearAll();
                  lipsClick = !lipsClick;
                });
              }),
              itemMakeup(
                  eyesClick == false
                      ? Assets.iconsIcEyes
                      : Assets.iconsIcEyesOn, () {
                setState(() {
                  clearAll();
                  eyesClick = !eyesClick;
                });
              }),
              itemMakeup(
                  faceClick == false
                      ? Assets.iconsIcFace
                      : Assets.iconsIcFaceOn, () {
                setState(() {
                  clearAll();
                  faceClick = !faceClick;
                });
              }),
              itemMakeup(
                  nailsClick == false
                      ? Assets.iconsIcNails
                      : Assets.iconsIcNailsOn, () {
                setState(() {
                  clearAll();
                  nailsClick = !nailsClick;
                });
              }),
              itemMakeup(
                  hairClick == false
                      ? Assets.iconsIcHair
                      : Assets.iconsIcHairOn, () {
                setState(() {
                  clearAll();
                  hairClick = !hairClick;
                });
              }),
            ],
          ),
          Constant.xSizedBox8,
          Constant.xSizedBox8,
          if (lipsClick) lipsList(),
          if (eyesClick) eyesList(),
          if (faceClick) faceList(),
          if (nailsClick) nailsList(),
          if (hairClick) hairList(),
          Constant.xSizedBox12,
        ],
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
          onTap: () => Navigator.pop(context),
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
                                        // makeupOrAccessories = true;
                                      });
                                    }, Assets.iconsIcCompare),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                            () async {}, Assets.iconsIcReset),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                            () async {}, Assets.iconsIcChoose),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                            () async {}, Assets.iconsIcShare),
                                  ],
                                ),
                              ),
                            ),
                            Constant.xSizedBox16,
                            sheet(),
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


