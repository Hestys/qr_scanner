import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../core/extension/context_extension.dart';

class CustomDetailButton extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  final String title;
  const CustomDetailButton(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: context.width * .3,
          height: context.height * .08,
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              AutoSizeText(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
        ),
      ),
    );
  }
}
