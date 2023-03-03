// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/widgets/PopularOffer.dart';
import 'package:provider/provider.dart';
import '../providers/CategoriesProvider.dart';

class Populars extends StatefulWidget {
  const Populars({Key? key}) : super(key: key);

  @override
  State<Populars> createState() => _PopularsState();
}

class _PopularsState extends State<Populars> {

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/vide.jpg'), context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Provider.of<CategoriesProvider>(context,listen: false).getPopularSalons();
    super.initState();
  }

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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 3),
                        blurRadius: 10,
                      )
                    ]
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

