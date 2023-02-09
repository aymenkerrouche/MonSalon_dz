// ignore_for_file: avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:monsalondz/widgets/Category.dart';
import 'package:monsalondz/widgets/Populars.dart';
import '../theme/colors.dart';
import '../widgets/Pubs.dart';
import '../widgets/Recent.dart';
import '../widgets/RecentSearch.dart';
import '../widgets/SearchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = 200;

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController != null && _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver:  SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                expandedHeight: 170,
                pinned: true,
                floating: false,
                forceElevated: false,
                elevation: 0,
                title: AnimatedSwitcher(
                  key: const Key("show"),
                  duration: const Duration(milliseconds: 200),
                  child: isShrink ?
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Image.asset("assets/images/logo.png",height: kToolbarHeight-5,),
                  ):
                  const SizedBox(key: Key("not"),
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  background: Pubs(),
                ),
              ),
            ),
          )
        ];
      },
      body: const HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            /*Align(
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
              ),*/
            //const RecentItem(),
            const SizedBox(height: 25,),

            //Search History
            const RecentSearch(),
            const SizedBox(height: kToolbarHeight,),

          ],
        ),
      ),
    );
  }
}

