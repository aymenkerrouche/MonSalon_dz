// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:monsalondz/widgets/Category.dart';
import 'package:monsalondz/widgets/Populars.dart';
import '../theme/colors.dart';
import '../widgets/Pubs.dart';
import '../widgets/Recent.dart';
import '../widgets/RecentSearch.dart';
import '../widgets/SearchBar.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: const SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                expandedHeight: 170,
                pinned: false,
                floating: false,
                forceElevated: false,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Pubs(),
                ),
              ),
            ),
          )
        ];
      },
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [

              // SERACH
              const SerachBar(),
              const SizedBox(height: 25,),

              //Categories
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: const Text(
                    "Découvrir les soins",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Container(
                height: 650,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const ListCatigories()),
              const SizedBox(height: 25,),

              //Populars
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 12,bottom: 15),
                  child: const Text(
                    "Meilleurs Salons",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 300, child: Populars()),
              const SizedBox(height: 25,),

              //Recent
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 12,bottom: 10),
                  child: const Text(
                    "Salons récents",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              //const RecentItem(),
              const SizedBox(height: 25,),

              //Search History
              const RecentSearch(),
              const SizedBox(height: kToolbarHeight,),

            ],
          ),
        ),
      ),
    );
  }
}
