// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:monsalondz/widgets/Category.dart';
import 'package:monsalondz/widgets/Populars.dart';
import '../theme/colors.dart';
import '../widgets/SearchBar.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
           color: Colors.white,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Container(
                height: 2200,
                width: size.width,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: [

                    //appBar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(top: 5),
                      height: 60,
                      width: size.width,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: size.width * 0.5,
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
                                SvgPicture.asset("assets/icons/setting.svg",height: 28,width: 28,color: primary),
                                onTap: (){ },)
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25,),

                    const SerachBar(),
                    const SizedBox(height: 25,),


                    //Categories
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,bottom: 10),
                        child: Text(
                          "Découvrir les soins",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.055,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 935,
                      padding: const EdgeInsets.all(5.0),
                      child: const ListCatigories()),

                    //Populars
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,bottom: 15),
                        child: Text(
                          "Meilleurs Salons",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.055,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 300, child: Populars()),



                    //SizedBox(height: 110, width: size.width, child: const Brands(),),
                    const SizedBox(height: 15,),
                    const SizedBox(height: 30,),

                    //Expanded(child: listCategoty()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
