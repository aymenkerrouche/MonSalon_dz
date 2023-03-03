// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:monsalondz/widgets/BlankImageWidget.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/Salon.dart';
import '../../providers/SalonProvider.dart';
import '../../theme/colors.dart';
import '../../utils/constants.dart';

class SalonScreen extends StatefulWidget {
  const SalonScreen({Key? key, required this.salon}) : super(key: key);
  final Salon salon;
  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen> {
  @override
  void initState() {
    super.initState();
    getSalon();
  }
  getSalon() async {
    await Provider.of<SalonProvider>(context,listen: false).setSalon(widget.salon);
  }
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Stack(
          children: [
            // PHOTOS
            SizedBox(
              height: size.height * 0.4,
              width: size.width,
              child: Consumer<SalonProvider>(
                builder: (context, salon, child) {
                  if(salon.search == false && salon.images.isEmpty){
                    return GFShimmer(
                      secondaryColor: primaryLite,
                      duration: const Duration(seconds: 2),
                      mainColor: clr3,
                      child: Container(
                          color: clr4
                      ),
                    );
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      disableCenter: true,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 15),
                    ),
                    items: List.generate(salon.images.length, (index) =>
                      CachedNetworkImage(
                        imageUrl: salon.images[index],
                        errorWidget: (cnx, photo, err) => const BlankImageWidget(error: true,),
                        placeholder: (context, s) => GFShimmer(
                              mainColor: clr4,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(14),),
                                  color: clr4
                                ),
                              ),
                            ),
                        imageBuilder: (context, imageProvider) => Ink.image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                  );
                }
              ),
            ),

            // LIKE
            Positioned(
              top: 2,
              right: 10,
              child: SafeArea(
                  top: true,
                  child: Consumer<SalonProvider>(builder: (context, salon, child){
                    return Container(
                      decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                      height: 40,
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        onPressed:() async {
                          counter++;
                          if(counter > 5){
                            GFToast.showToast("vous avez fait de nombreuses actions, réessayez plus tard", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                          }
                          else{
                            if(FirebaseAuth.instance.currentUser != null){
                              if(salon.salon?.isFavorite["like"] == true){
                                await salon.disLikeSalon();
                              }
                              else{
                                await salon.likeSalon();
                              }
                            }
                            else{
                              GFToast.showToast("il faut d'abord s'authentifier", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                            }

                          }
                        },
                        padding: EdgeInsets.zero,
                        isSelected: salon.salon?.isFavorite["like"],
                        icon: Icon(CupertinoIcons.heart,color: primary,size: 32,),
                        splashColor: clr4,
                        selectedIcon: Icon(CupertinoIcons.heart_fill,color: primaryLite,size: 32,),
                      ),
                    );
                  }),
              ),
            ),

            // BACK
            Positioned(
              top: 2,
              left: 8,
              child: SafeArea(
                top: true,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                  height: 40,
                  padding: EdgeInsets.zero,
                  child: IconButton(
                    onPressed:(){Navigator.pop(context);},
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.arrow_back_rounded,color: primary,size: 30,),
                    splashColor: clr4,

                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.63,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),

            // BODY
            Consumer<SalonProvider>(builder: (context, salon, child){
              if(salon.search == false && salon.salon?.id != ''){
                return DetailScreen(salon: salon.salon!,);
              }
              return SizedBox(
                height: size.height,
                child: Center(child: CircularProgressIndicator(color: primary,),));
            }),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.salon}) : super(key: key);
  final Salon salon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: .63,
      minChildSize: .63,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            controller: scrollController,
            children: [

              Container(
                height: 4,
                margin: EdgeInsets.only(left: size.width * 0.43,right:size.width * 0.43,top: 10,bottom: 30),
                decoration:  BoxDecoration(
                  color: primaryLite,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),

              SizedBox(
                height: size.height * 0.95,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TITRE
                      Text(
                        "${salon.nom}",
                        style: TextStyle(
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.w700,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 15,),

                      // LOCATION
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/location.svg", width: 18,height: 18, color: primaryLite,),
                          const SizedBox(width: 10,),
                          SizedBox(
                            width: size.width * 0.8,
                            child: Text("${salon.wilaya}, ${salon.commune}", style: const TextStyle(fontSize: 16,),
                              maxLines: 3,overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),

                      // RATE
                      Rate(rate: salon.rate ?? 5,),

                      //Description
                      Description(description: salon.description!,),

                      // PRESTATIONS
                      const ListPrestation(),


                      //HEURES  DE TRAVAIL
                      const WorkHours(),

                      Row(
                        children: [
                          Icon(CupertinoIcons.group,color: primaryLite,),
                          const SizedBox(width: 10,),
                          Text("Nos Experts", style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700,
                          ),),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: size.width,
                        margin: const EdgeInsets.only(top: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(salon.teams.length, (index) =>
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor: clr4,
                                      child: Text("${salon.teams[index].name?.substring(0,1)}".toUpperCase(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 20),),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text("${salon.teams[index].name}"),
                                ],
                              ),
                            )
                          ),
                        ),
                      ),

                      // DIVIDER
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Divider(
                            color: Colors.black38,
                            height: 50,
                          )
                      ),


                      //Contacts
                      ContactSection(phone: salon.phone!,location: salon.location!,latitude: salon.latitude!,longitude: salon.longitude!,),


                      //Comments
                      const CommentsList(),


                      // DIVIDER
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Divider(
                          color: Colors.black38,
                          height: 50,
                        )
                      ),


