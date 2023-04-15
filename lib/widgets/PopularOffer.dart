// ignore_for_file: file_names, must_be_immutable

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/utils/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../models/Salon.dart';
import '../providers/HistouriqueLocal.dart';
import '../providers/SalonProvider.dart';
import '../screens/salon/SalonScreen.dart';
import '../theme/colors.dart';
import 'BlankImageWidget.dart';
import 'More_Infos.dart';


class PopularOffer extends StatelessWidget {
  const PopularOffer({Key? key, required this.salon}) : super(key: key);
  final Salon salon;

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
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 10,top: 10) ,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14),),
                color: white,

            ),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: primary.withOpacity(.1),
                highlightColor: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                onTap: () async {
                  final provider =  Provider.of<SalonProvider>(context,listen: false);
                  provider.search = true;
                  Provider.of<HistoryProvider>(context,listen: false).setSalonsHistory(salon);

                  Timer(const Duration(milliseconds: 200),(){
                    PersistentNavBarNavigator.pushNewScreen(context,
                      screen: SalonScreen(salon: salon,),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                    );
                  });
                },

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // Photo
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                        child: CachedNetworkImage(
                          imageUrl: "${salon.photo}",
                          placeholder: (context, url) => const BlankImageWidget(),
                          errorWidget: (context, url, error) => const BlankImageWidget(error: true,),
                          imageBuilder: (context, imageProvider) => Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                              Positioned(
                                bottom: 10,right: 10,
                                child: SmallInfos(info: "${salon.wilaya}" ,isIcon: true, color: primary, textColor: Colors.white, icon: Icons.location_on_outlined,),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),

                    // infos
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10,top: 5),
                            margin: const EdgeInsets.only(right: 5),
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
                                  "${salon.nom}".toTitleCase(),
                                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5,),

                                // List more infos
                                SizedBox(
                                  height: 20,
                                  child:
                                  SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(salon.service.length, (index) => Container(margin: const EdgeInsets.only(right: 5),
                                        child: SmallInfos(info: "${salon.service[index].service}", color: primary.withOpacity(.03),textColor: primaryPro,)),),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),

                              ],
                            ),
                          ),
                        ),

                        //Rate
                        Container(
                          width: 50,
                          margin: const EdgeInsets.only(right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(flex: 1,child: Image.asset("assets/icons/rate.png",color: primaryPro,width: 35,)),
                              Flexible(flex: 1,child: Text("${salon.rate}",style: TextStyle(color: primaryPro,fontWeight: FontWeight.w700,fontSize: 18),))
                            ],
                          ),
                        )
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
