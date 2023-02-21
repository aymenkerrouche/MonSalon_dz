import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/colors.dart';

class PhotoProfil extends StatelessWidget {
  const PhotoProfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primary,width: 1),
      ),
      margin: const EdgeInsets.only(top: 30),
      child: FirebaseAuth.instance.currentUser?.photoURL == null ?
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset('assets/icons/user1.svg',color: primary,),
      ):
      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: CachedNetworkImage(
          imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
          progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(strokeWidth: 2,color: primary,),
          errorWidget: (context, url, error) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset('assets/icons/user1.svg',color: primary,),
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}