                      // BOOK
                      ElevatedButton(
                        onPressed:(){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryLite,
                          fixedSize: const Size(double.maxFinite, 55),
                          elevation: 6,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Réserver maintenant', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),),
                            const SizedBox(width: 15,),
                            SvgPicture.asset("assets/icons/book.svg",width: 26,height: 26,color: Colors.white,),
                          ],
                        ),
                      ),


                      const SizedBox(height: kToolbarHeight,)
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}

class Rate extends StatelessWidget {
  const Rate({Key? key, required this.rate,this.withText = true}) : super(key: key);
  final double rate;
  final bool withText;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RatingBar(
              initialRating: rate,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 22,
              ignoreGestures: true,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star_rate_rounded,color: clr3,),
                half: Icon(Icons.star_half_rounded,color: clr3,),
                empty: Icon(Icons.star_border_rounded,color: clr3,),
              ),
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(width: 15,),
            Text("$rate", style: const TextStyle(fontSize: 16,),
              maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
        if(withText)const SizedBox(height: 15.0),
      ],
    );
  }
}


class Description extends StatelessWidget {
  const Description({Key? key, required this.description}) : super(key: key);
  final String description;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/icons/badge.svg", width: 18,height: 18, color: primaryLite,),
            const SizedBox(width: 10,),
            Text("À propos", style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),),
          ],
        ),
        const SizedBox(height: 15.0),
        ReadMoreText(
          description,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' Plus',
          trimExpandedText: '   Moins',
          moreStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryLite),
          lessStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryLite),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }
}


class WorkHours extends StatelessWidget {
  const WorkHours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.calendar,color: primaryLite,),
            const SizedBox(width: 10,),
            Text("Horaires de travail", style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),),
          ],
        ),
        const SizedBox(height: 10.0),
        HeuresDeTravail(),
        const SizedBox(height: 20.0),
      ],
    );
  }
}


class ListPrestation extends StatelessWidget {
  const ListPrestation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/icons/cut.svg", width: 16, color: primaryLite,),
            const SizedBox(width: 10,),
            Text("Préstations", style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),),
          ],
        ),

        const SizedBox(height: 15.0),

         Consumer<SalonProvider>(builder: (context, salon, child){
           if(salon.salon!.service.isNotEmpty){
             return Column(
               children: salon.salon!.categories.map((e) => ExpansionTile(
                 title: Text(e.toUpperCase()),
                 iconColor: Colors.cyan,
                 textColor: Colors.cyan,
                 backgroundColor: primaryLite.withOpacity(.02),
                 children:salon.salon!.service.where((element) => element.category == e).map((service) =>
                     ListTile(
                       title: Text(service.service!,overflow: TextOverflow.ellipsis, maxLines: 2,),
                       trailing: Text(service.prixFin == 0 ? '${service.prix} DA' : '${service.prix} - ${service.prixFin} DA'),
                     ),
                 ).toList()
               )).toList(),

             );
           }
           return GFShimmer(
             mainColor: clr4,
             child: Column(
               children: [
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: const BorderRadius.all(Radius.circular(14)),
                     color: clr4,
                   ),
                   child: ListTile(
                     title:  Container(height: 15,decoration: BoxDecoration(
                       borderRadius: const BorderRadius.all(Radius.circular(14)),
                       color: clr4,
                     ),),
                     trailing: const Text('x xxx - x xxx DA',),
                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                     tileColor: clr3,
                     dense: true,
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: const BorderRadius.all(Radius.circular(14)),
                     color: clr4,
                   ),
                   child: ListTile(
                     title:  Container(height: 15,decoration: BoxDecoration(
                       borderRadius: const BorderRadius.all(Radius.circular(14)),
                       color: clr4,
                     ),),
                     trailing: const Text('x xxx - x xxx DA',),
                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                     tileColor: clr3,
                     dense: true,
                   ),
                 ),
               ],
             ),
           );
         }),

        const SizedBox(height: 15.0),
      ],
    );
  }
}


