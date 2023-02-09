import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Pubs extends StatelessWidget {
  const Pubs({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Consumer<CategoriesProvider>(
        builder: (context, pubs, child) {
          return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              enlargeCenterPage: true,
              aspectRatio: 2,
              viewportFraction: 0.95,
            ),
              items: List.generate(pubs.pubs.length, (index) =>
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    highlightColor: primary.withOpacity(0.2),
                    splashFactory: NoSplash.splashFactory,
                    onTap: () async {
                      final Uri url = Uri.parse(pubs.pubs[index].lien!);
                      await launchUrl(url,mode: LaunchMode.externalApplication);
                    },
                    child: pubs.pubs[index].id == '0' ?

                    Ink.image(
                      image: AssetImage(pubs.pubs[index].photo),
                      fit: BoxFit.fill,
                    ):

                    CachedNetworkImage(
                      imageUrl: pubs.pubs[index].photo,
                      fit: BoxFit.fill,
                      imageBuilder: (context, imageProvider) => Ink.image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (cnx,photo,err)=> Ink.image(
                        image: AssetImage(pubs.pubs[index].photo),
                        fit: BoxFit.fill,
                      ),
                      placeholder: (context,s) => GFShimmer(
                        mainColor: Colors.grey.shade100,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(14),),
                              color: Colors.grey.shade50
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          );
        }
      ),
    );
  }
}

