// ignore_for_file: file_names
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import '../providers/SearchPrivider.dart';
import '../root.dart';
import '../theme/colors.dart';

class ListCatigories extends StatelessWidget {
  const ListCatigories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, categories, child){
       return GridView.builder(
          itemCount: categories.categories.isEmpty ? 6 : categories.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.0,
            mainAxisSpacing: 15,
            mainAxisExtent: 110
          ),
          itemBuilder: (BuildContext context, int index) {
            return Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                highlightColor: primary,
                splashColor: primary,
                onTap: () async {
                  categories.selectedCat = categories.categories[index];
                  Timer(const Duration(milliseconds: 600), () async {
                    controller.jumpToTab(1);
                    await Provider.of<SearchProvider>(context,listen: false).filterSalons(categories.categories[index].id, null, null, null);
                  });

                },
                child: categories.done == true && categories.categories.isNotEmpty ?
                CachedNetworkImage(
                  imageUrl: categories.categories[index].photo,
                  errorWidget: (cnx,photo,err)=>GFShimmer(
                    mainColor: Colors.grey.shade100,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(14),),
                        color: Colors.grey.shade50
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) =>
                    Ink.image(
                      image: CachedNetworkImageProvider(categories.categories[index].photo),
                      fit: BoxFit.cover,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14),),
                          color: Color(0x4C000000),
                        ),
                        child: Center(
                          child: Text(
                            categories.categories[index].category!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ):
                GFShimmer(
                    mainColor: Colors.grey.shade100,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),),
                          color: Colors.grey.shade50
                      ),
                    ),
                  ),
              ),
            );
          },
          controller: ScrollController(keepScrollOffset: false),
      );
     }
    );
  }
}

