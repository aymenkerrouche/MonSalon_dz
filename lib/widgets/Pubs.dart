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
    Size size = MediaQuery.of(context).size;
    return Consumer<CategoriesProvider>(
      builder: (context, pubs, child) {
        if(pubs.ads == true){
          return GFShimmer(
            mainColor: Colors.grey.shade50,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(14),),
                  color: Colors.grey.shade50
              ),
            ),
          );
        }
        if(pubs.pubs.isNotEmpty){return CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              enlargeCenterPage: true,
              aspectRatio: 2,
              viewportFraction: .95,
            ),
            items: List.generate(pubs.pubs.length, (index) =>
                Material(
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    borderRadius: BorderRadius.circular(16),
                    highlightColor: primary.withOpacity(0.3),
                    onTap: () async {
                      final Uri url = Uri.parse(pubs.pubs[index].lien!);
                      await launchUrl(url,mode: LaunchMode.externalApplication);
                    },
                    child: SizedBox(
                      width: size.width,
                        child: Ink.image(image:CachedNetworkImageProvider(pubs.pubs[index].photo),fit: BoxFit.fill)),
                  ),
                ),
            )
        );}
        return const SizedBox();
      }
    );
  }
}

