import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/scan_qr_db_serviece.dart';
import '../../core/widget/button/standart_button.dart';
import '../../model/scan_history_model.dart';
import '../_product/widget/normal_sized_box.dart';
import '../base/result_detail_view.dart';
import 'scan_qr_history_view.dart';

class QrScanScreen extends StatefulWidget {
  QrScanScreen({key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final TextEditingController _outputController = TextEditingController();

  final GlobalKey key = GlobalKey<ScaffoldState>();

  final ScanQrHistoryDbService _dbService = ScanQrHistoryDbService();

  String? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
            padding: context.paddingMedium,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      'assets/asa.png',
                      height: context.height * 0.4,
                    ),
                  ],
                ),
                NormalSizedBox(),
                _buildOutTextField(),
                NormalSizedBox(),
                StandartButton(
                    title: 'SCAN QR',
                    onTap: () {
                      _scan();
                    }),
              ],
            )));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Scan QR',
      ),
      actions: [
        IconButton(
          alignment: Alignment.center,
          padding: EdgeInsets.only(),
          tooltip: 'History',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScanQrHistory()));
          },
          icon: Icon(
            Icons.restore,
            color: Colors.white,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _scan() async {
    await Permission.camera.request();
    barcode = await scanner.scan();
    if (barcode == null) {
      print('Nothing return.');
    } else {
      setState(() {
        _outputController.text = barcode!;
      });

      await _dbService.insertForScan(
          ScanHistoryModel(barcode, await scanner.generateBarCode(barcode!)));

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ResultDetailView(result: _outputController.text)));
    }
  }

  Widget _buildOutTextField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _outputController,
      maxLines: 1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: Column(
          children: [
            IconButton(
              tooltip: 'Details',
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () async {
                if (_outputController.text.isNotEmpty &&
                    _outputController.text.isNotEmpty) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultDetailView(
                              result: _outputController.text)));
                } else {
                  //showAlertDialog(context);
                }
              },
            ),
          ],
        ),
        prefixIcon: Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: 'Result will be here.',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
