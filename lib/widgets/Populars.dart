// ignore_for_file: file_names
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/providers/AppSettingsProvider.dart';
import 'package:monsalondz/widgets/PopularOffer.dart';
import 'package:provider/provider.dart';
import '../models/MiniSalon.dart';

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

  bool getBest = true;
  dynamic popularSalons = FirebaseFirestore.instance.collection('salon').where('best', isEqualTo: true).get();
  List<MiniSalon> offers= [];

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<QuerySnapshot>(
      future: popularSalons,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if(snapshot.hasData){
          if(snapshot.data!.docs.isEmpty && getBest == true){
            Timer(const Duration(seconds: 5), () {
              WidgetsBinding.instance.addPostFrameCallback((_){
                if (mounted) {
                  setState(() {
                    popularSalons =  FirebaseFirestore.instance.collection('salon').get();
                    getBest =  false;
                  });
                }

              });
            });

          }
          else{
            if( snapshot.connectionState == ConnectionState.done){
              if(snapshot.data!.docs.isNotEmpty){
                return CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      disableCenter: true,
                      viewportFraction: .95,
                    ),
                    items: List.generate(
                      Provider.of<AppSettingsProvider>(context,listen: false).bestSalonNumber, (index) =>
                        PopularOffer(salon: MiniSalon.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>),),
                    )
                );
              }
              else{
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Image.asset(
                          'assets/images/vide.jpg',fit: BoxFit.fill,
                          frameBuilder: (BuildContext? context, Widget? child, int? frame, bool wasSynchronouslyLoaded) {
                            return Padding(
                              padding: EdgeInsets.zero,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 25,
                      left: 25,
                      child: Text("Coming soon ...",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w700),))
                  ],
                );
              }
            }
          }
        }

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
      },
    );
  }
}

