// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';

class ListCatigories extends StatelessWidget {
  const ListCatigories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CategoriesProvider>(
      builder: (context, categories, child){
       return GridView.builder(
        itemCount: categories.categories.isEmpty ? 6 : categories.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: SizedBox(
              width: size.width * 0.45,
              height: 140,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  radius: 14,
                  highlightColor: primary,
                  splashColor: primary,
                  onTap: () {},
                  child: categories.done == true ?
                  CachedNetworkImage(
                    imageUrl: categories.categories[index].photo,
                    imageBuilder: (context, imageProvider) =>
                      Ink.image(
                        image: CachedNetworkImageProvider(categories.categories[index].photo),
                        fit: BoxFit.cover,
                        height: 140,
                        width: size.width * 0.45,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(14),),
                            color: Color(0x3C000000),
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

