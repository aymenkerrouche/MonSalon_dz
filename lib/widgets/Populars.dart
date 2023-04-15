// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/widgets/PopularOffer.dart';
import 'package:provider/provider.dart';
import '../providers/CategoriesProvider.dart';


class Populars extends StatelessWidget {
  const Populars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
        builder: (context, populars, child){
          if(populars.populars.isEmpty){
            return GFShimmer(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12),),
                    color: Color(0x5AFFFFFF),

                ),
              ),
            );
          }
          return CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: .95,
              ),
              items: List.generate(populars.populars.length, (index) => PopularOffer(salon: populars.populars[index]),
              )
          );
        }
    );
  }
}


