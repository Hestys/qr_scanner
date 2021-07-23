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

class GenerateTextView extends StatefulWidget {
  GenerateTextView({Key? key}) : super(key: key);

  @override
  _GenerateTextViewState createState() => _GenerateTextViewState();
}

class _GenerateTextViewState extends State<GenerateTextView> {
  final TextEditingController _textEditingController = TextEditingController();
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
            StandartCard(byte: bytes),
            NormalSizedBox(),
            _buildInputTextFormField(),
            NormalSizedBox(),
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await _generateBarCode(_textEditingController.text);
          }
        });
  }

  Future<void> _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
    });
    await addDatabese();
  }

  Future<void> addDatabese() async {
    await _databaseHelper.insert(
        GenerateHistoryModel('Text', _textEditingController.text, bytes));
  }

  Widget _buildInputTextFormField() {
    return Form(
      key: _formKey,
      child: TextFormField(
          controller: _textEditingController,
          maxLines: 1,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          validator: (String? value) =>
              value!.isEmpty ? 'Please enter the text' : null,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.text_fields,
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
                  _textEditingController.text = data!.text.toString();
                });
              },
            ),
            hintText: 'Please Input Your Text',
          )),
    );
  }
}
