import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/HistouriqueLocal.dart';
import '../providers/ThemeProvider.dart';

class RecentSearch extends StatelessWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
    return Consumer<HistoryProvider>(
        builder: (context, history,child) {
          return Column(
            children: [
              if(history.searchHistory.isNotEmpty)Align(
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 10,
                  children: List.generate(
                    history.searchHistory.length, (index) => RawChip(
                      label: Text(
                        history.searchHistory[index].asMap().values.where((e) => e != '')
                          .toString().substring(1,history.searchHistory[index].asMap().values.where((e) => e != '')
                          .toString().length-1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      avatar: Icon(Icons.search_rounded,color: providerColor.primaryPro),
                      labelPadding: EdgeInsets.zero,
                      deleteIconColor: providerColor.primaryPro,
                      onDeleted: () async {history.deleteHistory(history.searchHistory[index].id!);},
                      elevation: 1,
                      backgroundColor: providerColor.primary.withOpacity(.03),
                      pressElevation: 5,
                      onPressed: (){},
                      labelStyle: TextStyle(color: providerColor.primaryPro),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
