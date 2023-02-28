import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:monsalondz/models/Category.dart' as cat;
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:monsalondz/screens/salon/SalonScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../models/Salon.dart';
import '../providers/SalonProvider.dart';
import '../providers/SearchPrivider.dart';
import '../theme/colors.dart';
import '../utils/constants.dart';
import '../utils/keyboard.dart';
import '../utils/wilaya.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                SizedBox(
                  width: size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        SizedBox(width: 16,),
                        FilterCategory(),
                        FilterWilaya(),
                        FilterPrix(),
                        FilterDate(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(bottom: 55),
        child: const SalonList(),
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
                String searchEntry = categories.selectedCat.category ?? "";
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
                                            setState((){categories.selectedCat = cat.Category('', '', '');});
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
                              //if(categories.selectedCat.id != ''){
                                //Provider.of<SearchProvider>(context,listen: false).fetchSalonsCategory(categories.selectedCat.category!);
                                Navigator.pop(context);
                              //}
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
                          const SizedBox(height: 15,),
                          OutlinedButton(
                            onPressed: (){
                              categories.selectedCat = cat.Category('', '', '');
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                              side: BorderSide(color: Colors.red.shade800, width: 1),
                              foregroundColor: Colors.red.shade800,
                              fixedSize: const Size(double.maxFinite, 45),
                            ),
                            child: Text("Effacer la catégorie", style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.w600,fontSize: 20),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  }
                ).whenComplete((){

                  final provider = Provider.of<SearchProvider>(context,listen: false);
                  String searchSortie = categories.selectedCat.category ?? "";

                  if(searchSortie != searchEntry){
                    var serarchedWilaya;
                    if(provider.searchWilaya.text.isNotEmpty) serarchedWilaya = wilaya.where((element) => provider.searchWilaya.text.contains(element["name"]!)).first;
                    provider.filterSalons(
                        categories.selectedCat.id == '' ? null:categories.selectedCat.id,
                        serarchedWilaya != null ? serarchedWilaya["name"]:null,
                        provider.prixFin == 0 ? null : provider.prixFin,
                        provider.day == ''? null : provider.day
                    );
                  }
                });
              },
            );
          }
      ),
    );
  }
}


class FilterPrix extends StatelessWidget {
  const FilterPrix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      margin: const EdgeInsets.only(right: 15),
      child:Consumer<SearchProvider>(
          builder: (cxt, prix, child){
            return RawChip(
              label: Text( prix.prixFin == 0 ? "Prix" : "${prix.prix} - ${prix.prixFin} DA",style: TextStyle(color: prix.prixFin == 0 ? primary : white ),),
              avatar: Container(
                margin: const EdgeInsets.only(left: 6),
                child: prix.prixFin == 0 ?
                SvgPicture.asset("assets/icons/money.svg", width: 16, color: primary,):
                Icon(Icons.check_rounded, color: white,),
              ),
              backgroundColor: Colors.white,
              selected: prix.prixFin == 0 ? false: true ,
              showCheckmark: false,
              selectedColor: primary,
              onPressed: (){
                double searchEntry = prix.prixFin;
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
                          const Text( "Saisir le prix", maxLines: 2,style: TextStyle(fontSize: 20, color: Colors.black),),
                          const SizedBox(height: 35,),
                          SingleChildScrollView(
                            child: StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) =>
                                SliderTheme(
                                  data: SliderThemeData(
                                      valueIndicatorColor: primary,
                                      rangeValueIndicatorShape:  const PaddleRangeSliderValueIndicatorShape(),
                                    ),
                                  child: RangeSlider(
                                    values: prix.rangeValues,
                                    min: 0,
                                    max: 10000,
                                    divisions: 10,
                                    activeColor: primary,
                                    inactiveColor: clr3,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        prix.rangeValues = RangeValues(values.start, values.end);
                                      });
                                    },
                                    labels: RangeLabels("${prix.rangeValues.start} DA", "${prix.rangeValues.end} DA"),
                                  ),
                                )
                            ),
                          ),
                          const SizedBox(height: 35,),
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
                          const SizedBox(height: 15,),
                          OutlinedButton(
                            onPressed: (){
                              prix.rangeValues = const RangeValues(0, 0);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                              side: BorderSide(color: Colors.red.shade800, width: 1),
                              foregroundColor: Colors.red.shade800,
                              fixedSize: const Size(double.maxFinite, 45),
                            ),
                            child: Text("Effacer le prix", style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.w600,fontSize: 20),
                            ),
                          ),
                          const SizedBox(height:10,),
                        ],
                      ),
                    );
                  }
                ).whenComplete((){
                  double searchSortie = prix.prixFin;
                  if(searchSortie != searchEntry){
                    final provider = Provider.of<CategoriesProvider>(context,listen: false);
                    var serarchedWilaya;
                    if(prix.searchWilaya.text.isNotEmpty)serarchedWilaya = wilaya.where((element) => prix.searchWilaya.text.contains(element["name"]!)).first;

                    prix.filterSalons(
                        provider.selectedCat.id == '' ? null:provider.selectedCat.id,
                        serarchedWilaya != null ? serarchedWilaya["name"]:null,
                        prix.prixFin == 0 ? null : prix.prixFin,
                        prix.day == ''? null:prix.day
                    );
                  }
                });
              },
            );
          }
      ),
    );
  }
}


