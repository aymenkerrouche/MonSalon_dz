import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../widgets/Photo_Profil.dart';
import 'user_information.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    print("*********************************************");
    return Scaffold(
      appBar: AppBar(
        title: const Text("update profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1),),
        backgroundColor: primary,
        centerTitle: true,
        leading: IconButton(
            onPressed:(){Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
      ),
      body:  const BodyUpdateProfil()
    );
  }
}

class BodyUpdateProfil extends StatelessWidget {
  const BodyUpdateProfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.5,left: 20,right: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: const [
              PhotoProfil(),
              SizedBox(height: 80),
              UpdateProfile(),
            ],
          ),
        ),
      ),
    );
  }
}




