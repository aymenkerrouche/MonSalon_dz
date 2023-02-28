import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../models/Salon.dart';
import '../../providers/SalonProvider.dart';
import '../../theme/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Stack(
          children: [
            SizedBox(
              height: size.height * 0.4,
              width: size.width,
              child: Consumer<SalonProvider>(
                  builder: (context, salon, child) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        //height: 300,
                        enlargeCenterPage: true,
                        disableCenter: true,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 15),
                      ),
                      items: List.generate(salon.images.length, (index) =>
                          CachedNetworkImage(
                            imageUrl: salon.images[index],
                            errorWidget: (cnx, photo, err) =>
                                GFShimmer(
                                  mainColor: Colors.grey.shade50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(14),),
                                        color: Colors.grey.shade50
                                    ),
                                  ),
                                ),
                            placeholder: (context, s) =>
                                GFShimmer(
                                  mainColor: clr4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(14),),
                                      color: clr4
                                    ),
                                  ),
                                ),
                            imageBuilder: (context, imageProvider) =>
                                Ink.image(
                                  image: CachedNetworkImageProvider(
                                      salon.images[index]),
                                  fit: BoxFit.cover,
                                ),
                          ),
                      ),
                    );
                  }
              ),
            ),
            Consumer<SalonProvider>(builder: (context, salon, child){
              if(salon.search == false ){
                return DetailScreen(salon: salon.salon!,);
              }
              return Center(child: CircularProgressIndicator(color: primary,),);
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
                          SvgPicture.asset("assets/icons/location.svg", width: 16, color: primaryLite,),
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
                      Row(
                        children: [
                          RatingBar(
                            initialRating: salon.rate ?? 5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            ignoreGestures: true,
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star_rate_rounded,color: clr3,),
                              half: Icon(Icons.star_half_rounded,color: clr3,),
                              empty: Icon(Icons.star_border_rounded,color: clr3,),
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(width: 15,),
                          Text("${salon.rate}", style: const TextStyle(fontSize: 16,),
                            maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      const SizedBox(height: 15.0),

                      //Description
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/badge.svg", width: 16, color: primaryLite,),
                          const SizedBox(width: 10,),
                          Text("À propos", style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700,
                          ),),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      ReadMoreText(
                        "${salon.description}",
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

                      // PRESTATIONS
                      const ListPrestation(),
                      const SizedBox(height: 15.0),

                      //HEURES  DE TRAVAIL
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/history.svg", width: 16, color: primaryLite,),
                          const SizedBox(width: 10,),
                          Text("Horaires de travail", style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700,
                          ),),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Dimanche',overflow: TextOverflow.ellipsis, maxLines: 2,),
                              trailing: Text('9:00 - 23:00'),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Lundi',overflow: TextOverflow.ellipsis, maxLines: 1,),
                              trailing: Text('10:00 - 22:00'),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text("Mardi (aujourd'hui)",overflow: TextOverflow.ellipsis, maxLines: 1,style: TextStyle(color: primaryLite),),
                              trailing: Text('9:00 - 22:00',style: TextStyle(color: primaryLite),),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Mercredi',overflow: TextOverflow.ellipsis, maxLines: 1,),
                              trailing: Text('9:00 - 22:00'),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Jeudi',overflow: TextOverflow.ellipsis, maxLines: 1,),
                              trailing: Text('11:00 - 21:00'),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Vendredi',overflow: TextOverflow.ellipsis, maxLines: 1,),
                              trailing: Text('Fermé',style: TextStyle(color: Colors.red),),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: ListTile(
                              title: Text('Samedi',overflow: TextOverflow.ellipsis, maxLines: 1,),
                              trailing: Text('9:00 - 22:00'),
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),


                      //Contacts
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/history.svg", width: 16, color: primaryLite,),
                          const SizedBox(width: 10,),
                          Text("Contactez - nous", style: TextStyle(
                            fontSize: size.width * 0.06,
                            fontWeight: FontWeight.w700,
                          ),),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      ContactTile(contact: "${salon.phone}",icon: CupertinoIcons.phone,),
                      const SizedBox(height: 10.0),
                      ContactTile(contact: "${salon.location}",icon: Icons.location_on_outlined,add: true,),


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
             print(salon.salon!.service.where((service) => service.category == "Epilation"));
             return Column(
               children: salon.salon!.categories.map((e) => ExpansionTile(
                   title: Text(e.toUpperCase()),
                   iconColor: Colors.cyan,
                   textColor: Colors.cyan,
                   backgroundColor: primaryLite.withOpacity(.02),
                   children:salon.salon!.service.where((element) => element.category == e).map((service) =>
                       ListTile(
                         title: Text(service.service!,overflow: TextOverflow.ellipsis, maxLines: 2,),
                         trailing: Text('${service.prix} - ${service.prixFin} DA'),
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


      ],
    );
  }
}


class ContactTile extends StatelessWidget {
  const ContactTile({Key? key, required this.contact, required this.icon, this.add = false}) : super(key: key);
  final String contact;
  final IconData icon;
  final bool add;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const RoundedRectangleBorder(borderRadius:  BorderRadius.all(Radius.circular(14)),),
      color: clr4,
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
              child: IconButton(onPressed:(){}, icon:  Icon(icon,color: primaryLite,),splashColor: clr4,)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        ),
      ),
    );
  }
}





/*Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Titre , Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //titre
                  Container(
                    width: size.width * 0.65,
                    child: Text(
                      "${offer!.name}",
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.w800,
                      ),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),

                  //Price
                  Container(
                    width: size.width * 0.25,
                    child: Text(
                      "${offer!.price} /year",
                      style: TextStyle(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade600),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),

              Text(
                "${offer!.logement_type}",
                style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600),
                textAlign: TextAlign.right,
              ),

              //Rating
              Padding(
                padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                child: SmoothStarRating(
                  starCount: 5,
                  color: red,
                  allowHalfRating: true,
                  rating: 4.0,
                  size: 15.0,
                  borderColor: primary,
                  onRatingChanged: (double rating) {},
                ),
              ),

              //Equipements
              Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: listCategories(),
              ),

              //Description
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              SizedBox(height: 15.0),
              ReadMoreText(
                "${offer!.description}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                trimLines: 4,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Hide',
                moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darker),
                lessStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: red),
              ),
              SizedBox(height: 25.0),

              //Location
              Text(
                "Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                  //address
                  Container(
                    width: size.width * 0.8,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "${offer!.location}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              //Map
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(2),
                height: size.height * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: primary)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 0.3,
                      widthFactor: 2.5,
                      child: Maps(
                        loca: lo!,
                        location: offer!.location!,
                      )),
                ),
              ),
              SizedBox(height: 25.0),

              //Comments
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openDialog();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/add.svg',
                        color: primary,
                        width: 28,
                        height: 28,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              listComments(),
              SizedBox(height: 25.0),

              //contacts
              Text(
                "Contacts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.width * 0.15,
                    width: size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        primary: primary.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                      ),
                      onPressed: () async {
                        final Uri tlpn = Uri(
                          scheme: 'smsto',
                          path: "0$phone",
                        );
                        await launchUrl(tlpn);
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/send.svg',
                            color: white,
                          ),
                          Text(
                            'SMS',
                            style: TextStyle(
                                fontSize: size.width * 0.05),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: size.width * 0.15,
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade500,
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                      ),
                      onPressed: () async {
                        final Uri tlpn = Uri(
                          scheme: 'tel',
                          path: "0$phone",
                        );
                        await launchUrl(tlpn);
                      },
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.phone_rounded),
                          Text(
                            'Call agency',
                            style: TextStyle(
                                fontSize: size.width * 0.05),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),*/
