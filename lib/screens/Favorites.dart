import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:lottie/lottie.dart';
import 'package:monsalondz/widgets/PopularOffer.dart';
import 'package:provider/provider.dart';
import '../providers/FavoriteProvider.dart';
import '../theme/colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos Favoris", style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
        centerTitle: false,
        actions: [
          Material(
            elevation: 8,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                splashColor: primary.withOpacity(.2),
                highlightColor: Colors.transparent,
                onTap: () async {
                  Provider.of<FavoriteProvider>(context,listen: false).order();
                },
                child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle,color: primaryLite.withOpacity(.1)),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset("assets/icons/filter.svg",width: 18,height: 18,color: primaryPro,)),
              )
          ),

          const SizedBox(width: 16,),
        ],
      ),
      body: const FavoriteList()
    );
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {

  bool showMore = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchSalons();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(Provider.of<FavoriteProvider>(context,listen: false).hasMore){
          setState(() {
            showMore = true;
          });
          try {
            fetchSalons();
          }
          catch (e) {
            GFToast.showToast(e.toString(), context, toastDuration: 3, backgroundColor: red, textStyle: TextStyle(color: white), toastPosition: GFToastPosition.BOTTOM,);
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
    await Provider.of<FavoriteProvider>(context,listen: false).getFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
        builder: (context, salons, child) {

          if(salons.isRefreshing){
            return Center(child: SizedBox(height: 40,width: 40,child: CircularProgressIndicator(color: primary,)),
            );
          }

          else if(salons.mesSalon.isEmpty ){
            return RefreshIndicator(
              color: Colors.white,
              backgroundColor: primary,
              onRefresh: () async {
                salons.clear();
                await salons.getFavoriteList();
              },
              child: ListView(
                children:[
                  const SizedBox(height: 150,),
                  Center(child: Lottie.asset("assets/animation/empty.json"),),
                ]
              )
            );
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: primary,
            onRefresh: () async {
              salons.clear();
              await salons.getFavoriteList();
            },
            child: Container(
              color: Colors.grey.shade50,
              child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        thickness: 4,
                        trackVisibility: true,
                        controller: ScrollController(),
                        radius: const Radius.circular(25),
                        child: ListView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: List.generate(salons.mesSalon.length, (index){
                            if(salons.mesSalon.length > index){
                              return PopularOffer(salon: salons.mesSalon.elementAt(index));
                            }
                            else {
                              return const SizedBox();
                            }
                          }),
                        ),
                      ),
                    ),
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
                    const SizedBox(height: kToolbarHeight,),
                  ]
              ),
            ),
          );
        }
    );
  }
}
