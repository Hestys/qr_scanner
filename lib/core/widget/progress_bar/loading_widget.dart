import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final color;

  LoadingWidget({this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white)),
    );
  }
}
