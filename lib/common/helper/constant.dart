import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
// import 'package:string_validator/string_validator.dart';z

class Constant {
  /// KEY
  ///
  /// This constant using for default base api url, map key and app name
  /// Please be carefully to change this keys because might affect with all entire project .
  ///
  static const String MAPS_KEY = "AIzaSyDDPvYz8jGLntwWp-Nii2F7bvGADm504Ts";
  static const String DOMAIN = "103.59.94.19";
  static const String DOMAIN2 = "103.59.94.19";
  static const String BASE_API_FULL = "http://$DOMAIN/v1";
  static const String BASE_API_FULL2 = "http://$DOMAIN2/v1";
  static const String BASE_API_FULL3 = "http://$DOMAIN";
  static const String APP_NAME = "HY TUTORIAL";

  /// COlORS
  ///
  /// This constant using for default color theme base of design mockup, so
  /// you can add int as hexcode of color and you can use this constant like this .
  ///
  /// Constant.firstColor;
  ///
  static Color primaryColor = const Color(0xFF084B83);
  static Color secondaryColor = const Color(0xFF10345A);
  static Color thirdColor = const Color(0xFFFBBB00);
  static Color sampleColor = const Color(0xFFC89A44);
  static Color tertiaryColor = const Color(0xFF8CC6FF);
  static Color quarteryColor = const Color(0xFFC5E2FF);
  static Color tableBlueColor = const Color(0xFFE9F0FF);
  static Color darkGrayColor = Colors.grey.shade800;
  static Color grayColor = Colors.grey.shade600;
  static Color lightGrayColor = Colors.grey.shade400;
  static Color textHintColor = const Color(0xFFE6E8E7);
  static Color textHintColor2 = const Color(0xFF949494);
  static Color darkGrayButtonColor = const Color(0xff0000008a);
  static Color bgFieldColor = const Color(0xff8cc6ff4d);
  static Color textColor = const Color(0xFF3E3A39);
  static Color textColor2 = const Color(0xFF535152);
  static Color textKomisiColor = const Color(0xFFFFCB47);
  static Color textPriceColor = const Color(0xFF3DA11A);
  static Color backgroundColor = const Color(0xFFF9F9F9);
  static Color textColorBlack = const Color(0xff1D273B);
  static Color textColorWhite = Colors.white;
  static Color textColorBlue = const Color(0xFF041E42);
  static Color timerColor = const Color(0xFFE7B641);
  static Color progressColor = const Color(0xFFF5C34B);
  // static Color textPriceColor = Color(0xFF3DA11A);
  static Color textOnAuthColor = const Color(0xFF21272A);
  static Color greyIndicatorColor = const Color(0xFFD9D9D9);
  // static Color backgroundColor = Color(0xFFF9F9F9);
  static Color borderLightColor = const Color(0xFFEAEAEA);
  static Color borderRegularColor = const Color(0xFF9D9B9B);
  static Color borderSearchColor = const Color(0xFF949494);
  static Color greenColor = const Color(0xFF2C7C4F);
  static Color redColor = const Color(0xFFEA0315);
  static Color blueColor = const Color(0xFF093CA9);

