import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:smart_mirror/common/base/base_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_mirror/common/base/base_response.dart';
import 'package:smart_mirror/common/helper/constant.dart';
import 'package:smart_mirror/src/model/color_model.dart';
import 'package:smart_mirror/src/model/fabric_model.dart';
import 'package:smart_mirror/src/model/material_model.dart';
import 'package:smart_mirror/src/model/occasion_model.dart';
import 'package:smart_mirror/src/model/product_model.dart';
import 'package:smart_mirror/src/model/shape_model.dart';
import 'package:smart_mirror/src/model/subcolor_model.dart';
import 'package:smart_mirror/src/model/texture_model.dart';

class SmartMirrorProvider extends BaseController with ChangeNotifier {
  resetData() async {
    productModel = ProductModel(items: []);
    selectedProduct = null;
    colorModel = ColorModel();
    selectedColorValue = null;
    subcolorModel = SubcolorModel();
    selectedSubColorValue = null;
    shapeModel = ShapeModel();
    selectedShapeValue = null;
    materialModel = MaterialModel();
    selectedMaterialValue = null;
    occasionModel = OccasionModel();
    selectedOccasionValue = null;
    fabricModel = FabricModel();
    selectedFabricValue = null;
    textureModel = TextureModel();
    selectedTextureValue = null;
  }

  ColorModel _colorModel = ColorModel();
  ColorModel get colorModel => this._colorModel;
  set colorModel(ColorModel value) => this._colorModel = value;

  Future<void> getColor({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/color');
    if (response.statusCode == 200) {
      colorModel = ColorModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  SubcolorModel _subcolorModel = SubcolorModel();
  SubcolorModel get subcolorModel => this._subcolorModel;
  set subcolorModel(SubcolorModel value) => this._subcolorModel = value;

  Future<void> getSubcolor({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/sub_color');
    if (response.statusCode == 200) {
      subcolorModel = SubcolorModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedColorValue;
  ProductModel _productModel = ProductModel();
  ProductModel get productModel => this._productModel;
  set productModel(ProductModel value) => this._productModel = value;

  ProductModelItems? _selectedProduct;
  ProductModelItems? get selectedProduct => this._selectedProduct;
  set selectedProduct(ProductModelItems? value) =>
      this._selectedProduct = value;

  Future<void> selectProduct(ProductModelItems? value) async {
    selectedProduct = value;
    notifyListeners();
  }

  Future<void> getProductByColor({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'color',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedColorValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedSubColorValue;

  Future<void> getProductBySubColor({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'sub_color',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedSubColorValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  ShapeModel _shapeModel = ShapeModel();
  ShapeModel get shapeModel => this._shapeModel;
  set shapeModel(ShapeModel value) => this._shapeModel = value;

  Future<void> getShape({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/shape');
    if (response.statusCode == 200) {
      shapeModel = ShapeModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedShapeValue;

  Future<void> getProductByShape({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'shape',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedShapeValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  MaterialModel _materialModel = MaterialModel();
  MaterialModel get materialModel => this._materialModel;
  set materialModel(MaterialModel value) => this._materialModel = value;

  Future<void> getMaterial({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/material');
    if (response.statusCode == 200) {
      materialModel = MaterialModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedMaterialValue;

  Future<void> getProductByMaterial({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'material',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedMaterialValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  OccasionModel _occasionModel = OccasionModel();
  OccasionModel get occasionModel => this._occasionModel;
  set occasionModel(OccasionModel value) => this._occasionModel = value;

  Future<void> getOccasion({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/occasion');
    if (response.statusCode == 200) {
      occasionModel = OccasionModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedOccasionValue;

  Future<void> getProductByOccasion({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'occasion',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedOccasionValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  FabricModel _fabricModel = FabricModel();
  FabricModel get fabricModel => this._fabricModel;
  set fabricModel(FabricModel value) => this._fabricModel = value;

  Future<void> getFabric({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/fabric');
    if (response.statusCode == 200) {
      fabricModel = FabricModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedFabricValue;

  Future<void> getProductByFabric({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'fabric',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedFabricValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  TextureModel _textureModel = TextureModel();
  TextureModel get textureModel => this._textureModel;
  set textureModel(TextureModel value) => this._textureModel = value;

  Future<void> getTexture({bool withLoading = true}) async {
    // if (withLoading) loading(true);

    final response =
        await get(Constant.BASE_API_FULL + 'products/attributes/texture');
    if (response.statusCode == 200) {
      textureModel = TextureModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }

  String? selectedTextureValue;

  Future<void> getProductByTexture({bool withLoading = true}) async {
    // if (withLoading) loading(true);
    productModel = ProductModel();
    var body = {
      'searchCriteria[filter_groups][0][filters][0][field]': 'texture',
      'searchCriteria[filter_groups][0][filters][0][value]':
          selectedTextureValue ?? '',
    };
    final response = await get(Constant.BASE_API_FULL + 'products', body: body);
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(jsonDecode(response.body));
      notifyListeners();
      // if (withLoading) // loading(false);
    } else {
      final message = BaseResponse.from(response).message;
      // loading(false);
      throw Exception(message);
    }
  }
}
