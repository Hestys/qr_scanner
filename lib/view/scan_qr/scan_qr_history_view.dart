import 'package:flutter/material.dart';
import '../../core/widget/progress_bar/loading_widget.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../../core/extension/context_extension.dart';

import '../../core/init/service/local_database/scan_qr_db_serviece.dart';

// ignore: must_be_immutable
class ScanQrHistory extends StatefulWidget {
  List? history;
  ScanQrHistory({history});

  @override
  _ScanQrHistoryState createState() => _ScanQrHistoryState();
}

class _ScanQrHistoryState extends State<ScanQrHistory> {
  final ScanQrHistoryDbService _databaseHelper = ScanQrHistoryDbService();

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: widget.history == null
          ? LoadingWidget()
          : ListView.builder(
              itemCount: widget.history!.length,
              itemBuilder: (context, index) {
                return buildCard(index);
              },
            ),
    );
  }

  Widget buildCard(int index) {
    return Card(
      color: context.colorScheme.primary,
      child: ListTile(
        onTap: () {},
        leading: Image.memory(widget.history![index].photo),
        title: Text(
          widget.history![index].text,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: buildShareButton(index),
        trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              await _databaseHelper.deleteForScan(widget.history![index].id);
              setState(() {
                getHistory();
              });
            }),
      ),
    );
  }

  Widget buildShareButton(int index) {
    return Row(
      children: [
        IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () async {
              if (widget.history![index].photo != null) {
                await WcFlutterShare.share(
                    sharePopupTitle: 'share',
                    fileName: 'share.png',
                    mimeType: 'image/png',
                    bytesOfFile: widget.history![index].photo);
              }
            })
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Scan Qr History',
      ),
    );
  }

  Future<void> getHistory() async {
    var historyFuture = await _databaseHelper.getScanHistory();
    setState(() {
      widget.history = historyFuture;
    });
  }
}