  static TextStyle primaryTextStyle =
      TextStyle(fontFamily: 'Inter', color: textColor);
  static TextStyle secondaryTextStyle =
      TextStyle(fontFamily: 'Inter', color: textColor2);
  static TextStyle komisiTextStyle =
      TextStyle(fontFamily: 'Inter', color: textKomisiColor);
  static TextStyle priceTextStyle =
      TextStyle(fontFamily: 'Inter', color: textPriceColor);
  static TextStyle s12BoldBlack = TextStyle(
    fontFamily: 'Inter',
    color: textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryTextStyle2 =
      TextStyle(fontFamily: 'Inter', color: textColor);
  static TextStyle secondaryTextStyle2 =
      TextStyle(fontFamily: 'Inter', color: textColor2);
  static TextStyle komisiTextStyle2 =
      TextStyle(fontFamily: 'Inter', color: textKomisiColor);
  static TextStyle priceTextStyle2 =
      TextStyle(fontFamily: 'Inter', color: textPriceColor);
  static TextStyle s12BoldBlack2 = TextStyle(
    fontFamily: 'Inter',
    color: textColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle iBlack = const TextStyle(fontFamily: 'Inter');

  static TextStyle iPrimaryMedium8 = TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 8,
    fontWeight: medium,
  );
  static TextStyle iPrimaryMedium14 = TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 14,
    fontWeight: medium,
  );
  static TextStyle iPrimaryMedium12 = TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 12,
    fontWeight: medium,
  );

  static TextStyle iBlackMedium8 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 8,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium10 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 8,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium12 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 12,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium13 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 13,
    fontWeight: medium,
  );
  static TextStyle blackRegular12 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static TextStyle iBlackMedium = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium18 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 18,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium16StrkWhite = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 16,
    shadows: const [
      Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.white),
      Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.white),
      Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.white),
      Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.white),
    ],
    fontWeight: medium,
  );
  static TextStyle iBlackMedium16 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 16,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium20 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 20,
    fontWeight: medium,
  );
  static TextStyle iBlackMedium40StrkWhite = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 40,
    shadows: const [
      Shadow(
          // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.white),
      Shadow(
          // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.white),
      Shadow(
          // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.white),
      Shadow(
          // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.white),
    ],
    fontWeight: medium,
  );

  static TextStyle primaryBold15 = TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 15,
    fontWeight: bold,
  );
  static TextStyle primaryBold20 = TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 20,
    fontWeight: bold,
  );
  static TextStyle quartenary = TextStyle(
    fontFamily: 'Inter',
    color: quarteryColor,
    fontWeight: regular,
  );
  static TextStyle whiteExtraBold18 = TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 18,
    fontWeight: bold,
  );

  static TextStyle blackBold10 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 10,
    fontWeight: bold,
  );
  static TextStyle blackBold13 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 13,
    fontWeight: bold,
  );
  static TextStyle blackBold = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontWeight: bold,
  );
  static TextStyle blackBold15 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 15,
    fontWeight: bold,
  );
  static TextStyle blackBold16 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 16,
    fontWeight: bold,
  );
  static TextStyle blackBold20 = TextStyle(
    fontFamily: 'Inter',
    color: textColorBlack,
    fontSize: 20,
    fontWeight: bold,
  );

  static TextStyle grayRegular = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
  );
  static TextStyle grayRegular8 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 8,
  );
  static TextStyle grayRegular12 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 12,
  );
  static TextStyle grayRegular13 = TextStyle(
    fontFamily: 'Inter',
    color: grayColor,
    fontSize: 13,
  );
  static TextStyle grayMedium10 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 10,
    fontWeight: medium,
  );
  static TextStyle grayMedium13 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 13,
    fontWeight: medium,
  );
  static TextStyle grayMedium = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontWeight: medium,
  );
  static TextStyle grayMedium15 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 15,
    fontWeight: medium,
  );
  static TextStyle grayBold12 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 12,
    fontWeight: bold,
  );
  static TextStyle grayBold15 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 15,
    fontWeight: bold,
  );
  static TextStyle grayBold16 = TextStyle(
    fontFamily: 'Inter',
    color: lightGrayColor,
    fontSize: 16,
    fontWeight: bold,
  );
  static TextStyle whiteRegular12 = const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 12,
  );
  static TextStyle whiteBold = TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontWeight: bold,
  );
  static TextStyle whiteBold15 = TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 15,
    fontWeight: bold,
  );
  static TextStyle whiteBold16 = TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 16,
    fontWeight: bold,
  );
  static TextStyle whiteExtraBold = TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontWeight: extraBold,
  );

  static TextStyle greenBold12 = TextStyle(
    fontFamily: 'Inter',
    color: greenColor,
    fontSize: 12,
    fontWeight: bold,
  );
  static TextStyle blueBold12 = TextStyle(
    fontFamily: 'Inter',
    color: blueColor,
    fontSize: 12,
    fontWeight: bold,
  );
  static TextStyle redBold12 = TextStyle(
    fontFamily: 'Inter',
    color: redColor,
    fontSize: 12,
    fontWeight: bold,
  );
  static TextStyle redRegular12 = TextStyle(
    fontFamily: 'Inter',
    color: redColor,
    fontSize: 12,
    fontWeight: regular,
  );
  static TextStyle redMedium12 = TextStyle(
    fontFamily: 'Inter',
    color: redColor,
    fontSize: 12,
    fontWeight: medium,
  );

  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semibold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
  static FontWeight black = FontWeight.w900;

  static ThemeData mainThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    indicatorColor: Colors.white,
    dividerColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: primaryColor,
      ),
    ),
    // colorSchemeSeed: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // <-- SEE HERE
        // systemNavigationBarColor: primaryColor,
        // systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness:
            Brightness.light, //<-- For Android SEE HERE (dark icons)
        statusBarBrightness:
            Brightness.light, //<-- For iOS SEE HERE (dark icons)
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(BorderSide(color: primaryColor)),
        foregroundColor: WidgetStateProperty.all(primaryColor),
      ),
    ),
    scaffoldBackgroundColor: Constant.backgroundColor,
    primaryColor: primaryColor,
    focusColor: Colors.black,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor, //<-- SEE HERE
    ).copyWith(
        primary: Constant.primaryColor, surface: Constant.backgroundColor),
  );

  // static const Color color4 = Color(0xffc2d5ee);

  /// DEFAULT SIZE
  ///
  /// This constant using for default size for text style, so you can this add or change as you want
  /// Be carefully to change this constant because it might affect with size in entire project
  ///

  /// Font Size
  ///
  /// How to use: Constant.fontSizeSmall;
  ///
  static const double fontSizeSmall = 11;
  static const double fontSizeRegular = 13;
  static const double fontSizeBig = 15;
  static const double fontSizeBigger = 20;

  /// Margin Padding
  ///
  /// How to use: Constant.standardPaddingSize;
  ///
  static const double standartPaddingSize = 12;
  static const double standartMarginSize = 12;

  static const double paddingSize = 12;
  static const double marginSize = 12;

  /// shareprefrence key

  static const String kSetPrefToken = "token";
  static const String kSetPrefRefreshToken = "refresh_token";
  static const String kSetPrefId = "id";
  static const String kSetPrefFcmToken = "fcmToken";
  static const String kSetPrefName = "name";
  static const String kSetPrefCompany = "company";
  static const String kSetPrefIsAdmin = "is_admin";
  static const String kSetPrefEmail = "email";
  static const String kSetPrefPhone = "phone";
  static const String kSetPrefVerified = "verified";
  static const String kSetPrefDivision = "division";
  static const String kSetPrefCanAssess = "can_assess";
  static const String kIsBreakPresence = "is_break_presence";
  static const String kSetPrefParamCreateTurbine = "param_create_turbine";
  static const String kSetPrefConfigLat = "config_lat";
  static const String kSetPrefConfigLon = "config_lon";
  static const String kSetPrefConfigRadius = "radius";
  static const String kSetPrefConfigRadiusType = "radius_type";
  static const String kSetPrefConfigStatus = "config_status";

  static const String kCheckIn = "check_in";
  static const String kCheckOut = "check_out";
  static const String kCheckInBreak = "check_in_break";
  static const String kCheckOutBreak = "check_out_break";
  static const String kBreakStart = "break_start";
  static const String kBreakEnd = "break_end";

  static const String kShowPayrollSlip = "showPayrollSlip";
  static const String kUseFaceDetection = "faceDetection";
  static const String kLockArea = "lockArea";
  static const String kLockOutOfArea = "lockOutOfArea";
  static const String kRequestReviewCount = "requestReviewCount";
  static const String kLoanMargin = "loanMargin";
  static const String kPayRollDate = "payrollDate";
  static const String kFromLogin = "fromLogin";
  static const String kWorkingDays = "workingDays";
  static const String kAllowWFH = "allowWFH";
  static const String kWithoutPhoto = "withoutPhoto";

  final BorderRadius cardRadius = BorderRadius.circular(12);
  final BorderRadius sharpCardRadius = BorderRadius.circular(4);
  static const double cardElevation = 0;

  static const InputDecoration outlinedDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      border: OutlineInputBorder());

  Color enableDisableColor(bool value) {
    if (value) return primaryColor;
    return textColor2;
  }

  String pathVenueType(String facility) {
    if (facility.toLowerCase().contains("basket")) {
      return "icon-basketball";
    }
    if (facility.toLowerCase().contains("badminton")) {
      return "icon-badminton";
    }
    if (facility.toLowerCase().contains("futsal")) {
      return "icon-futsal";
    }
    if (facility.toLowerCase().contains("sepak")) {
      return "icon-football";
    }
    if (facility.toLowerCase().contains("voli")) {
      return "icon-voli";
    }
    return "icon-basketball";
  }

  String textButton(String status, {bool isRated = false}) {
    if (status == "Selesai" && isRated) {
      return "Pembayaran";
    }
    switch (status) {
      case "Menunggu Pembayaran":
        return "Pembayaran";
      case "Selesai":
        return "Beri Rating dan Review";
      case "Lunas":
        return "Pembayaran";
      case "Kadaluarsa":
        return "Pembayaran";
      case "Menunggu Validasi Pembayaran":
        return "Pembayaran";
      default:
        return "Pembayaran";
    }
  }

  TextStyle statusText(String status) {
    switch (status) {
      case "1":
        return greenBold12;
      case "0":
        return redBold12;
      // case "Kadaluarsa":
      //   return kadaluarsaC;
      // case "Menunggu Validasi Pembayaran":
      //   return menungguPembayaranC;
      default:
        return grayBold12;
    }
  }

  // Color statusTextColor(String status) {
  //   switch (status) {
  //     case "Menunggu Pembayaran":
  //       return menungguPembayaranTextC;
  //     case "Selesai":
  //       return selesaiTextC;
  //     case "Lunas":
  //       return lunasTextC;
  //     case "Kadaluarsa":
  //       return kadaluarsaTextC;
  //     case "Menunggu Validasi Pembayaran":
  //       return menungguPembayaranTextC;
  //     default:
  //       return tidakValidTextC;
  //   }
  // }

  // final MaterialColor primarySwatch = MaterialColor(primaryColor.value, const {
  //   50: Color(0xFFE1F0E1),
  //   100: Color(0xFFB3DAB4),
  //   200: Color(0xFF80C282),
  //   300: Color(0xFF4DA94F),
  //   400: Color(0xFF27962A),
  //   500: primaryColor,
  //   600: Color(0xFF017C03),
  //   700: Color(0xFF017103),
  //   800: Color(0xFF016702),
  //   900: Color(0xFF005401),
  // });

  static Border border = Border.all(color: const Color(0xffdcdde1), width: .5);

  static BoxDecoration containerDecoration = BoxDecoration(
      border: Border.all(color: const Color(0xffdcdde1), width: .5),
      borderRadius: BorderRadius.circular(12));