class HeuresDeTravail extends StatelessWidget {
  HeuresDeTravail({Key? key}) : super(key: key);
  String today = weekdayName[DateTime.now().weekday]?.toTitleCase() ?? '';

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonProvider>(builder: (context, salon, child) {
      if (salon.salon?.hours?.id != '') {
        return Column(
            children: [
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Dimanche' ? "Dimanche (aujourd'hui)" : "Dimanche",
                    overflow: TextOverflow.ellipsis, maxLines: 2,
                    style: TextStyle(
                        color: today == 'Dimanche' ? primaryLite : Colors
                            .black),
                  ),
                  trailing: Text(
                    salon.salon?.hours?.dimanche?["active"] == true ?
                    "${salon.salon?.hours?.dimanche?["start"]} - ${salon.salon
                        ?.hours?.dimanche?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.dimanche?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Lundi' ? "Lundi (aujourd'hui)" : 'Lundi',
                    style: TextStyle(
                        color: today == 'Lundi' ? primaryLite : Colors.black),
                    overflow: TextOverflow.ellipsis, maxLines: 2,),
                  trailing: Text(salon.salon?.hours?.lundi?["active"] == true ?
                  "${salon.salon?.hours?.lundi?["start"]} - ${salon.salon?.hours
                      ?.lundi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.lundi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Mardi' ? "Mardi (aujourd'hui)" : 'Mardi',
                    style: TextStyle(
                        color: today == 'Mardi' ? primaryLite : Colors.black),
                    overflow: TextOverflow.ellipsis, maxLines: 2,),
                  trailing: Text(salon.salon?.hours?.mardi?["active"] == true ?
                  "${salon.salon?.hours?.mardi?["start"]} - ${salon.salon?.hours
                      ?.mardi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.mardi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Mercredi' ? "Mercredi (aujourd'hui)" : 'Mercredi',
                    style: TextStyle(
                        color: today == 'Mercredi' ? primaryLite : Colors
                            .black),
                    overflow: TextOverflow.ellipsis, maxLines: 2,),
                  trailing: Text(
                    salon.salon?.hours?.mercredi?["active"] == true ?
                    "${salon.salon?.hours?.mercredi?["start"]} - ${salon.salon
                        ?.hours?.mercredi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.mercredi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Jeudi' ? "Jeudi (aujourd'hui)" : 'Jeudi',
                    overflow: TextOverflow.ellipsis, maxLines: 2,
                    style: TextStyle(
                        color: today == 'Jeudi' ? primaryLite : Colors.black),),
                  trailing: Text(salon.salon?.hours?.jeudi?["active"] == true ?
                  "${salon.salon?.hours?.jeudi?["start"]} - ${salon.salon?.hours
                      ?.jeudi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.jeudi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Vendredi' ? "Vendredi (aujourd'hui)" : 'Vendredi',
                    style: TextStyle(
                        color: today == 'Vendredi' ? primaryLite : Colors
                            .black),
                    overflow: TextOverflow.ellipsis, maxLines: 2,),
                  trailing: Text(
                    salon.salon?.hours?.vendredi?["active"] == true ?
                    "${salon.salon?.hours?.vendredi?["start"]} - ${salon.salon
                        ?.hours?.vendredi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.vendredi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListTile(
                  title: Text(
                    today == 'Samedi' ? "Samedi (aujourd'hui)" : 'Samedi',
                    style: TextStyle(
                        color: today == 'Samedi' ? primaryLite : Colors.black),
                    overflow: TextOverflow.ellipsis, maxLines: 2,),
                  trailing: Text(salon.salon?.hours?.samedi?["active"] == true ?
                  "${salon.salon?.hours?.samedi?["start"]} - ${salon.salon
                      ?.hours?.samedi?["fin"]}" : 'Fermé',
                    style: TextStyle(
                        color: salon.salon?.hours?.samedi?["active"] == true
                            ? Colors.black
                            : Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                ),
              ),
            ]

        );
      }
      return GFShimmer(
        mainColor: clr4,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                color: clr4,
              ),
              child: ListTile(
                title: Container(height: 15, decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: clr4,
                ),),
                trailing: const Text('08:00 - 19:00',),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                tileColor: clr3,
                dense: true,
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                color: clr4,
              ),
              child: ListTile(
                title: Container(height: 15, decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  color: clr4,
                ),),
                trailing: const Text('08:00 - 19:00',),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                tileColor: clr3,
                dense: true,
              ),
            ),
          ],
        ),
      );
    });
  }
}