class FilterWilaya extends StatelessWidget {
  const FilterWilaya({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      margin: const EdgeInsets.only(right: 15),
      child:Consumer<SearchProvider>(
          builder: (cxt, wilayas, child){
            return RawChip(
              label: Text(wilayas.searchWilaya.text.isEmpty ? "Wilaya" : wilayas.searchWilaya.text ,style: TextStyle(color: wilayas.searchWilaya.text.isEmpty ? primary : white ),),
              avatar: Container(
                margin: const EdgeInsets.only(left: 6),
                child: wilayas.searchWilaya.text.isEmpty ?
                SvgPicture.asset("assets/icons/location.svg", width: 16, color: primary,):
                Icon(Icons.check_rounded, color: white,),
              ),
              backgroundColor: Colors.white,
              selected: wilayas.searchWilaya.text.isEmpty ? false: true ,
              showCheckmark: false,
              selectedColor: primary,
              onPressed: (){
                String searchEntry = wilayas.searchWilaya.text;
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
                          const Text( "Choisir la wilaya", maxLines: 2,style: TextStyle(fontSize: 20, color: Colors.black),),
                          const SizedBox(height: 35,),
                          Container(
                            constraints: BoxConstraints(
                                maxHeight: size.height * 0.6
                            ),
                            child: SingleChildScrollView(
                              child: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) =>Column(
                                  children: wilaya.map((e) =>
                                    Container(
                                      decoration:  BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        color: wilayas.searchWilaya.text.contains('${e['code']!}  ${e['name']!}') ? clr4 : Colors.white ,
                                      ),
                                      height: 50,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        splashColor: clr4,
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        onTap: (){
                                          if( wilayas.searchWilaya.text == '${e['code']!}  ${e['name']!}'){
                                            setState((){wilayas.clearWilaya();});
                                          }
                                          else{
                                            setState((){
                                              wilayas.setWilaya('${e['code']!}  ${e['name']!}');
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 30,),
                                            Text('${e['code']!}  ${e['name']!}', style: TextStyle(color: primary,fontSize: 20,fontWeight: FontWeight.w600),),
                                            const Spacer(),
                                            if(wilayas.searchWilaya.text.contains('${e['code']!}  ${e['name']!}')) const Icon(Icons.check_rounded,size: 25,),
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
                          const SizedBox(height: 35,),
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
                          const SizedBox(height: 15,),
                          OutlinedButton(
                            onPressed: (){
                              wilayas.clearWilaya();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                              side: BorderSide(color: Colors.red.shade800, width: 1),
                              foregroundColor: Colors.red.shade800,
                              fixedSize: const Size(double.maxFinite, 45),
                            ),
                            child: Text("Effacer la wilaya", style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.w600,fontSize: 20),
                            ),
                          ),
                          const SizedBox(height:10,),
                        ],
                      ),
                    );
                  }
                )
                .whenComplete(() {
                  String searchSortie = wilayas.searchWilaya.text;
                  if(searchSortie != searchEntry){
                      final provider = Provider.of<CategoriesProvider>(context,listen: false);
                      var serarchedWilaya;
                      if(wilayas.searchWilaya.text.isNotEmpty)serarchedWilaya = wilaya.where((element) => wilayas.searchWilaya.text.contains(element["name"]!)).first;

                      wilayas.filterSalons(
                          provider.selectedCat.id == '' ? null:provider.selectedCat.id,
                          serarchedWilaya != null ? serarchedWilaya["name"]:null,
                          wilayas.prixFin == 0 ? null : wilayas.prixFin,
                          wilayas.day == ''? null:wilayas.day
                      );
                  }
                });
              },
            );
          }
      ),
    );
  }
}