// :ignore
  // String? Function(String?) requiredValidator = (value) {
  //   value ??= '';
  //   if (value.isEmpty) {
  //     return "Kolom ini harus diisi";
  //   }
  //   return null;
  // };
  // String? Function(String?) emailValidator = (value) {
  //   value ??= '';
  //   if (value.isEmpty) {
  //     return "Kolom ini harus diisi";
  //   }
  //   if (!isEmail(value)) {
  //     return "Email tidak valid";
  //   }
  //   return null;
  // };

  // String? Function(String?) numberValidator = (value) {
  //   value ??= '';
  //   if (value.isEmpty) {
  //     return "Kolom ini harus diisi";
  //   }
  //   if (!isNumeric(value)) {
  //     return "Kolom harus berupa angka";
  //   }
  //   return null;
  // };

//SizedBox
  static const SizedBox xSizedBox4 = SizedBox.square(dimension: 4);
  static const SizedBox xSizedBox8 = SizedBox.square(dimension: 8);
  static const SizedBox xSizedBox12 = SizedBox.square(dimension: 12);
  static const SizedBox xSizedBox18 = SizedBox.square(dimension: 18);
  static const SizedBox xSizedBox16 = SizedBox.square(dimension: 16);
  static const SizedBox xSizedBox24 = SizedBox.square(dimension: 24);
  static const SizedBox xSizedBox32 = SizedBox.square(dimension: 32);

