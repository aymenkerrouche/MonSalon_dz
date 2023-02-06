import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Pubs extends StatefulWidget {
  const Pubs({Key? key}) : super(key: key);

  @override
  State<Pubs> createState() => _PubsState();
}

class _PubsState extends State<Pubs> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason){
                  setState(() {_current = index;});
                }
              ),
              items: List.generate(
                  Provider.of<AppSettingsProvider>(context,listen: false).bestSalonNumber, (index) =>
                    PopularOffer(salon: MiniSalon.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>),),
                )
            ),
            Row(
              children: [],
            )
          ],
        ),
    );
  }
}
