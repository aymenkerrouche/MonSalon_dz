import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/MiniSalon.dart';
import '../../models/Salon.dart';
import '../../providers/SalonProvider.dart';
import '../../theme/colors.dart';


class SalonScreen extends StatefulWidget {
  const SalonScreen({Key? key,required this.salon}) : super(key: key);
  final MiniSalon salon;
  @override
  State<SalonScreen> createState() => _SalonScreenState();
}

class _SalonScreenState extends State<SalonScreen> {
  double? longitude;
  double? latitude;

  //LatLng? lo;

  @override
  void initState() {
    Provider.of<SalonProvider>(context, listen: false).getSalonImages(widget.salon.id!);
    super.initState();
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
              height: size.height * 0.35,
              width: size.width,
              child: Consumer<SalonProvider>(
                  builder: (context, salon, child) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
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
                                  mainColor: Colors.grey.shade50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(14),),
                                        color: Colors.grey.shade50
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
            bottomDetailsSheet(widget.salon)
          ],
        ),
      ),
    );
  }

  Widget bottomDetailsSheet(MiniSalon salon) {
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: .69,
      minChildSize: .69,
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
            padding: const EdgeInsets.only(top: 30),
            controller: scrollController,
            children: [
              /*Container(
                height: 4,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.45),
                decoration:  BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),*/
              Text(
                "${salon.nom}",
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.w800,
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        );
      },
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
