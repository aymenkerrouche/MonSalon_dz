import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/providers/HistouriqueLocal.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../utils/constants.dart';
import 'More_Infos.dart';


class RecentItem extends StatelessWidget {
  const RecentItem({ Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<HistoryProvider>(
        builder: (context, histories, child) {
          return Row(
            children: List.generate(categories.length, (index) =>
              Container(
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
                            highlightColor: primary.withOpacity(.1),
                            splashColor: primary,
                            onTap: () {},
                            child:
                            CachedNetworkImage(
                              imageUrl: "https://comfortel.com.au/wp-content/uploads/2021/05/3-Coastal-Salon-Furniture-Interior-Design-Salon.jpg",
                              imageBuilder: (context, imageProvider) =>
                                Ink.image(
                                  image: imageProvider, fit: BoxFit.cover,
                                  child: Stack(
                                    children: const [
                                      Positioned(
                                        bottom: 5,
                                        left: 10,
                                        child: SmallInfos(
                                          info: "Constantine",
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
                      child: const Text("Salon de beauté Hadjer beauty with Aymen",
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.black),),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
