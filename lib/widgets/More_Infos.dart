// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MoreInfos extends StatelessWidget {
  MoreInfos({Key? key, required this.info,this.spclt= false}) : super(key: key);
  var info;
  final bool spclt;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20),),
        color: spclt ? primary : primary.withOpacity(0.07),
      ),
      child: Center(
        child: Row(
          children: [
            if(spclt) const Icon(Icons.location_on_outlined,color: Colors.white, size: 12,),
            if(spclt) const SizedBox(width: 5,),
            Text(
              info.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12,color: spclt ? white : primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

