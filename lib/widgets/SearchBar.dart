  // ignore_for_file: file_names, must_be_immutable, depend_on_referenced_packages

  import 'package:animated_custom_dropdown/custom_dropdown.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:monsalondz/theme/colors.dart';
  import 'package:monsalondz/utils/wilaya.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
  import '../providers/HistouriqueLocal.dart';
import '../providers/SearchPrivider.dart';
  import '../utils/constants.dart';

  class SerachBar extends StatelessWidget {
    const SerachBar({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),


        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 1
                  )
                ]),
              child: Consumer<SearchProvider>(
                builder: (context, search, child) {
                  return TextField(
                    cursorColor: primary,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                    controller: search.search,
                    cursorHeight: 24,
                    cursorRadius: const Radius.circular(20),
                    decoration: InputDecoration(
                      hintText: "Prestation",
                      hintStyle: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 18),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primary, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white38, width: 1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close_rounded, color: primary),
                        padding: EdgeInsets.zero,
                        onPressed: () {search.search.clear();}
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children : [
                const SerachWilaya(),
                const Spacer(),
                SearchTime(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SearchButton(),
          ],
        ),
      );
    }
  }


  // BUTTON
  class SearchButton extends StatelessWidget {
    SearchButton({Key? key}) : super(key: key);
    bool loading = false;
    @override
    Widget build(BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return ElevatedButton(
            onPressed: (){
              setState(() {
                var provider = Provider.of<HistoryProvider>(context,listen: false);
                var provider2 = Provider.of<SearchProvider>(context,listen: false);
                if(loading) {
                  loading = false;
                }
                else {
                  loading = true;
                }
                provider.setSearchHistory(
                  provider2.search.text.isEmpty ? '' : provider2.search.text,
                  provider2.searchWilaya.text.isEmpty ? '' : provider2.searchWilaya.text,
                  '',
                  provider2.searchDate.text.isEmpty ? '' : provider2.searchDate.text,
                  provider2.day,
                  provider2.hour
                );
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                fixedSize: const Size(double.maxFinite, 48),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            child: loading ?
            SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: white,strokeWidth: 3,),):
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Rechercher', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),),
                SizedBox(width: 15,),
                Icon(CupertinoIcons.search,color: Colors.white)
              ],
            ),

          );
        },
      );
    }
  }



  //Wilaya
  class SerachWilaya extends StatelessWidget {
    const SerachWilaya({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Container(
        width: size.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 2
            )
          ]),
        child: Consumer<SearchProvider>(
          builder: (context, searchwilaya, child) {
            return CustomDropdown(
              hintText: 'Wilaya',
              items: wilaya.map((e) => '${e['code']!}  ${e['name']!}').toList(),
              controller: searchwilaya.searchWilaya,
              listItemStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Rubik',
              ),
              selectedStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w600),
              fieldSuffixIcon: Icon(Icons.arrow_drop_down_circle_outlined,color: primary,size: 20,),
              onChanged: (w){
                if(w.contains('Tous')){searchwilaya.searchWilaya.clear();}
              },
            );
          }
        ),
      );
    }
  }



  //DAY
  class SearchTime extends StatelessWidget {
    SearchTime({super.key});

    DateTime selectedDay = DateTime.now();
    @override
    Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return Container(
        height: 50,
        width: size.width * 0.4,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 2
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
              width: size.width * 0.25,
              child: Consumer<SearchProvider>(
                builder: (context, daySearch, child) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                       return TextField(
                      controller: daySearch.searchDate,
                      style: const TextStyle(color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: "Date",
                        hintStyle: TextStyle(color: Color(0xFFA7A7A7),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          locale: const Locale("fr", "FR"),
                          initialDate: selectedDay,
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
                          setState(() {
                            selectedDay = pickedDate;
                          });
                          daySearch.setDate(DateFormat('yyyy-MM-dd').format(pickedDate));
                          daySearch.setDayName(weekdayName[pickedDate.weekday] ?? '');
                        }
                        else {
                          setState(() {
                            selectedDay = DateTime.now();
                          });
                          daySearch.searchDate.clear();
                          daySearch.setDayName('');
                        }
                      },
                    );
                    }
                  );
                }
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                child: Consumer<SearchProvider>(
                  builder: (context, daySearch, child) {
                    return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return InkWell(
                            child: Icon(CupertinoIcons.calendar,color: primary),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                locale: const Locale("fr", "FR"),
                                initialDate: selectedDay,
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
                                setState(() {
                                  selectedDay = pickedDate;
                                });
                                daySearch.setDate(DateFormat('yyyy-MM-dd').format(pickedDate));
                                daySearch.setDayName(weekdayName[pickedDate.weekday] ?? '');
                              }
                              else {
                                setState(() {
                                  selectedDay = DateTime.now();
                                });
                                daySearch.searchDate.clear();
                                daySearch.setDayName('');
                              }
                            },
                          );
                        }
                    );
                    }
                ),
              ),
            ),
          ],
        )
      );
    }
  }