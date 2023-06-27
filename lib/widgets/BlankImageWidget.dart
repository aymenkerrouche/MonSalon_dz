// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';

class BlankImageWidget extends StatelessWidget {
  const BlankImageWidget({Key? key, this.error = false}) : super(key: key);
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
          child: error? 
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: 0.0,
            child: SvgPicture.asset(
              "assets/icons/warning.svg",
              height: 80,
              width: 80,
            ),
          ):
          GFShimmer(child: Container(color: Colors.grey.shade50,))
      ),
    );
  }
}
