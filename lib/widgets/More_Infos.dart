import 'package:flutter/material.dart';

class SmallInfos extends StatelessWidget {
  const SmallInfos({Key? key, required this.info, required this.color, this.textColor = Colors.black, this.icon, this.isIcon = false, this.iconColor = Colors.white}) : super(key: key);
  final String info;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final bool isIcon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20),),
        color: color
      ),
      child: Center(
        child: Row(
          children: [
            if(isIcon) Icon(icon, color: iconColor, size: 12,),
            if(isIcon) const SizedBox(width: 2,),
            Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.6,),
              child: Text(
                info,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12,color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

