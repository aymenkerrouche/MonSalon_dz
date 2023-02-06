// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeProvider.dart';

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
              elevation: 10,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                radius: 14,
                highlightColor: Provider.of<ThemeProvider>(context,listen: false).primary,
                splashColor: Provider.of<ThemeProvider>(context,listen: false).primary,
                onTap: () {},
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
                            categories.categories[index].category,
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