//horizontal Edgeinset
  static const EdgeInsets xHEdgeInsets4 = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets xHEdgeInsets8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets xHEdgeInsets12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets xHEdgeInsets18 = EdgeInsets.symmetric(horizontal: 18);
  static const EdgeInsets xHEdgeInsets24 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets xHEdgeInsets32 = EdgeInsets.symmetric(horizontal: 32);

//vertical Edgeinset
  static const EdgeInsets xVEdgeInsets4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets xVEdgeInsets8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets xVEdgeInsets12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets xVEdgeInsets18 = EdgeInsets.symmetric(vertical: 18);
  static const EdgeInsets xVEdgeInsets24 = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets xVEdgeInsets32 = EdgeInsets.symmetric(vertical: 32);

  static const double toolbarHeight = 64;

//date format
  final DateFormat xDateFormat1 = DateFormat('yyyy-MM-dd');
  final DateFormat xDateTimeFormat1 = DateFormat('d MMM yyyy, HH:mm');
  final DateFormat xDateTimeFormat2 = DateFormat('E, d MMM yyyy');

//image
  static const String dummyImage1 =
      'https://images.hindustantimes.com/rf/image_size_630x354/HT/p2/2020/11/14/Pictures/_ded48fd4-25fd-11eb-8924-93a7f7a2e27c.jpg';
  static const String dummyImage2 =
      'https://cdn-asset.jawapos.com/wp-content/uploads/2021/11/anak-main-560x390.jpg';
  static const String dummyImage3 =
      'https://res.cloudinary.com/ruparupa-com/image/upload/w_360,h_360,f_auto,q_auto/f_auto,q_auto:eco/v1589259712/Products/10408757_1.jpg';
  static const String dummyImage4 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6pBqLk0DIVFM0CbRI3nD6vz1Y4vwqaakhyq_VXCHXz-aGRPSI-blnsGytOjjSsJloLxU&usqp=CAU';
  static const String dummyImage5 =
      'https://www.unicef.org/indonesia/sites/unicef.org.indonesia/files/styles/two_column/public/IDN-Children-UN0296085.JPG';
// static const String dummyImage6 = '';
  static const String dummyImage6 =
      'https://www.news-medical.net/image.axd?picture=2016%2F3%2FChildren_playing_sunset_-_Zurijeta_8c5bdac77e44431bb1bfec67b9c87208-620x480.jpg';

  static const String loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eu cursus ex. Sed vel pulvinar leo, porttitor viverra nulla. Donec vel quam lacinia, gravida mauris vel, sodales velit. ';

  static const String sampleYoutube =
      'https://www.youtube.com/watch?v=1MudGuYglG0&ab_channel=PutraAdin';
  static const String sampleYoutubeId = '1MudGuYglG0';

  static const String photoProfile1 =
      "https://ragasport.com/ragasport/media/avatars/blank.png";
// "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=612x612&w=0&h=lGpj2vWAI3WUT1JeJWm1PRoHT3V15_1pdcTn2szdwQ0=";

  static const String userGuideUrl = "user-guide-mobile";
  static const String syaratKetentuanUrl = "webview?slug=syarat-dan-ketentuan";
  static const String kebijakanPrivasiUrl = "webview?slug=kebijakan-privasi";
  static const String faqUrl = "webview?slug=faq";
  static const String kontakUrl = "webview?slug=kontak";
}
