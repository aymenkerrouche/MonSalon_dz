import 'package:flutter/material.dart';
import 'package:monsalondz/models/Category.dart';
import 'package:monsalondz/providers/CategoriesProvider.dart';
import 'package:monsalondz/providers/SearchPrivider.dart';
import 'package:monsalondz/root.dart';
import 'package:provider/provider.dart';
import '../providers/HistouriqueLocal.dart';
import '../theme/colors.dart';
import '../utils/keyboard.dart';
import '../utils/wilaya.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, history,child) {
        if(history.searchHistory.isNotEmpty){
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 12,bottom: 5),
                  child: const Text(
                    "Continuez vos recherches",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  children: List.generate(
                    history.searchHistory.length, (index) => RawChip(
                    label: Text(
                      history.searchHistory[index].prix == 0 ?
                      history.searchHistory[index].asMap().values.where((e) => e != '' && e != 0)
                          .toString().substring(1,history.searchHistory[index].asMap().values.where((e) => e != '' && e != 0).toString().length-1) :
                      "${history.searchHistory[index].asMap().values.where((e) => e != '' && e != 0)
                          .toString().substring(1,history.searchHistory[index].asMap().values.where((e) => e != '' && e != 0).toString().length-1)} DA",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    avatar: Icon(Icons.search_rounded,color: primary),
                    labelPadding: EdgeInsets.zero,
                    deleteIconColor: primary,
                    onDeleted: () async {FocusScope.of(context).unfocus();KeyboardUtil.hideKeyboard(context);history.deleteHistory(history.searchHistory[index].id!);},
                    backgroundColor: primaryLite.withOpacity(.1),
                    pressElevation: 5,
                    onPressed: () async {

                      FocusScope.of(context).unfocus();KeyboardUtil.hideKeyboard(context);

                      final search = Provider.of<SearchProvider>(context,listen: false);
                      final category = Provider.of<CategoriesProvider>(context,listen: false);
                      var serarchedWilaya;
                      search.clearAll();
                      category.selectedCat = Category("", "", "");

                      if(history.searchHistory[index].category != '') {
                        category.selectedCat = Category(category.categories.where((element) => element.category == history.searchHistory[index].category).first.id, history.searchHistory[index].category, "");
                      }
                      if(history.searchHistory[index].search != '')search.search.text = history.searchHistory[index].search!;
                      if(history.searchHistory[index].prix != 0)search.prixFin = history.searchHistory[index].prix!;
                      if(history.searchHistory[index].wilaya != '') {
                        serarchedWilaya = wilaya.where((element) => history.searchHistory[index].wilaya!.contains(element["name"]!)).first;
                        search.setWilaya(history.searchHistory[index].wilaya!);
                      }
                      if(history.searchHistory[index].day != '') {
                        search.setDayName(history.searchHistory[index].day!);
                        search.setDate(history.searchHistory[index].date);
                      }

                      controller.jumpToTab(1);

                      await search.filterSalons(
                          category.selectedCat.id == '' ? null:category.selectedCat.id,
                          serarchedWilaya != null ? serarchedWilaya["name"] : null,
                          search.prixFin == 0 ? null : search.prixFin,
                          search.day == ''? null : search.day
                      );

                    },
                    labelStyle: TextStyle(color: primaryPro),
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 25,),
            ],
          );
        }
        return const SizedBox();

      }
    );
  }
}
