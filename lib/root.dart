import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:monsalondz/screens/favorites.dart';
import 'package:monsalondz/screens/profile/profile.dart';
import 'package:monsalondz/screens/profile/auth/auth.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../providers/CategoriesProvider.dart';
import '../providers/HistouriqueLocal.dart';
import 'home.dart';

TextStyle optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primary);

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  initState(){
    super.initState();
    checkCnx();
    getCategories();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final prvdr = Provider.of<CategoriesProvider>(context,listen: false);
      if(prvdr.categories.isNotEmpty && prvdr.done == true){
        timer.cancel();
      }
      else{
        getCategories();
      }
    });
  }

  checkCnx(){
    Provider.of<AuthProvider>(context, listen: false).checkCnx();
  }

  getCategories() async {
    await Provider.of<CategoriesProvider>(context,listen: false).getCategories().then((value) async {
        await Provider.of<CategoriesProvider>(context, listen: false).getCategoriesPhotos();
      getHistory();
    });
  }

  getHistory() async {
    await Provider.of<HistoryProvider>(context,listen: false).initLocalDB();
  }

  bool testCnx = false;

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.grey.shade50,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      navBarHeight: 55,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        colorBehindNavBar: white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.once,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      navBarStyle: NavBarStyle.style13,
    );
  }
  List<Widget> buildScreens() {
    return [
      GestureDetector(onTap: () {FocusScope.of(context).unfocus();},
        child: Consumer<AuthProvider>(
          builder: (cxt, cnx, child){
            if(AuthProvider.isConnect == true){
              return const HomeBody();
            }
            else{
              return Column(
                children: [
                  const SizedBox(height: 150,),
                  SizedBox(
                    height: 300,
                    child: Lottie.asset("assets/animation/404.json"),
                  ),
                  const SizedBox(height: 50,),
                  const Text("veuillez vérifier votre connexion",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 22),),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)))
                    ),
                    onPressed: (){
                      getCategories();
                      if(testCnx == false){
                        setState(() {
                          testCnx = true;
                        });
                      }
                      Timer(const Duration(seconds: 4), () {
                        if(AuthProvider.isConnect == false){
                          setState(() {
                            testCnx = false;
                          });
                        }
                      });
                    },
                      child: testCnx == false ? const Text("Réessayer",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),):
                      const SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: Colors.white,))
                  ),
                ],
              );
            }
          }
        ),
      ),
      const FavoriteScreen(),
      const FavoriteScreen(),
      GestureDetector(onTap: () {FocusScope.of(context).unfocus();},
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const SignUp();
              }
              if(snapshot.hasData) {
                if(snapshot.data!.uid.isNotEmpty) return const Profile();
              }
              if (snapshot.hasError) return Dialog(child: Text(snapshot.error.toString()),);
              return Container(color: white,child: Center(child: CircularProgressIndicator(color: primary,),));
            }
        ),
      )
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [

      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/icons/home1.svg",
          height: 22,
          width: 22,
          color: primary,
        ),
        inactiveIcon: SvgPicture.asset(
          "assets/icons/home.svg",
          height: 22,
          width: 22,
          color: const Color(0xFF8E8E93),
        ),
        iconSize: 22,
        activeColorSecondary: primary,
        title: ("Home"),
        activeColorPrimary: secondary,
        opacity: .9,
        textStyle: optionStyle,
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.calendar_today),
        inactiveIcon: const Icon(CupertinoIcons.calendar),
        title: ("RDV"),
        inactiveColorPrimary: CupertinoColors.systemGrey,
        activeColorPrimary: secondary,
        activeColorSecondary: primary,
        opacity: .9,
        textStyle: optionStyle,
      ),
    
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.heart_fill),
        inactiveIcon: const Icon(CupertinoIcons.heart),
        title: ("Favoris"),
        inactiveColorPrimary: CupertinoColors.systemGrey,
        activeColorPrimary: secondary,
        activeColorSecondary: primary,
        opacity: .9,
        textStyle: optionStyle,
      ),
      
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        inactiveIcon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        inactiveColorPrimary: CupertinoColors.systemGrey,
        activeColorPrimary: secondary,
        activeColorSecondary: primary,
        opacity: .9,
        textStyle: optionStyle,

      ),
    ];
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);
}

