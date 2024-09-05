import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_mirror/common/component/custom_button.dart';
import 'package:smart_mirror/common/component/custom_dialog.dart';
import 'package:smart_mirror/common/component/custom_navigator.dart';
import 'package:smart_mirror/common/component/custom_textfield.dart';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:smart_mirror/generated/assets.dart';
import 'package:smart_mirror/src/camera/camera_page.dart';
import 'package:smart_mirror/src/camera2/accessories_page.dart';
import 'package:smart_mirror/src/camera2/camera_video_page.dart';
import 'package:smart_mirror/src/camera2/makeup/eyes/eyebrows_view.dart';
import 'package:smart_mirror/src/camera2/makeup/eyes/eyeliner_view.dart';
import 'package:smart_mirror/src/camera2/makeup/eyes/eyeshadow_view.dart';
import 'package:smart_mirror/src/camera2/makeup/eyes/lashes_mascara_view.dart';
import 'package:smart_mirror/src/camera2/makeup/eyes/lenses_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/blusher_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/bronzer_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/concealer_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/contour_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/foundation_view.dart';
import 'package:smart_mirror/src/camera2/makeup/face/highlighter_view.dart';
import 'package:smart_mirror/src/camera2/makeup/hair/hair_view.dart';
import 'package:smart_mirror/src/camera2/makeup/lips/lip_color_view.dart';
import 'package:smart_mirror/src/camera2/makeup/lips/lip_liner_view.dart';
import 'package:smart_mirror/src/camera2/makeup/lips/lip_plumber_view.dart';
import 'package:smart_mirror/src/camera2/makeup/nails/nail_polish_view.dart';
import 'package:smart_mirror/src/camera2/makeup/nails/presonnails_view.dart';
import 'package:smart_mirror/src/provider/smart_mirror_provider.dart';
import 'package:smart_mirror/utils/utils.dart';

const xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);

class OcrCameraPage2 extends StatefulWidget {
  OcrCameraPage2({super.key, this.makeUpOn, this.accessoriesOn});
  bool? makeUpOn;
  bool? accessoriesOn;

  @override
  State<OcrCameraPage2> createState() => _OcrCameraPage2State();
}

