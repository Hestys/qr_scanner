import 'package:flutter/material.dart';
import 'package:qr_scanner/core/widget/progress_bar/loading_widget.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

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

  void getHistory() async {
    var historyFuture = _databaseHelper.getScanHistory();

    await historyFuture.then((data) {
      setState(() {
        widget.history = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Qr History',
        ),
      ),
      body: widget.history == null
          ? LoadingWidget()
          : ListView.builder(
              itemCount: widget.history!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xff325CFD),
                  child: ListTile(
                    onTap: () {},
                    leading: Image.memory(widget.history![index].photo),
                    title: Text(
                      widget.history![index].text,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
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
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _databaseHelper
                              .deleteForScan(widget.history![index].id);
                          setState(() {
                            getHistory();
                          });
                        }),
                  ),
                );
              },
            ),
    );
  }
}
