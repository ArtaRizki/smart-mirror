import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_mirror/common/component/custom_navigator.dart';
import 'package:smart_mirror/common/component/skeleton.dart';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:smart_mirror/generated/assets.dart';
import 'package:smart_mirror/src/camera/camera_page.dart';
import 'package:smart_mirror/src/camera2/camera_page2.dart';
import 'package:smart_mirror/src/camera2/camera_video_page.dart';
import 'package:smart_mirror/src/camera2/makeup_page.dart';
import 'package:smart_mirror/src/model/product_model.dart';
import 'package:smart_mirror/src/model/shape_model.dart';
import 'package:smart_mirror/src/model/texture_model.dart';
import 'package:smart_mirror/src/provider/smart_mirror_provider.dart';
import 'package:smart_mirror/utils/utils.dart';

const xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);

class EyeshadowView extends StatefulWidget {
  const EyeshadowView({super.key});

  @override
  State<EyeshadowView> createState() => _EyeshadowViewState();
}

class _EyeshadowViewState extends State<EyeshadowView> {
  late CameraController controller;
  Completer<String?> cameraSetupCompleter = Completer();
  Completer? isFlippingCamera;
  late List<Permission> permissions;
  bool isRearCamera = true;
  bool isFlipCameraSupported = false;
  File? file;
  double sliderValue = 0;
  bool onOffVisible = false;
  int? eyebrowSelected = 0;
  int? mainColorSelected;
  int? subColorSelected;
  int? colorTextSelected = 0;
  int? typeSelected = 0;
  int? typeComboSelected = 0;

  List<Color> colorMainList = [
    Color(0xffFE3699),
    Color(0xffE1E1A3),
    Color(0xff3D0B0B),
    Color(0xffFF0000),
    Colors.white,
  ];

  List<String> colorMainListString = [
    'Pink',
    'Beige',
    'Brown',
    'Red',
    'White',
  ];
  List<Color> colorList = [
    Color(0xff3D2B1F),
    Color(0xff5C4033),
    Color(0xff6A4B3A),
    Color(0xff8B4513),
    Color(0xff7B3F00),
    Color(0xff4F300D),
    Color(0xff483C32),
    Color(0xff342112),
    Color(0xff4A2912),
  ];

  List<String> type1List = [
    'Sheer',
    'Matt',
    'Gloss',
  ];

  List<String> typeComboList = [
    'One',
    'Dual',
    'Tri',
    'Quadra',
    'Penta',
  ];

  List<Widget> typeEyeShadow = [
    Image.asset(Assets.imagesImgEyeshadow),
    Image.asset(Assets.imagesImgEyeshadow),
    Image.asset(Assets.imagesImgEyeshadow),
    Image.asset(Assets.imagesImgEyeshadow),
  ];

  getData() async {
    final p = context.read<SmartMirrorProvider>();
    await p.getColor();
    await p.getSubcolor();
    getTexture();
    setState(() {});
  }

  getTexture() async {
    final p = context.read<SmartMirrorProvider>();
    await p.getTexture();
    textureListOptions = p.textureModel.options
        ?.where((e) => textureList.contains(e?.label ?? ''))
        .toList();
    setState(() {});
  }

  List<TextureModelOptions?>? textureListOptions;
  List<String> textureList = ['Sheer', 'Matt', 'Gloss', 'Shimmer', 'Satin'];
  List<String> chip2List = [
    'One',
    'Dual',
    'Ombre',
  ];

