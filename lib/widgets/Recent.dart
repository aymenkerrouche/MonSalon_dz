import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/providers/HistouriqueLocal.dart';
import 'package:monsalondz/widgets/BlankImageWidget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../models/Salon.dart';
import '../providers/SalonProvider.dart';
import '../screens/salon/SalonScreen.dart';
import '../theme/colors.dart';
import '../utils/keyboard.dart';
import 'More_Infos.dart';


class RecentItem extends StatelessWidget {
  const RecentItem({ Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HistoryProvider>(
      builder: (context, histories, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(histories.salonsHistory.isNotEmpty)Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 12,bottom: 10),
                child: const Text(
                  "Salons récents",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(histories.salonsHistory.length, (index) => Container(
                  height: 200,
                  width: size.width * 0.7,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 170,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.black12),
                            child: InkWell(
                              highlightColor: primary.withOpacity(.3),
                              splashColor: primary.withOpacity(.3),
                              onTap: () async {
                                EasyLoading.show();
                                FocusScope.of(context).unfocus();KeyboardUtil.hideKeyboard(context);

                                Provider.of<SalonProvider>(context,listen: false).search = true;
                                Provider.of<SalonProvider>(context,listen: false).clearSalon();

                                await FirebaseFirestore.instance.collection("salon").doc(histories.salonsHistory[index].id).get().then((snapshot){
                                  if(snapshot.data() != null){
                                    Salon salon = Salon.fromJson(snapshot.data()!);
                                    salon.id = histories.salonsHistory[index].id;
                                    EasyLoading.dismiss();
                                    PersistentNavBarNavigator.pushNewScreen(context,
                                      screen: SalonScreen(salon: salon),
                                      withNavBar: false,
                                      pageTransitionAnimation: PageTransitionAnimation.slideUp,
                                    );
                                  }
                                  else{
                                    EasyLoading.dismiss();
                                    GFToast.showToast("Erreur, Peut-être que le salon a été supprimé", context, toastDuration: 3, backgroundColor: red, textStyle: TextStyle(color: white), toastPosition: GFToastPosition.BOTTOM,);
                                  }
                                }).catchError((e){GFToast.showToast("$e", context, toastDuration: 3, backgroundColor: red, textStyle: TextStyle(color: white), toastPosition: GFToastPosition.BOTTOM,);});

                              },
                              child: CachedNetworkImage(
                                imageUrl: histories.salonsHistory[index].photo!,
                                errorWidget: (cnx,photo,err)=>const BlankImageWidget(error: true,),
                                imageBuilder: (context, imageProvider) => Ink.image(
                                    image: imageProvider, fit: BoxFit.cover,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 5,
                                          right: 10,
                                          child: SmallInfos(
                                            info: "${histories.salonsHistory[index].wilaya}",
                                            color: Colors.white,
                                            isIcon: true,
                                            icon: Icons.location_on_outlined,
                                            iconColor: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child:  Text("${histories.salonsHistory[index].nom}",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: Colors.black),),
                      )
                    ],
                  ),
                ),
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
