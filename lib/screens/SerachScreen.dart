import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monsalondz/models/Category.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import '../providers/SearchPrivider.dart';
import '../theme/colors.dart';
import '../utils/constants.dart';
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
                        FilterPrix(),
                        FilterWilaya(),
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
        child: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(height: 15,),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              Salon(),
              SizedBox(height: 45,)
            ]
          ),
        ),
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
                          const SizedBox(height: 15,),
                          OutlinedButton(
                            onPressed: (){
                              categories.selectedCat = Category('', '', '');
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
                );
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
                );
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
              label: Text( wilayas.searchWilaya.text.isEmpty ? "Wilaya" : wilayas.searchWilaya.text ,style: TextStyle(color: wilayas.searchWilaya.text.isEmpty ? primary : white ),),
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
                );
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
              }
              else {
                date.searchDate.clear();
                date.setDayName('');
              }
            },
          );
        }
      ),
    );
  }
}


class Salon extends StatelessWidget {
  const Salon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 150,
      decoration: const BoxDecoration(
          color:  Colors.white ,
          borderRadius:  BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 1
            )
          ]
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          splashColor: clr4.withOpacity(.1),
          highlightColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          onTap: (){},
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16)),
                ),
                width: size.width * 0.35,
                child: Ink.image(
                  image: const CachedNetworkImageProvider(
                    "https://firebasestorage.googleapis.com/v0/b/monsalon-dz.appspot.com/o/salon%2FaqTP5g8ZulPgKdhCZr7J%2Fsalon2.jpg?alt=media&token=6db491b2-6fe8-4341-9a53-1f09f1515e41",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:  BorderRadius.only(topRight: Radius.circular(16),bottomRight: Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [

                      // TITRE
                      const Text("Salon de beauté lux bon", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),maxLines: 2,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 5,),

                      // LOCATION
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/location.svg", width: 16, color: primary,),
                          const SizedBox(width: 3,),
                          const Text("25 Constantine", style: TextStyle(fontSize: 16),maxLines: 2,overflow: TextOverflow.ellipsis,),
                        ],
                      ),


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