  @override
  void initState() {
    getData();
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

  Widget colorChipItemShimmer(int index) {
    final colorList = context.watch<SmartMirrorProvider>().colorModel.options;
    return Skeleton<bool>(
      width: 70,
      height: 40,
      value: context.watch<SmartMirrorProvider>().colorModel.options != null
          ? false
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: mainColorSelected == index
                  ? Colors.white
                  : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(radius: 8, backgroundColor: colorList?[index]?.color),
            Constant.xSizedBox4,
            Text(
              colorList?[index]?.label ?? '',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorChipItem(int index) {
    final colorList = context.watch<SmartMirrorProvider>().colorModel.options;
    return InkWell(
      onTap: () {
        final p = context.read<SmartMirrorProvider>();
        p.selectedColorValue = colorList?[index]?.value ?? '';
        p.getProductByColor();
        setState(() {
          mainColorSelected = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: mainColorSelected == index
                  ? Colors.white
                  : Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(radius: 8, backgroundColor: colorList?[index]?.color),
            Constant.xSizedBox4,
            Text(
              colorList?[index]?.label ?? '',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorChip() {
    final colorList = context.watch<SmartMirrorProvider>().colorModel.options;
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: colorList?.length ?? 10,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          if (colorList == null) return colorChipItemShimmer(index);
          return colorChipItem(index);
        },
      ),
    );
  }

  Widget subcolorChoiceItemShimmer(int index) {
    final subcolorList =
        context.watch<SmartMirrorProvider>().subcolorModel.options;
    return Skeleton(
      isCircle: true,
      value: context.watch<SmartMirrorProvider>().subcolorModel.options != null
          ? false
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: index == subColorSelected && onOffVisible == false
                  ? Colors.white
                  : Colors.transparent),
        ),
        child: CircleAvatar(
            radius: 12, backgroundColor: subcolorList?[index]?.color),
      ),
    );
  }

  Widget subcolorChoiceItem(int index) {
    final subcolorList =
        context.watch<SmartMirrorProvider>().subcolorModel.options;
    return InkWell(
      onTap: () {
        final p = context.read<SmartMirrorProvider>();
        p.selectedSubColorValue = subcolorList?[index]?.value ?? '';
        p.getProductBySubColor();
        setState(() {
          subColorSelected = index;
          onOffVisible = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: index == subColorSelected && onOffVisible == false
                  ? Colors.white
                  : Colors.transparent),
        ),
        child: CircleAvatar(
            radius: 12, backgroundColor: subcolorList?[index]?.color),
      ),
    );
  }

  Widget subcolorChoice() {
    final subcolorList =
        context.watch<SmartMirrorProvider>().subcolorModel.options;
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: subcolorList?.length ?? 10,
        separatorBuilder: (_, __) => Constant.xSizedBox12,
        itemBuilder: (context, index) {
          if (subcolorList == null) return subcolorChoiceItemShimmer(index);
          if (index == 0)
            return InkWell(
              onTap: () async {
                final p = context.read<SmartMirrorProvider>();
                p.selectedSubColorValue = null;
                p.productModel = ProductModel();
                p.selectedProduct = null;
                setState(() {
                  subColorSelected = 0;
                  onOffVisible = true;
                });
              },
              child: Icon(Icons.do_not_disturb_alt_sharp,
                  color: Colors.white, size: 25),
            );
          return subcolorChoiceItem(index - 1);
        },
      ),
    );
  }

  Widget colorChoice() {
    return Container(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: colorList.length,
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
                      radius: 12, backgroundColor: colorList[index])));
        },
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
          itemCount: type1List.length,
          separatorBuilder: (_, __) => Constant.xSizedBox8,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                setState(() {
                  typeSelected = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: index == typeSelected
                          ? Colors.white
                          : Colors.transparent),
                ),
                child: Center(
                  child: Text(
                    type1List[index],
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

  Widget typeComboChip() {
    return Container(
      height: 20,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: typeComboList.length,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                typeComboSelected = index;
              });
            },
            child: Center(
              child: Text(
                typeComboList[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    shadows: index == typeComboSelected
                        ? [
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 10,
                            ),
                          ]
                        : null),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget typeEyeShadowChip() {
    return Container(
      height: 40,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: typeEyeShadow.length,
        separatorBuilder: (_, __) => Constant.xSizedBox8,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                eyebrowSelected = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: index == eyebrowSelected
                        ? Colors.white
                        : Colors.transparent),
              ),
              child: typeEyeShadow[index],
            ),
          );
        },
      ),
    );
  }

  Widget productChoiceItemShimmer(int index) {
    final item =
        context.watch<SmartMirrorProvider>().productModel.items?[index];
    return Skeleton<bool>(
      width: 120,
      height: 120,
      value: context.watch<SmartMirrorProvider>().productModel.items != null
          ? false
          : null,
      child: SizedBox(),
    );
  }

  Widget productChoiceItem(int index) {
    final item =
        context.watch<SmartMirrorProvider>().productModel.items?[index];
    return InkWell(
      onTap: () async {},
      child: SizedBox(
        width: 120,
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
                      child: Image.network(
                          'https://magento-1231949-4398885.cloudwaysapps.com/media/catalog/product${item?.mediaGalleryEntries?.first?.file ?? ''}')),
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
            SizedBox(height: 5),
            Text(
              item?.name ?? '',
              maxLines: 2,
              style: Constant.whiteBold16
                  .copyWith(fontSize: 12, overflow: TextOverflow.ellipsis),
            ),
            Text(
              item?.typeId ?? '',
              style:
                  Constant.whiteRegular12.copyWith(fontWeight: FontWeight.w300),
            ),
            Text("\$${item?.price}", style: Constant.whiteRegular12),
          ],
        ),
      ),
    );
  }

  Widget productChoice() {
    final productList = context.watch<SmartMirrorProvider>().productModel.items;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 155,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: productList == null
              ? 10
              : productList.isEmpty
                  ? 0
                  : productList.length,
          separatorBuilder: (_, __) => Constant.xSizedBox12,
          itemBuilder: (context, index) {
            if (productList == null) return productChoiceItemShimmer(index);
            return productChoiceItem(index);
          },
        ),
      ),
    );
  }

  Widget slider() {
    return Container(
      height: 60,
      child: Column(
        children: [
          Slider(
            thumbColor: Color(0xffCA9C43),
            activeColor: Color(0xffCA9C43),
            value: sliderValue,
            max: 10,
            min: 0,
            onChanged: (v) {
              setState(() {
                sliderValue = v;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light',
                    style: TextStyle(color: Colors.white, fontSize: 8)),
                Text('Dark',
                    style: TextStyle(color: Colors.white, fontSize: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sheet() {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constant.xSizedBox8,
            colorChip(),
            Constant.xSizedBox8,
            subcolorChoice(),
            Constant.xSizedBox8,
            separator(),
            Constant.xSizedBox4,
            typeChip(),
            Constant.xSizedBox4,
            separator(),
            Constant.xSizedBox4,
            typeComboChip(),
            Constant.xSizedBox4,
            separator(),
            Constant.xSizedBox4,
            typeEyeShadowChip(),
            separator(),
            Constant.xSizedBox4,
            productChoice(),
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
