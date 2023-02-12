import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monsalondz/models/Category.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import '../providers/SearchPrivider.dart';
import '../theme/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: clr4,
          flexibleSpace: SafeArea(
            top: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SearchBar(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      SizedBox(width: 16,),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                      FilterCategory(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8,left: 16,right: 16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 7,
              spreadRadius: 1
          )
        ]
      ),
      child: Consumer<SearchProvider>(
        builder: (context, search, child) {
          return TextField(
            cursorColor: primary,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            controller: search.search,
            cursorHeight: 24,
            cursorRadius: const Radius.circular(20),
            decoration: InputDecoration(
              hintText: "Prestation ...",
              hintStyle: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 18),
              border: InputBorder.none,
              suffixIcon: IconButton(
                  icon: Icon(Icons.close_rounded, color: primary),
                  padding: EdgeInsets.zero,
                  onPressed: () {search.search.clear();}
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left:10),
                child: Icon(Icons.search, color: primaryPro,),
              ),
            ),
          );
        }
      ),
    );
  }
}


class FilterCategory extends StatelessWidget {
  const FilterCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      margin: const EdgeInsets.only(right: 15),
      child:Consumer<CategoriesProvider>(
          builder: (cxt, categories, child){
            return RawChip(
              label: Text( categories.selectedCat.id == '' ? "Categoré" : categories.selectedCat.category!,style: TextStyle(color: categories.selectedCat.id == '' ? primary : white ),),
              avatar: Container(
                margin: const EdgeInsets.only(left: 6),
                child: categories.selectedCat.id == '' ?
                SvgPicture.asset("assets/icons/category.svg", width: 16, color: primary,):
                Icon(Icons.check_rounded, color: white,),
              ),
              backgroundColor: Colors.white,
              selected: categories.selectedCat.id == '' ? false: true ,
              showCheckmark: false,
              selectedColor: primary,
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    builder: (context) {
                      return Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              height: 4,
                              width: 30,
                              margin: const EdgeInsets.only(top: 5,bottom: 30),
                              decoration:  BoxDecoration(
                                color: primaryPro,
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            const Text( "Sélectionner une catégorie", maxLines: 2,style: TextStyle(fontSize: 20, color: Colors.black),),
                            const SizedBox(height: 25,),
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: size.height * 0.6
                              ),
                              child: SingleChildScrollView(
                                child: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) =>Column(
                                    children: categories.categories.map((e) =>
                                        Container(
                                          decoration:  BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                                            color: e.id == categories.selectedCat.id ? clr4 : Colors.white ,
                                          ),
                                          height: 50,
                                          margin: const EdgeInsets.only(bottom: 20),
                                          child: InkWell(
                                            splashColor: clr4,
                                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                                            onTap: (){
                                              if(categories.selectedCat.id == e.id){
                                                setState((){categories.selectedCat = Category('', '', '');});
                                              }
                                              else{
                                                setState((){categories.selectedCat = e;});
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 30,),
                                                Text(e.category!, style: TextStyle(color: primary,fontSize: 20,fontWeight: FontWeight.w600),),
                                                const Spacer(),
                                                if(e.id == categories.selectedCat.id) const Icon(Icons.check_rounded,size: 25,),
                                                const SizedBox(width: 30,),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ).toList(),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  fixedSize: const Size(double.maxFinite, 45),
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Appliquer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),),
                                  SizedBox(width: 15,),
                                  Icon(CupertinoIcons.search,color: Colors.white)
                                ],
                              ),

                            ),
                            const SizedBox(height: kToolbarHeight,),
                          ],
                        ),
                      );
                    }
                );
              },
            );
          }
      ),
    );
  }
}

