// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'components/sign_up_form.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const SignUpForm(),
      ),
    );
  }
}

