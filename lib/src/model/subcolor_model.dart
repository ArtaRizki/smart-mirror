import 'package:flutter/material.dart';

///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubcolorModelOptions {
/*
{
  "label": "White",
  "value": "4"
} 
*/

  String? label;
  String? value;
  Color color = Colors.transparent;

  SubcolorModelOptions({
    this.label,
    this.value,
    required this.color,
  });
  SubcolorModelOptions.fromJson(Map<String, dynamic> json) {
    label = json['label']?.toString();
    value = json['value']?.toString();
    color = getSubcolorHex(json['label']);
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['label'] = label;
    data['value'] = value;
    return data;
  }

  Color getHex(String? name) {
    if (name == 'White') return Colors.white;
    if (name == "Black") return Colors.black;
    if (name == "Red") return Colors.red;
    if (name == "Blue") return Colors.blue;
    if (name == "Green") return Colors.green;
    if (name == "Beige") return Color(0xfff5f5dc);
    if (name == "Brass") return Color(0xffb5a642);
    if (name == "Brown") return Colors.brown;
    if (name == "Gold") return Color(0xffFFD700);
    if (name == "Grey") return Colors.grey;
    if (name == "Orange") return Colors.orange;
    if (name == "Pink") return Colors.pink;
    if (name == "Purple") return Colors.purple;
    if (name == "Silver") return Color(0xffC0C0C0);
    if (name == "Transparent") return Colors.transparent;
    if (name == "Yellow") return Colors.yellow;
    if (name == "Shimmer") return Color(0xffFFFEF7);
    if (name == "Bronze") return Color(0xffcd7f32);
    if (name == "Nude") return Color(0xffe3bc9a);
    return Colors.transparent;
  }

  List<Map<String, dynamic>> subColorList = [
    {"label": " ", "value": 0xffFFFFFF},
    {"label": "006 Berry", "value": 0xff8B3A62},
    {"label": "007 Raspberry", "value": 0xffD21F3C},
    {"label": "012 Rosewood", "value": 0xff8B6B61},
    {"label": "028 Actrice", "value": 0xffE2A7A0},
    {"label": "060 Premiere", "value": 0xffA52A2A},
    {"label": "100 Nude Look", "value": 0xffF0D5C9},
    {"label": "251 Natural Peach", "value": 0xffFFCBA4},
    {"label": "351 Natural Nude", "value": 0xffC9A78B},
    {"label": "418 Beige Oblique", "value": 0xffD3B49B},
    {"label": "421 Natural Beige", "value": 0xffDAB98F},
    {"label": "422 Rosedes Vents", "value": 0xffC79A97},
    {"label": "491 Natural Rosewood", "value": 0xffA15C4E},
    {"label": "558 Bois De Rose", "value": 0xffB88C8E},
    {"label": "593 Brown Fig", "value": 0xff5A3A31},
    {"label": "636 Ultra Dior", "value": 0xffAF2E2C},
    {"label": "661 Natural Red", "value": 0xffD74747},
    {"label": "665 Revee", "value": 0xffB36B77},
    {"label": "678 Culte", "value": 0xff8B4A50},
    {"label": "761 Natural Cherry", "value": 0xff9E4643},
    {"label": "771 Natural Berry", "value": 0xff814A54},
    {"label": "772 Classic", "value": 0xff7B3743},
    {"label": "840 Rayonnante", "value": 0xff9E5D70},
    {"label": "872 Red Heart", "value": 0xffB22D35},
    {"label": "943 Euphoric", "value": 0xffA93C50},
    {"label": "Alabaster", "value": 0xffFAF7F5},
    {"label": "Almond", "value": 0xffD2A679},
    {"label": "Aruba Blue", "value": 0xff3F84A5},
    {"label": "Bahama Mama", "value": 0xff6C3B27},
    {"label": "Ballet Slippers", "value": 0xffF2D2CF},
    {"label": "Bare", "value": 0xffC9A78B},
    {"label": "Berry Naughty", "value": 0xff803544},
    {"label": "Black", "value": 0xff000000},
    {"label": "Black Ink", "value": 0xff282828},
    {"label": "Blanc", "value": 0xffFFFFFF},
    {"label": "Blue", "value": 0xff0000FF},
    {"label": "Bronzed", "value": 0xff735C48},
    {"label": "Bubbly", "value": 0xffF2D4B7},
    {"label": "Buff", "value": 0xffE0B585},
    {"label": "Buy Me A Cameo", "value": 0xffD4A177},
    {"label": "Chestnut", "value": 0xff4D2C1C},
    {"label": "Cool Beige", "value": 0xffCABEA4},
    {"label": "Coral", "value": 0xffFF7F50},
    {"label": "Cranberry", "value": 0xff9F2735},
    {"label": "Crystal", "value": 0xffE2E8F0},
    {"label": "Cute As Buttom", "value": 0xffFFC1C3},
    {"label": "Dark Brown", "value": 0xff3C2F2A},
    {"label": "Dazzling Green", "value": 0xff3E964A},
    {"label": "Deep", "value": 0xff4B3A34},
    {"label": "Espresso", "value": 0xff4B2E22},
    {"label": "Golden", "value": 0xffD3A95F},
    {"label": "Golden Light", "value": 0xffE1C38E},
    {"label": "Gray", "value": 0xff808080},
    {"label": "Green", "value": 0xff008000},
    {"label": "Hazel", "value": 0xffA52A2A},
    {"label": "Honey", "value": 0xffFFC30B},
    {"label": "Honey Brown", "value": 0xffA8754D},
    {"label": "Ivory", "value": 0xffFFFFF0},
    {"label": "Latin Brown", "value": 0xff7B5741},
    {"label": "Latin Gray", "value": 0xff5F5F6E},
    {"label": "Lazord", "value": 0xff007BA7},
    {"label": "Lemon", "value": 0xffFFF700},
    {"label": "Mahogany", "value": 0xff88421D},
    {"label": "Medium", "value": 0xffA6806B},
    {"label": "Medium Brwon", "value": 0xff5C4033},
    {"label": "Natural", "value": 0xffD7B99C},
    {"label": "Neutral Brown", "value": 0xff8B6A4E},
    {"label": "Nude", "value": 0xffD4B69E},
    {"label": "Pink", "value": 0xffFFC0CB},
    {"label": "Rich", "value": 0xff8C4A2F},
    {"label": "Rich Brown", "value": 0xff5D3A3A},
    {"label": "Rosey", "value": 0xffDC6E8D},
    {"label": "Saddle", "value": 0xff8B4513},
    {"label": "Sepia Ink", "value": 0xff704214},
    {"label": "Shell", "value": 0xffFDE9D9},
    {"label": "Shore", "value": 0xffA9B9C2},
    {"label": "Soft Black", "value": 0xff484848},
    {"label": "Walnut", "value": 0xff5E2C04},
    {"label": "Warm Almond", "value": 0xffD9A47E},
    {"label": "Warm Honey", "value": 0xffB5823A},
    {"label": "Warm Natural", "value": 0xffC69F85},
    {"label": "Warm Walnut", "value": 0xff7E5240},
    {"label": "Medium Brown", "value": 0xff5C4033},
    {"label": "Beige", "value": 0xffF5F5DC},
    {"label": "Brown", "value": 0xffA52A2A},
    {"label": "Gold", "value": 0xffFFD700},
    {"label": "Grey", "value": 0xff808080},
    {"label": "Purple", "value": 0xff800080},
    {"label": "Red", "value": 0xffFF0000},
    {"label": "Silver", "value": 0xffC0C0C0},
    {"label": "White", "value": 0xffFFFFFF}
  ];

  Color getSubcolorHex(String label) {
    final found = subColorList.firstWhere((e) => e['label'] == label)['value'];
    return Color(found);
  }
}

class SubcolorModel {
/*
{
  "options": [
    {
      "label": "White",
      "value": "4"
    }
  ]
} 
*/

  List<SubcolorModelOptions?>? options;

  SubcolorModel({
    this.options,
  });
  SubcolorModel.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      final v = json['options'];
      final arr0 = <SubcolorModelOptions>[];
      v.forEach((v) {
        if (v['label'].toString().trim() != '')
          arr0.add(SubcolorModelOptions.fromJson(v));
      });
      options = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (options != null) {
      final v = options;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['options'] = arr0;
    }
    return data;
  }
}
