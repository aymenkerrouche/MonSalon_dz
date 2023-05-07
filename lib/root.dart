import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:monsalondz/screens/SearchScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:monsalondz/screens/Favorites.dart';
import 'package:monsalondz/screens/profile/profile.dart';
import 'package:monsalondz/screens/profile/auth/auth.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';
import 'providers/CategoriesProvider.dart';
import 'providers/HistouriqueLocal.dart';
import 'screens/home.dart';

TextStyle optionStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primary);
PersistentTabController controller = PersistentTabController(initialIndex: 0);

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
    getHistory();
    getPopulars();
    final prvdr =  Provider.of<CategoriesProvider>(context,listen: false);
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if(prvdr.categories.isNotEmpty && prvdr.done == true){
        timer.cancel();
      }
      else{
        getCategories();
      }
    });
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if(prvdr.populars.isNotEmpty){
        timer.cancel();
      }
      else{
        getPopulars();
      }
    });
  }

  checkCnx(){
    Provider.of<AuthProvider>(context, listen: false).checkCnx();
  }

  getCategories() async {
    final prv = Provider.of<CategoriesProvider>(context,listen: false);
    await prv.getPubs();
    await prv.getCategories().then((value) async {
      await prv.getCategoriesPhotos();
      await prv.getServices();
    });
  }

  getHistory() async {
    await Provider.of<HistoryProvider>(context,listen: false).initLocalDB();
  }

  getPopulars() async {
    await Provider.of<CategoriesProvider>(context,listen: false).getPopularSalons();
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
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        colorBehindNavBar: Colors.white,
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
      Consumer<AuthProvider>(
        builder: (cxt, cnx, child){
          if(AuthProvider.isConnect == true){
            return const HomeScreen();
          }
          else{
            if(AuthProvider.isConnect == false){
              return Column(
                children: [
                  const SizedBox(height: 150,),
                  SizedBox(
                    height: 300,
                    child: Lottie.asset("assets/animation/404.json",reverse: true),
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
                      child: testCnx == false ? const Text("Réessayer",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18,color: Colors.white),):
                      const SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: Colors.white,))
                  ),
                ],
              );
            }
            return const Center(child: SizedBox(width: 40,height: 40,child: CircularProgressIndicator(color: primary,)));
          }
        }
      ),
      const SearchScreen(),
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar( backgroundColor: Colors.white,),
              body: SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 70,),
                      SizedBox(
                        height: 300,
                        child: Lottie.asset("assets/animation/auth.json",reverse: true),
                      ),
                      const SizedBox(height: 50,),
                      const Text("Connecter-vous à votre compte pour voir vos salons préférés",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 22),),
                      const SizedBox(height: 20,),
                      CupertinoButton(
                        onPressed: (){
                          controller.jumpToTab(3);
                        },
                        color: primary,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Text("Se connecter".toUpperCase(),style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20,letterSpacing: .8,color: Colors.white,fontFamily: 'Rubik',),),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if(snapshot.hasData) {
            if(snapshot.data!.uid.isNotEmpty) {
              return const FavoriteScreen();
            }
          }
          if (snapshot.hasError) return Dialog(child: Text(snapshot.error.toString()),);
          return Container(color: white,child: const Center(child: CircularProgressIndicator(color: primary,),));
        }
      ),
      GestureDetector(onTap: () {FocusScope.of(context).unfocus();},
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return const SignUp();
            }
            if(snapshot.hasData) {
              if(snapshot.data!.uid.isNotEmpty) {
                return const Profile();
              }
            }
            if (snapshot.hasError) return Dialog(child: Text(snapshot.error.toString()),);
            return Container(color: white,child: const Center(child: CircularProgressIndicator(color: primary,),));
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

}


