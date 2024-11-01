import 'package:flutter/material.dart';
import 'package:monsalondz/theme/colors.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.15,
      width: size.width * 0.3,
      child: CircleAvatar(
        backgroundColor: primary,
        child: Text(
          "A",
          style: TextStyle(fontSize: size.height * 0.1),
        ),
      ),
    );
  }
}
