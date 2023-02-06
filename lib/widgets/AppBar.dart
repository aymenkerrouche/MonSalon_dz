import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../theme/colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 5),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Image.asset('assets/images/logo.png'),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        offset: const Offset(1, 2),
                        blurRadius: 20,
                      )
                    ]),
                child: GestureDetector (
                  child:
                  SvgPicture.asset("assets/icons/setting.svg",height: 28,width: 28,color: Provider.of<ThemeProvider>(context,listen: false).primary),
                  onTap: (){ },)
            ),
          ),
        ],
      ),
    );
  }
}



