import 'dart:convert';

import 'package:delivery_app/app/data/models/courier_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var hiddenKotaAsal = true.obs;
  var provAsalId = 0.obs;
  var kotaAsalId = 0.obs;

  var hiddenKotaTujuan = true.obs;
  var provTujuanId = 0.obs;
  var kotaTujuanId = 0.obs;

  var hiddenButton = true.obs;
  var kurir = "".obs;

  double berat = 0.0;
  String satuan = "gram";

  late TextEditingController beratC;

  @override
  void onInit() {
    beratC = TextEditingController(text: '$berat');
    super.onInit();
  }

  @override
  void onClose() {
    beratC.dispose();
    super.onClose();
  }

  void ongkosKirim() async {
    Uri uri = Uri.parse("https://api.rajaongkir.com/starter/cost");
    try {
      final response = await http.post(
        uri,
        body: {
          "origin": "$kotaAsalId",
          "destination": "$kotaTujuanId",
          "weight": "$berat",
          "courier": "$kurir",
        },
        headers: {
          "key": "91f1b1f96fa50c706f7ab25ce6226803",
          "content-type": "application/x-www-form-urlencoded",
        },
      );

      var data = json.decode(response.body) as Map<String, dynamic>;
      var results = data['rajaongkir']['results'] as List<dynamic>;

      var listAllResults = Courier.fromJsonList(results);
      var courier = listAllResults[0];

      Get.defaultDialog(
          title: courier.name ?? 'kosong',
          content: Column(
            children: courier.costs!
                .map(
                  (e) => ListTile(
                    title: Text(e.service ?? 'kosong'),
                    subtitle: Text("Rp ${e.cost![0].value}"),
                    trailing: Text(
                      courier.code == 'pos'
                          ? "${e.cost![0].etd}"
                          : "${e.cost![0].etd} HARI",
                    ),
                  ),
                )
                .toList(),
          ));
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.toString(),
      );
    }
  }

  void showButton() {
    if (kotaAsalId.value != 0 &&
        kotaTujuanId.value != 0 &&
        berat > 0 &&
        kurir.value != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }

  void ubahBerat(String value) {
    berat = double.tryParse(value) ?? 0.0;
    String cekSatuan = satuan;
    switch (cekSatuan) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 100;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
        berat = berat;
    }

    print("$berat gram");
    showButton();
  }

  void ubahSatuan(String value) {
    berat = double.tryParse(beratC.text) ?? 0.0;
    switch (value) {
      case "ton":
        berat = berat * 1000000;
        break;
      case "kwintal":
        berat = berat * 100000;
        break;
      case "ons":
        berat = berat * 100;
        break;
      case "lbs":
        berat = berat * 2204.62;
        break;
      case "pound":
        berat = berat * 2204.62;
        break;
      case "kg":
        berat = berat * 1000;
        break;
      case "hg":
        berat = berat * 100;
        break;
      case "dag":
        berat = berat * 10;
        break;
      case "gram":
        berat = berat;
        break;
      case "dg":
        berat = berat / 10;
        break;
      case "cg":
        berat = berat / 100;
        break;
      case "mg":
        berat = berat / 1000;
        break;
      default:
        berat = berat;
    }

    satuan = value;

    print("$berat gram");
    showButton();
  }
}
