
// ignore_for_file: file_names, must_be_immutable

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/colors.dart';
import 'BlankImageWidget.dart';

class Brand extends StatelessWidget {
  Brand({Key? key, required this.data}) : super(key: key);
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {},
      child: Container(
        height: 90,
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 10,
            )
          ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CachedNetworkImage(
              imageUrl: data["pic"],
              fit: BoxFit.contain,
              height: 50,
              width: 60,
              errorWidget: (context, url, error) => const BlankImageWidget(error: true,),
            ),
            Text(
              data["brand"],
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}

class Brands extends StatefulWidget {
  const Brands({Key? key}) : super(key: key);

  @override
  State<Brands> createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  bool error = false;
  Stream<QuerySnapshot> brands = FirebaseFirestore.instance.collection('brands').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: brands,
      builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          setState(() {error = true;});
          return Text(
            snapshot.error.toString(),
            style: TextStyle(color: black),
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          error = false;
          List<Map<String, dynamic>> data = snapshot.data!.docs
            .map((DocumentSnapshot document) => document.data()! as Map<String, dynamic>)
            .toList();
          return AnimationLimiter(
            child: ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                snapshot.data!.docs.length,
                (index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: ScaleAnimation(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Brand(data: data[index],
                        )),
                    ),
                  ),
                )),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          Timer.periodic(const Duration(seconds: 15), (timer) {
            if (mounted) {
              setState(() {
                error = true;
                timer.cancel();
              });
            }
          });
          return Center(child: error
              ? const Text("verify your internet connection")
              : CircularProgressIndicator(color: primary,));
        }

        return const Center(
          child: Text("verify your internet connection"),
        );
      }),
    );
  }
}
