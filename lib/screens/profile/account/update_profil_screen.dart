import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/colors.dart';
import 'user_information.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("update profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1),),
        backgroundColor: primary,
        centerTitle: true,
        leading: IconButton(
            onPressed:(){Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.5,left: 20,right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary,width: 1),
                    ),
                    margin: EdgeInsets.only(top: size.height * 0.05),
                    child: user?.photoURL == null ?
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset('assets/icons/user1.svg',color: primary,),
                    ):
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        imageUrl: user!.photoURL!,
                        progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(strokeWidth: 2,color: primary,),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.1),
                  UpdateProfile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
