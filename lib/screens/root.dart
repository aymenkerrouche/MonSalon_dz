import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:monsalondz/screens/favorites.dart';
import 'package:monsalondz/screens/profile/profile.dart';
import 'package:monsalondz/screens/profile/auth/auth.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import '../providers/CategoriesProvider.dart';
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
    getData();
  }

  getData() async {
    await Provider.of<CategoriesProvider>(context,listen: false).getCategories().then((value) async {
      await Provider.of<CategoriesProvider>(context,listen: false).getCategoriesPhotos();
    });
  }

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
      //resizeToAvoidBottomInset: true,
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
      const HomeBody(),
      const FavoriteScreen(),
      const FavoriteScreen(),
      StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Container(color: white,child: Center(child: CircularProgressIndicator(color: primary,),));
            }
            if(snapshot.hasData) {
              if(snapshot.data!.uid.isNotEmpty) return const Profile();
            }
            if (snapshot.hasError) return Dialog(child: Text(snapshot.error.toString()),);
            return const SignUp();
          }
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