class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.chat_bubble_2,color: primaryLite,),
            const SizedBox(width: 10,),
            Text("Commentaires", style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),),
          ],
        ),
        const SizedBox(height: 15.0),
        Consumer<SalonProvider>(builder: (context, salon, child){
          if(salon.salon!.comments.isNotEmpty){
            return  SizedBox(
              height: 85,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(salon.salon!.comments.length, (index) => Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: size.width * 0.7,
                    child: Material(
                      elevation: 5,
                      shape: const RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(14)),),
                      color: clr4.withOpacity(.15),
                      child: ListTile(
                        title: Text("${salon.salon!.comments[index].name}",overflow: TextOverflow.ellipsis, maxLines:2,),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.star_rate_rounded,color: Colors.yellow.shade700,),
                            Text("${salon.salon!.comments[index].rate}"),
                          ],
                        ),
                        subtitle: Text("${salon.salon!.comments[index].comment}",overflow: TextOverflow.ellipsis, maxLines:2,),
                      ),
                    ),
                  ),
                  )
              ),
            );
          }
          if(salon.search){
            return GFShimmer(
              mainColor: clr4,
              child: Material(
                elevation: 5,
                shape: const RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(14)),),
                color: clr4,
                child: ListTile(
                  title: Container(height: 15,decoration: const BoxDecoration(color: Colors.grey,borderRadius:  BorderRadius.all(Radius.circular(5)),),),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.star_rate_rounded,color: Colors.yellow.shade700,),
                      const Text("5",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                    ],
                  ),
                  subtitle: Container(height: 10,decoration: const BoxDecoration(color: Colors.grey,borderRadius:  BorderRadius.all(Radius.circular(5)),),),
                ),
              ),
            );
          }
          return GFShimmer(
            mainColor: primary,
            secondaryColor: clr4,
            duration: const Duration(seconds: 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  const Expanded(child: Text("aucun commentaire pour l'instant",style: TextStyle(fontSize: 16),maxLines: 1,)),
                  Image.asset("assets/icons/empty.png",height: 40,width: 40,),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          );

        }),
      ],
    );
  }
}


class ContactSection extends StatelessWidget {
  const ContactSection({Key? key, required this.phone, required this.location, required this.latitude, required this.longitude}) : super(key: key);
  final String phone;
  final String location;
  final double latitude;
  final double longitude;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Icon(CupertinoIcons.phone_circle,color: primaryLite,),
            const SizedBox(width: 10,),
            Text("Contactez - nous", style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w700,
            ),),
          ],
        ),
        const SizedBox(height: 15.0),
        if(phone != '') ContactTile(
          contact: phone,
          icon: CupertinoIcons.phone,
          ontap: () async {
            final Uri tlpn = Uri(scheme: 'tel', path: phone,);
            await launchUrl(tlpn);
          },
        ),
        if(phone != '') const SizedBox(height: 20.0),
        if(location != '') ContactTile(contact: location,
          icon: Icons.location_on_outlined,
          add: true,
          ontap: () async {
            if(latitude != 0 && longitude != 0){
              MapsLauncher.launchCoordinates(latitude, longitude, location);
            }
            else{
              MapsLauncher.launchQuery(location);
            }
          },
        ),

        if(phone == '' && location == '') GFShimmer(
          mainColor: primary,
          secondaryColor: clr4,
          duration: const Duration(seconds: 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 30),
                const Expanded(child: Text("Aucun contact fourni",style: TextStyle(fontSize: 16),maxLines: 1,)),
                Icon(Icons.phone_disabled_rounded, color: Colors.red.shade600,),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}


class ContactTile extends StatelessWidget {
  ContactTile({Key? key, required this.contact, required this.icon, this.add = false, required this.ontap}) : super(key: key);
  final String contact;
  final IconData icon;
  final bool add;
  void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(14)),),
      color: clr4.withOpacity(.2),
      child: InkWell(
        splashColor: clr4,
        borderRadius:  const BorderRadius.all(Radius.circular(14)),
        onTap: (){},
        child: ListTile(
          title: Text(contact,overflow: TextOverflow.ellipsis, maxLines:2,style: TextStyle(fontSize: add ? 14 : 16),),
          trailing: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: IconButton(
                onPressed:ontap,
                icon:  Icon(icon,color: primaryLite,),splashColor: clr4,)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        ),
      ),
    );
  }
}