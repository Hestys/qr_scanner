import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../_product/widget/custom_detail_button.dart';
import '../_product/widget/normal_sized_box.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/regexp_constants.dart';
import '../../core/extension/context_extension.dart';

class ResultDetailView extends StatefulWidget {
  final String result;

  ResultDetailView({required this.result});

  @override
  _ResultDetailViewState createState() => _ResultDetailViewState();
}

class _ResultDetailViewState extends State<ResultDetailView> {
  final TextEditingController _outputController = TextEditingController();

  String link = '';

  @override
  void initState() {
    super.initState();
    setLabelText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: context.paddingMedium,
        child: Column(
          children: [
            buildResultTextFormField(),
            NormalSizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCopyDataButton(context),
                buildShareButton(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOpenWithWebButton(),
                buildSearchButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchButton() {
    return CustomDetailButton(
      title: 'Search',
      icon: Icon(
        Icons.search,
        color: Colors.white,
      ),
      onTap: () {
        launch('https://www.google.com/search?q=' + _outputController.text);
      },
    );
  }

  Widget buildOpenWithWebButton() {
    return CustomDetailButton(
      title: 'Open with\nBrowser',
      icon: Icon(
        Icons.launch,
        color: Colors.white,
      ),
      onTap: () {
        launch(_outputController.text);
      },
    );
  }

  Widget buildShareButton(BuildContext context) {
    return CustomDetailButton(
        title: 'Share',
        icon: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onTap: () {
          final box = context.findRenderObject() as RenderBox?;
          if (_outputController.text.isNotEmpty) {
            Share.share(_outputController.text,
                sharePositionOrigin:
                    box!.localToGlobal(Offset.zero) & box.size);
          }
        });
  }

  Widget buildCopyDataButton(BuildContext context) {
    return CustomDetailButton(
      title: 'Copy',
      icon: Icon(
        Icons.copy,
        color: Colors.white,
      ),
      onTap: () {
        if (_outputController.text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: _outputController.text));
          final snackBar = SnackBar(
              content: Text('Copied'), backgroundColor:context.colorScheme.primary);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Widget buildResultTextFormField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _outputController,
      maxLines: 1,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: link,
        hintText: 'You scan will be displayed in this area.',
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Show Details'),
    );
  }

  void setLabelText() {
    setState(() {
      _outputController.text = widget.result;

      if (_outputController.text
          .startsWith(RegexpConstans.instance.urlRegExp)) {
        link = 'Url';
      } else if (_outputController.text
          .startsWith(RegexpConstans.instance.emailRegExp)) {
        link = 'E-Mail';
      } else if (_outputController.text
          .startsWith(RegexpConstans.instance.telNumberRegExp)) {
        link = 'Telephone Number';
      } else {
        link = 'Text';
      }
    });
  }
}
