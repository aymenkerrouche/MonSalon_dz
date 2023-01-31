// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/MiniSalon.dart';
import '../theme/colors.dart';
import 'BlankImageWidget.dart';
import 'More_Infos.dart';


class PopularOffer extends StatelessWidget {
  PopularOffer({Key? key, required this.salon}) : super(key: key);
  MiniSalon salon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(
              minHeight: 260,
              //maxHeight: 290
            ),
            margin: const EdgeInsets.only(bottom: 10) ,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12),),
                color: white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 3),
                    blurRadius: 10,
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Photo
                SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: "https://firebasestorage.googleapis.com/v0/b/monsalon-dz.appspot.com/o/salon%2FaqTP5g8ZulPgKdhCZr7J%2Fsalon2.jpg?alt=media&token=6db491b2-6fe8-4341-9a53-1f09f1515e41",
                      //offer.photo,
                      placeholder: (context, url) => const BlankImageWidget(),
                      errorWidget: (context, url, error) => const BlankImageWidget(error: true,),
                      imageBuilder: (context, imageProvider) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                          Positioned(
                            bottom: 10,right: 10,
                            child: SmallInfos(info: salon.wilaya ,isIcon: true, color: primary, textColor: Colors.white, icon: Icons.location_on_outlined,),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),

                // infos
                Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5,left: 10,right: 15,top: 5),
                        margin: const EdgeInsets.only(right: 55),
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          //maxHeight: 80,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            //Titre
                            Text(
                              salon.nom,
                              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5,),

                            // List more infos
                            SizedBox(
                              height: 20,
                              child: ListView(
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SmallInfos(info: salon.nom, color: primary.withOpacity(.05),textColor: primary,),
                                  const SizedBox(width: 6,),
                                  SmallInfos(info: salon.nom, color: primary.withOpacity(.05),textColor: primary,),
                                  const SizedBox(width: 5,),
                                  SmallInfos(info: salon.nom, color: primary.withOpacity(.05),textColor: primary,),
                                  const SizedBox(width: 5,),
                                  SmallInfos(info: salon.nom, color: primary.withOpacity(.05),textColor: primary,),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5,),

                          ],
                        ),
                      ),

                      //Rate
                      Positioned(
                        bottom: 7, top: 7, right: 10,
                        child: SizedBox(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.star_fill, color: Color(0xFFEFCA11),),
                              Text("4,6",style: TextStyle(color: primary,fontWeight: FontWeight.w700,fontSize: 18),)
                            ],
                          ),
                        )
                      )
                    ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
