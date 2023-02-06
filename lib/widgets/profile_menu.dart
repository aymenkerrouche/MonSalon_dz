import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.width = 22,
    this.press,
    this.bye = false
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;
  final double width;
  final bool bye;

  @override
  Widget build(BuildContext context) {
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1AE8E8E8),
            offset: Offset(0, 1),
            blurRadius: 1,
          )
        ]),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: providerColor.primary,
          padding: const EdgeInsets.all(20),
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.white,
          shadowColor: Colors.black12,
          elevation: 20,
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: providerColor.primary,
              width: width,
              height: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            bye ? SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: providerColor.primary,)) :const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
