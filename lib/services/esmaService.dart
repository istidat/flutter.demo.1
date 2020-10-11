import 'dart:math';
import 'package:get/get.dart';
import 'package:videotor/api/response/index.dart';

enum EsmaMode { daily, random }
enum EsmaSource { green, black, sayings }
enum EsmaQuality { high, low }

class EsmaService extends GetxService {
  EsmaSource source;
  EsmaQuality quality;
  EsmaMode mode;
  int i;
  List<String> path;
  int number;

  EsmaService init({
    EsmaSource source: EsmaSource.black,
    EsmaQuality quality: EsmaQuality.high,
    EsmaMode mode: EsmaMode.daily,
  }) {
    this.source = source;
    this.quality = quality;
    this.mode = mode;
    i = -1;
    path = <String>[];
    number = 0;
    if (source == EsmaSource.green) {
      for (number = 1; number < 100; number++) {
        if (number < 10) {
          path.add("Image0000$number");
        } else if (number < 100 && number > 9) {
          path.add("Image000$number");
        }
      }

      if (quality == EsmaQuality.high) {
        for (var a = 0; a < path.length; a++) {
          path[a] = "YesilGorsel/" + "high_q/" + path[a] + ".jpg";
        }
        //var source = "high_q/Image00001.jpg";
      } else if (quality == EsmaQuality.low) //LOW quality durumu
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "YesilGorsel/" + "low_q/" + path[a] + ".jpg";
        }
        //var source = "low_q/Image00001.jpg";
      } else //High ya da low değilse ya da boş bırakılmışsa default medium getirilir
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "YesilGorsel/" + "medium_q/" + path[a] + ".jpg";
        }
        //var source = "medium_q/Image00001.jpg";
      }
    } else if (source == EsmaSource.sayings) {
      for (number = 0; number < 820; number++) {
        if (number < 10 && number > 0) {
          path.add("Image0000$number");
        } else if (number < 100 && number > 9) {
          path.add("Image000$number");
        } else if (number < 1000 && number > 99) {
          path.add("Image00$number");
        } else if (number < 10000 && number > 999) {
          path.add("Image0$number");
        } else {
          path.add("Image$number");
        }
      }

      if (quality == EsmaQuality.high) {
        for (var a = 0; a < path.length; a++) {
          path[a] = "DiniGorsel/" + "high_q/" + path[a] + ".jpg";
        }
        // var source = "high_q/Image00000.jpg";
      } else if (quality == EsmaQuality.low) //LOW quality durumu
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "DiniGorsel/" + "low_q/" + path[a] + ".jpg";
        }
        //var source = "low_q/Image00000.jpg";
      } else //High ya da low değilse ya da boş bırakılmışsa default medium getirilir
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "DiniGorsel/" + "medium_q/" + path[a] + ".jpg";
        }
        //var source = "medium_q/Image00000.jpg";
      }
    } else {
      path.add("2_Allah.");
      path.add("3_Rahman.");
      path.add("3_rahim.");
      path.add("5_melik.");
      path.add("6_kuddus.");
      path.add("7_selam.");
      path.add("8_mumin.");
      path.add("9_muheymin.");
      path.add("10_aziz.");
      path.add("11_cabbar.");
      path.add("12_mutekebbir.");
      path.add("13_elhalik.");
      path.add("14_bari.");
      path.add("15_musavvir.");
      path.add("16_gaffar.");
      path.add("17_muktedir.");
      path.add("18_rezzak.");
      path.add("19_muizz.");
      path.add("20_resid.");
      path.add("21_baki.");
      path.add("22_veli.");
      path.add("23_mukit.");
      path.add("24_vacid.");
      path.add("25_mani.");
      path.add("26_hasib.");
      path.add("27_kaviy.");
      path.add("28_mubdi.");
      path.add("29_cami.");
      path.add("30_afuv.");
      path.add("31_azim.");
      path.add("32_hamid.");
      path.add("33_mukaddim.");
      path.add("34_vasi.");
      path.add("35_hadi.");
      path.add("36_kahhar.");
      path.add("37_nur.");
      path.add("38_gafur.");
      path.add("39_sekur.");
      path.add("40_Aliyy.");
      path.add("41_kadir.");
      path.add("42_hafiz.");
      path.add("43_malikulmulk.");
      path.add("44_tevvab.");
      path.add("45_vedud.");
      path.add("46_rauf.");
      path.add("47_macid.");
      path.add("48_berr.");
      path.add("49_hayy.");
      path.add("50_evvel.");
      path.add("51_semi.");
      path.add("52_ahir.");
      path.add("53_basit.");
      path.add("54_habir.");
      path.add("55_hakk.");
      path.add("56_mugni.");
      path.add("57_varis.");
      path.add("58_muksit.");
      path.add("59_vehhab.");
      path.add("60_muteal.");
      path.add("61_adl.");
      path.add("62_kerim.");
      path.add("63_kabid.");
      path.add("64_sehid.");
      path.add("65_kayyum.");
      path.add("66_bedi.");
      path.add("67_gani.");
      path.add("68_mecid.");
      path.add("69_bais.");
      path.add("70_dar.");
      path.add("71_hakim.");
      path.add("72_fettah.");
      path.add("73_sabur.");
      path.add("74_muahhir.");
      path.add("75_halim.");
      path.add("76_mucib.");
      path.add("77_vali.");
      path.add("78_hafid.");
      path.add("79_vekil.");
      path.add("80_latif.");
      path.add("81_nafi.");
      path.add("82_vahid.");
      path.add("83_muntekim.");
      path.add("84_batin.");
      path.add("85_muhsi.");
      path.add("86_rafi.");
      path.add("87_kebir.");
      path.add("88_celil.");
      path.add("89_basir.");
      path.add("90_muzil.");
      path.add("91_metin.");
      path.add("92_hakem.");
      path.add("93_zulcelalivelikram.");
      path.add("94_muid.");
      path.add("95_zahir.");
      path.add("96_muhyi.");
      path.add("97_samed.");
      path.add("98_alim.");
      path.add("99_rakib.");
      path.add("100_mumit.");
      number = 99;
      if (quality == EsmaQuality.high) {
        for (var a = 0; a < path.length; a++) {
          path[a] = path[a] + "JPG";
        }
        //var source = "2_Allah.JPG";
      } else if (quality == EsmaQuality.low) //LOW quality durumu
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "low_q/" + path[a] + "jpg";
        }
        //var source = "low_q/2_Allah.jpg";
      } else //High ya da low değilse ya da boş bırakılmışsa default medium getirilir toplamda yaklasik 2 mb tanesi 25 kb
      {
        for (var a = 0; a < path.length; a++) {
          path[a] = "medium_q/" + path[a] + "jpg";
        }
        //var source = "medium_q/2_Allah.jpg";
      }
    }
    return this;
  }

  EsmaResponse getResponse() {
    if (mode == EsmaMode.daily) {
      var currentTime = DateTime.now();
      var month = currentTime.month;
      var day = currentTime.day;
      i = (((month * 31 + day) % number)).floor();
    } else if (mode == EsmaMode.random) {
      final rng = new Random();
      i = (rng.nextDouble() * number).floor();
    }
    return EsmaResponse(
        path: "http://www.kaabalive.net/EsmaulHusna/${path[i]}");
  }
}
