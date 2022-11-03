import 'dart:convert';

import 'package:delivery_app/app/data/models/province_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controllers/home_controller.dart';

class Provinsi extends GetView<HomeController> {
  final String tipe;

  const Provinsi({
    Key? key,
    required this.tipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        label: tipe == 'asal' ? 'Provinsi Asal' : 'Provinsi Tujuan',
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse('https://api.rajaongkir.com/starter/province');

          try {
            final response = await http.get(url, headers: {
              'key': '91f1b1f96fa50c706f7ab25ce6226803',
            });

            var data = json.decode(response.body) as Map<String, dynamic>;

            var statusCode = data['rajaongkir']['status']['code'];

            if (statusCode != 200) {
              throw data['rajaongkir']['status']['description'];
            }

            var listAllProvince =
                data['rajaongkir']['results'] as List<dynamic>;

            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (e) {
            print(e);
            return List<Province>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            if (tipe == 'asal') {
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId ?? '');
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId ?? '');
            }
          } else {
            if (tipe == 'asal') {
              controller.hiddenKotaAsal.value = true;
              controller.provAsalId.value = 0;
            } else {
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: 'Cari Provinsi',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '${item.province}',
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => item.province ?? '',
      ),
    );
  }
}
