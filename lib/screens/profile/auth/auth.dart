// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'components/sign_up_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ScrollController? _scrollController;


  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

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
              "Profil",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
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
          color: white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const SignUpForm(),
        ),
      );
  }
}