class FilterDate extends StatelessWidget {
  const FilterDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(right: 15),
      child:Consumer<SearchProvider>(
        builder: (cxt, date, child){
          return RawChip(
            label: Text(date.searchDate.text.isEmpty ? "Date" : date.searchDate.text ,style: TextStyle(color: date.searchDate.text.isEmpty ? primary : white ),),
            avatar: Container(
              margin: const EdgeInsets.only(left: 6),
              child: date.searchDate.text.isEmpty ?
              SvgPicture.asset("assets/icons/history.svg", width: 16, color: primary,):
              Icon(Icons.check_rounded, color: white,),
            ),
            backgroundColor: Colors.white,
            selected: date.searchDate.text.isEmpty ? false: true ,
            showCheckmark: false,
            selectedColor: primary,
            onPressed: () async {
              String searchEntry = date.day;
              final provider = Provider.of<CategoriesProvider>(context,listen: false);
              DateTime? pickedDate = await showDatePicker(
                context: context,
                locale: const Locale("fr", "FR"),
                initialDate: date.searchDate.text.isNotEmpty ? DateTime.parse(date.searchDate.text):DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primary,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: primary, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {

                date.setDate(DateFormat('yyyy-MM-dd').format(pickedDate));
                date.setDayName(weekdayName[pickedDate.weekday] ?? '');
                String searchSortie = date.day;

                if(searchSortie != searchEntry){

                  var serarchedWilaya;
                  if(date.searchWilaya.text.isNotEmpty)serarchedWilaya = wilaya.where((element) => date.searchWilaya.text.contains(element["name"]!)).first;

                  date.filterSalons(
                      provider.selectedCat.id == '' ? null:provider.selectedCat.id,
                      serarchedWilaya != null ? serarchedWilaya["name"]:null,
                      date.prixFin == 0 ? null : date.prixFin,
                      date.day == ''? null:date.day
                  );
                }
              }
              else {
                date.clearDayName();
                date.clearDay();
                var serarchedWilaya;
                if(date.searchWilaya.text.isNotEmpty)serarchedWilaya = wilaya.where((element) => date.searchWilaya.text.contains(element["name"]!)).first;

                date.filterSalons(
                    provider.selectedCat.id == '' ? null:provider.selectedCat.id,
                    serarchedWilaya != null ? serarchedWilaya["name"]:null,
                    date.prixFin == 0 ? null : date.prixFin,
                    null
                );
              }
            },
          );
        }
      ),
    );
  }
}


