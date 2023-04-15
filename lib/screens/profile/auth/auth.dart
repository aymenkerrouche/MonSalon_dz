// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'components/sign_up_form.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          title: Container(
            margin: const EdgeInsets.only(bottom: 5,left: 10),
            child:  const Text(
              "Authentification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                //fontFamily: 'Rufik',
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
          titlePadding: EdgeInsets.zero,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const SignUpForm(),
      ),
    );
  }
}