class _OcrCameraPage2State extends State<OcrCameraPage2>
    with WidgetsBindingObserver {
  late CameraController controller;
  Completer<String?> cameraSetupCompleter = Completer();
  Completer? isFlippingCamera;
  late List<Permission> permissions;
  bool isRearCamera = true;
  bool isFlipCameraSupported = false;
  File? file;
  bool onOffVisible = false;
  int? mainColorSelected;
  int? subColorSelected;
  int? colorTextSelected = 0;
  int? typeSelected = 0;
  int? modeSelected = 0;
  bool makeUpOn = true;
  bool accessoriesOn = false;

  @override
  void initState() {
    super.initState();
    makeUpOn = widget.makeUpOn ?? makeUpOn;
    accessoriesOn = widget.accessoriesOn ?? accessoriesOn;
    WidgetsBinding.instance.addObserver(this);
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

  @override
  void dispose() {
    if (cameraSetupCompleter.isCompleted) {
      controller.dispose();
    }

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
      WidgetsBinding.instance.removeObserver(this);
    } else if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addObserver(this);
      _initCamera();
    }
  }

  List<String> textColorList = [
    "Pink",
    "Brown",
    "Orange",
    "Blue",
    "Node",
    "Red",
  ];
  List<String> typeList = [
    "Sheer",
    "Matt",
    "Gloss",
    "Shimmer",
    "Stain",
    "Stain",
  ];
  List<String> modeTextList = [
    "One",
    "Dual",
    "Ombre",
  ];
  List<Color> choiceColorList = [
    Color(0xFFFC3698),
    Color(0xFF3D0B0B),
    Color(0xFFFD5100),
    Color(0xFF1400FD),
    Color(0xFFDEBBA8),
    Color(0xFFFD0000),
  ];
  List<Color> colorChoiceList = [
    Color(0xFF730039),
    Color(0xFF8C0046),
    Color(0xFFB10058),
    Color(0xFFB41F69),
    Color(0xFFDE1050),
    Color(0xFFE21B7A),
    Color(0xFFFC3698),
    Color(0xFFE761A3),
    Color(0xFFDF467B),
  ];
  List<String> highlighterList = [
    Assets.imagesImgHighlighter1,
    Assets.imagesImgHighlighter2,
    Assets.imagesImgHighlighter3,
    Assets.imagesImgHighlighter4,
  ];

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
      if (cameraSetupCompleter.isCompleted) {
        controller.dispose();
      }
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

  void changeModel(BuildContext context) {
    CustomDialog.newDialog(
        context: context,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              "How would you like to try on the makeup?",
              style: Constant.whiteRegular12,
            ),
          ],
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  Assets.imagesImgUpPhoto,
                  scale: 3,
                ),
                Image.asset(
                  Assets.imagesImgUpVideo,
                  scale: 3,
                ),
                Image.asset(
                  Assets.imagesImgModel,
                  scale: 3,
                ),
              ],
            ),
          ),
        ));
  }

  Widget makeupOrAccessoriesChoice() {
    return Container(
      padding: EdgeInsets.all(10),
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
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        makeUpOn = true;
                        accessoriesOn = false;
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        'Make Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: makeUpOn == true
                                ? [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Colors.yellow,
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                    )
                                  ]
                                : null),
                      ),
                    ),
                  ),
                ),
                Constant.xSizedBox12,
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.white,
                ),
                Constant.xSizedBox12,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        accessoriesOn = true;
                        makeUpOn = false;
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        'Accessories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: accessoriesOn == true
                                ? [
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Colors.yellow,
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                    )
                                  ]
                                : null),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          separator(),
          if (makeUpOn == true) MakeupPage(),
          if (accessoriesOn == true) AccessoriesPage(),
          // Center(
          //   child: InkWell(
          //       onTap: () {
          //         setState(() {
          //           makeupOrAccessories = !makeupOrAccessories;
          //         });
          //       },
          //       child: Icon(
          //         Icons.keyboard_arrow_down,
          //         color: Colors.white,
          //       )),
          // ),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: textColorList.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  colorTextSelected = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: index == colorTextSelected
                          ? Colors.white
                          : Colors.transparent),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 8, backgroundColor: choiceColorList[index]),
                    Constant.xSizedBox4,
                    Text(
                      textColorList[index],
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
                    onOffVisible = true;
                  });
                },
                child: Icon(Icons.do_not_disturb_alt_sharp,
                    color: Colors.white, size: 25),
              );
            return InkWell(
                onTap: () async {
                  setState(() {
                    mainColorSelected = index;
                    onOffVisible = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            index == mainColorSelected && onOffVisible == false
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

  Widget separator() {
    return Divider(thickness: 1, color: Colors.white);
  }

  Widget typeChip() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: typeList.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                setState(() {
                  typeSelected = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: index == typeSelected
                          ? Colors.white
                          : Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    typeList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget typeText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: modeTextList.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                setState(() {
                  modeSelected = index;
                });
              },
              child: Center(
                child: Text(
                  modeTextList[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      shadows: index == modeSelected
                          ? [
                              BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.white,
                                spreadRadius: 0,
                                blurRadius: 10,
                              )
                            ]
                          : null),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sheet() {
    return Container(
      // height: 100,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Constant.xSizedBox8,
          colorChip(),
          Constant.xSizedBox8,
          colorChoice(),
          Constant.xSizedBox8,
          separator(),
          Constant.xSizedBox4,
          typeChip(),
          Constant.xSizedBox4,
          separator(),
          typeText(),
          // Center(
          //   child: InkWell(
          //       onTap: () {
          //         setState(() {
          //           // makeupOrAccessories = !makeupOrAccessories;
          //           makeUpOn = false;
          //           accessoriesOn = false;
          //         });
          //       },
          //       child: Icon(
          //         Icons.keyboard_arrow_down,
          //         color: Colors.white,
          //       )),
          // ),
          Constant.xSizedBox8,
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
                                        // makeupOrAccessories =
                                        //     !makeupOrAccessories;
                                      });
                                    }, Assets.iconsIcCompare),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                        () async {}, Assets.iconsIcReset),
                                    Constant.xSizedBox12,
                                    iconSidebar(() async {
                                      changeModel(context);
                                    }, Assets.iconsIcChoose),
                                    Constant.xSizedBox12,
                                    iconSidebar(
                                        () async {}, Assets.iconsIcShare),
                                  ],
                                ),
                              ),
                            ),
                            Constant.xSizedBox16,
                            // makeupOrAccessories
                            //     ?
                            makeupOrAccessoriesChoice()
                            // : sheet(),
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

class MakeupPage extends StatefulWidget {
  const MakeupPage({super.key});

  @override
  State<MakeupPage> createState() => _MakeupPageState();
}

class _MakeupPageState extends State<MakeupPage> {
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