class SalonWidget extends StatelessWidget {
  const SalonWidget({Key? key,required this.salon}) : super(key: key);
  final Salon salon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 1
          )
        ]
      ),
      margin: const EdgeInsets.only(bottom: 10,top: 10,right: 3),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          splashColor: clr4.withOpacity(.1),
          highlightColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () async {

            Provider.of<SalonProvider>(context,listen: false).search = true;
            Provider.of<SalonProvider>(context,listen: false).clearSalon();

            Timer(const Duration(milliseconds: 200),(){
              PersistentNavBarNavigator.pushNewScreen(context,
                screen: SalonScreen(salon: salon,),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            });
          },

          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
                ),
                width: size.width * 0.35,
                child: CachedNetworkImage(
                  imageUrl: salon.photo!,
                  errorWidget: (cnx,photo,err)=>GFShimmer(
                    mainColor: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(12),),
                          color: Colors.grey.shade50
                      ),
                    ),
                  ),
                  imageBuilder: (context, imageProvider) =>
                    Ink.image(
                      image: CachedNetworkImageProvider(salon.photo!),
                      fit: BoxFit.cover,
                    ),
                )
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:  BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:  [

                      // TITRE
                      Text("${salon.nom}", style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 20),maxLines: 2,overflow: TextOverflow.ellipsis,),

                      // LOCATION
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/location.svg", width: 16, color: primary,),
                          const SizedBox(width: 3,),
                          Text("${salon.wilaya}", style: const TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ],
                      ),

                      // RATE
                      RatingBar(
                        initialRating: salon.rate ?? 5 ,
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

                      const Text("Salon de Coiffure",style: TextStyle(fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SalonList extends StatefulWidget {
  const SalonList({Key? key}) : super(key: key);

  @override
  State<SalonList> createState() => _SalonListState();
}

class _SalonListState extends State<SalonList> {

  bool showMore = false;
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    fetchSalons();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(Provider.of<SearchProvider>(context,listen: false).hasMore && !Provider.of<SearchProvider>(context,listen: false).isLoading){
        if(Provider.of<SearchProvider>(context,listen: false).day != ''
            || Provider.of<SearchProvider>(context,listen: false).searchWilaya.text.isNotEmpty
            ||  Provider.of<CategoriesProvider>(context,listen: false).selectedCat.id != ''
            ||  Provider.of<SearchProvider>(context,listen: false).prixFin != 0){print("retun");return;}
        else{

          setState(() {
            showMore = true;
          });
          KeyboardUtil.hideKeyboard(context);
          try {
            fetchSalons();
          }
          catch (e) {
            GFToast.showToast(
              e.toString(),
              context,
              toastDuration: 3,
              backgroundColor: red,
              textStyle: TextStyle(color: white),
              toastPosition: GFToastPosition.BOTTOM,
            );
          }
        }
        }
      }
      else{
        if(showMore == true){
          setState(() {showMore = false;});
        }
      }
    });
  }

  Future<void> fetchSalons() async {
    await Provider.of<SearchProvider>(context,listen: false).fetchSalons();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Consumer<SearchProvider>(
        builder: (context, salons, child) {

          if(salons.lastDocument == null || salons.isSearching){
            return Center(child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator(color: primary,)),
            );
          }

          else if(salons.listSalon.isEmpty ){
              return Center(child: Lottie.asset("assets/animation/empty.json"),);


          }

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: primary,
                  onRefresh: () async {
                    salons.listSalon.clear();
                    salons.lastDocument = null;
                    salons.fetchSalons();
                    salons.hasMore = true;
                  },
                  child: Scrollbar(
                    thickness: 4,
                    trackVisibility: true,
                    controller: ScrollController(),
                    radius: const Radius.circular(25),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: salons.listSalon.length,
                      itemBuilder: (context, index) {
                        if(salons.listSalon.length > index){
                          return SalonWidget(salon: salons.listSalon.elementAt(index));
                        }
                        else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),

             // if(salons.isLoading)
              AnimatedContainer(
                width: MediaQuery.of(context).size.width,
                height: salons.isLoading ? 30 : 0,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 400),
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: clr3,
                  borderRadius: const BorderRadius.all(Radius.circular(6))
                ),
                child: Row(

                    children: const [
                      SizedBox(width: 25,),
                      Text(
                        'Loading',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      Spacer(),
                      SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2,)),
                      SizedBox(width: 25,),
                    ],
                  ),
                ),
            ]
          );
        }
      ),
    );
  }
}



