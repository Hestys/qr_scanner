import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../core/extension/context_extension.dart';
import '../../core/init/service/local_database/qr_generate_history_db_services.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import '../../model/generate_history_model.dart';
import '../_product/widget/normal_sized_box.dart';

class GenerateUrlView extends StatefulWidget {
  GenerateUrlView({key}) : super(key: key);

  @override
  _GenerateUrlViewState createState() => _GenerateUrlViewState();
}

class _GenerateUrlViewState extends State<GenerateUrlView> {
  final TextEditingController _urlTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Uint8List bytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: context.paddingMedium,
      child: Column(
        children: [
          StandartCard(
            byte: bytes,
          ),
          NormalSizedBox(),
          _buildUrlTextFormField(),
          NormalSizedBox(),
          _buildGenerateButton(),
        ],
      ),
    ));
  }

  Widget _buildUrlTextFormField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _urlTextEditingController,
        maxLines: 1,
        validator: (String? value) =>
            value!.isEmpty ? 'Please enter the url' : null,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.link,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            tooltip: 'Paste to ClipBoard',
            icon: Icon(
              Icons.paste,
              color: Colors.white,
            ),
            onPressed: () async {
              var data = await Clipboard.getData('text/plain');
              setState(() {
                _urlTextEditingController.text = data!.text.toString();
              });
            },
          ),
          hintText: 'http://www.example.com',
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await _generateBarCode(_urlTextEditingController.text);
            await addDatabese();
          }
        });
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
    });
  }

  Future<void> addDatabese() async {
    await _databaseHelper.insert(
        GenerateHistoryModel('Url', _urlTextEditingController.text, bytes));
  }
}