  clearAll() {
    lipsClick = false;
    eyesClick = false;
    faceClick = false;
    nailsClick = false;
    hairClick = false;
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
              context.read<SmartMirrorProvider>().resetData();
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
              context.read<SmartMirrorProvider>().resetData();
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
              context.read<SmartMirrorProvider>().resetData();
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
              context.read<SmartMirrorProvider>().resetData();
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
              context.read<SmartMirrorProvider>().resetData();
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
      child: Column(
        children: [
          // Container(
          //   width: 55,
          //   height: 3,
          //   decoration: BoxDecoration(
          //     color: Colors.grey,
          //     borderRadius: BorderRadius.circular(22),
          //   ),
          // ),
          // Constant.xSizedBox24,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sheet(),
    );
  }
}

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
  bool headClick = false;
  bool neckClick = false;
  bool handClick = false;
  bool nailsClick = false;

  List<String> headAccType = [
    'Sunglasses',
    'Glasses',
    'Earrings',
    'Headband',
    'Hats',
    'Tiaras'
  ];
  List<String> neckAccType = [
    'Pendants',
    'Necklaces',
    'Chokers',
    'Scarves',
  ];

  List<String> handAccType = [
    'Watches',
    'Rings',
    'Bracelets',
    'Bangles',
  ];
  List<String> nailsType = [
    'Nail Polish',
    'Press-on Nails',
  ];

  clearAll() {
    headClick = false;
    neckClick = false;
    handClick = false;
    nailsClick = false;
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

  Widget itemMakeup(String path, GestureTapCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(path, width: 70, height: 70),
    );
  }

  Widget headItem(String type, GestureTapCallback? onTap) {
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

  Widget headList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: headAccType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return headItem(headAccType[index], () {
              // if (index == 0) CusNav.nPush(context, HeadSunglassesView());
              // if (index == 1) CusNav.nPush(context, HeadSunglassesView());
              // if (index == 2) CusNav.nPush(context, HeadEarringsView());
              // if (index == 3) CusNav.nPush(context, HeadHeadbandView());
              // if (index == 4) CusNav.nPush(context, HeadHatsView());
              // if (index == 5) CusNav.nPush(context, HeadTiarasView());
            });
          },
        ),
      ),
    );
  }

  Widget neckItem(String type, GestureTapCallback? onTap) {
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

  Widget neckList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: neckAccType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return neckItem(neckAccType[index], () {
              // if (index == 0) CusNav.nPush(context, PendantsView());
              // if (index == 1) CusNav.nPush(context, NecklacesView());
              // if (index == 2) CusNav.nPush(context, ChokersView());
              // if (index == 3) CusNav.nPush(context, ScarvesView());
            });
          },
        ),
      ),
    );
  }

  Widget handItem(String type, GestureTapCallback? onTap) {
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

  Widget handList() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 30,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: handAccType.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return handItem(handAccType[index], () {
              // if (index == 0) CusNav.nPush(context, WatchesView());
              // if (index == 1) CusNav.nPush(context, RingsView());
              // if (index == 2) CusNav.nPush(context, BraceletsView());
              // if (index == 3) CusNav.nPush(context, BanglesView());
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
              // if (index == 0) CusNav.nPush(context, NailPolishAccView());
              // if (index == 1) CusNav.nPush(context, PresOnNailsAccView());
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
      child: Column(
        children: [
          // Container(
          //   width: 55,
          //   height: 3,
          //   decoration: BoxDecoration(
          //     color: Colors.grey,
          //     borderRadius: BorderRadius.circular(22),
          //   ),
          // ),
          // Constant.xSizedBox24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemMakeup(
                  (headClick == false
                      ? Assets.iconsIcHead
                      : Assets.iconsIcHeadOn), () {
                setState(() {
                  clearAll();
                  headClick = !headClick;
                });
              }),
              itemMakeup(
                  neckClick == false
                      ? Assets.iconsIcNeck
                      : Assets.iconsIcNeckOn, () {
                setState(() {
                  clearAll();
                  neckClick = !neckClick;
                });
              }),
              itemMakeup(
                  handClick == false
                      ? Assets.iconsIcHand
                      : Assets.iconsIcNeckOn, () {
                setState(() {
                  clearAll();
                  handClick = !handClick;
                });
              }),
              itemMakeup(
                  nailsClick == false
                      ? Assets.iconsIcNailsAcc
                      : Assets.iconsIcNailsAccOn, () {
                setState(() {
                  clearAll();
                  nailsClick = !nailsClick;
                });
              }),
            ],
          ),
          Constant.xSizedBox8,
          Constant.xSizedBox12,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: sheet(),
    );
  }
}
