import 'package:delivery_app/app/modules/home/views/widgets/berat.dart';
import 'package:delivery_app/app/modules/home/views/widgets/city.dart';
import 'package:delivery_app/app/modules/home/views/widgets/province.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongkos Kirim App'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Provinsi(tipe: 'asal'),
            Obx(
              () => controller.hiddenKotaAsal.isTrue
                  ? const SizedBox()
                  : Kota(
                      provId: controller.provAsalId.value,
                      tipe: 'asal',
                    ),
            ),
            const Provinsi(tipe: "tujuan"),
            Obx(
              () => controller.hiddenKotaTujuan.isTrue
                  ? const SizedBox()
                  : Kota(
                      provId: controller.provTujuanId.value,
                      tipe: "tujuan",
                    ),
            ),
            const BeratBarang(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DropdownSearch<Map<String, dynamic>>(
                mode: Mode.MENU,
                showClearButton: true,
                items: const [
                  {
                    "code": "jne",
                    "name": "Jalur Nugraha Ekakurir (JNE)",
                  },
                  {
                    "code": "tiki",
                    "name": "Titipan Kilat (TIKI)",
                  },
                  {
                    "code": "pos",
                    "name": "Perusahaan Opsional Surat (POS)",
                  },
                ],
                label: 'Tipe Kurir',
                hint: 'Pilih Tipe Kurir',
                onChanged: (value) {
                  if (value != null) {
                    controller.kurir.value = value['code'];
                    controller.showButton();
                  } else {
                    controller.hiddenButton.value = true;
                    controller.kurir.value = '';
                  }
                },
                itemAsString: (item) => '${item['name']}',
                popupItemBuilder: (context, item, isSelected) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "${item['name']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.hiddenButton.isTrue
                  ? const SizedBox()
                  : ElevatedButton(
                      onPressed: () => controller.ongkosKirim(),
                      child: const Text("CEK ONGKOS KIRIM"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        primary: Colors.green,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
