import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/providers/FavoriteProvider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/theme/colors.dart';
import '../../providers/AuthProvider.dart';
import '../../widgets/profile_menu.dart';
import 'listRDV/MesDEMANDES.dart';
import 'listRDV/MesRDV.dart';
import 'settings.dart';
import 'account/UpdateProfileScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool bye = false;
  bool done = false;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
        appBar: AppBar(
          title: const Text(
            "Profil",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600,),
          ),
          elevation: 20,
          backgroundColor: primary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //General
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 30,bottom: 8),
                  child: Text(
                    "Général",
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ),
                ProfileMenu(
                  text: "Compte",
                  icon: "assets/icons/user1.svg",
                  press: () => Timer(const Duration(milliseconds: 200),(){
                      PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const UpdateProfileScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    }),
                  primary: primary,
                  secondary: secondary,
                ),
                ProfileMenu(
                  text: "Demandes",
                  icon: "assets/icons/book.svg",
                  press: ()=>Timer(const Duration(milliseconds: 200),(){
                    PersistentNavBarNavigator.pushNewScreen(context,
                      screen:  LesDemandes(color: Colors.blue.shade700,),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  }),
                  width: 30,
                  primary: primary,
                  secondary: secondary,
                ),
                ProfileMenu(
                  text: "Rendez-Vous",
                  icon: "assets/icons/history.svg",
                  press: ()=>Timer(const Duration(milliseconds: 200),(){
                    PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const LesRendezVous(color: Colors.teal,),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  }),
                  width: 30,
                  primary: primary,
                  secondary: secondary,
                ),
                ProfileMenu(
                  text: "Paramètres",
                  icon: "assets/icons/setting.svg",
                  press: () {
                    Timer(const Duration(milliseconds: 200),(){
                      PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const SettingsPage(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    });
                  },
                  primary: primary,
                  secondary: secondary,
                ),

                //FEEDBACK
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Feedback",
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ),
                ProfileMenu(
                  text: "Centre d'aide",
                  icon: "assets/icons/Question mark.svg",
                  press: () {},
                  primary: primary,
                  secondary: secondary,
                ),
                ProfileMenu(
                  text: "About us",
                  icon: "assets/icons/Question mark.svg",
                  press: () {},
                  primary: primary,
                  secondary: secondary,
                ),

                //LOG OUT
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Compte",
                    style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ),
                ProfileMenu(
                  text: "Se déconnecter",
                  icon: "assets/icons/Logout.svg",
                  press: () async {
                    if (!mounted) return;
                    setState(() {bye = true;});
                    Timer(const Duration(milliseconds: 400), () {
                      if (!mounted) return;
                      setState(() {done = true;});
                    });
                    Timer(const Duration(milliseconds: 1500), () {
                      if (!mounted) return;
                      setState(() {bye = false;});
                    });
                    Timer(const Duration(milliseconds: 1500), () async {
                      Provider.of<FavoriteProvider>(context, listen: false).clear();

                      final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                      switch(FirebaseAuth.instance.currentUser?.providerData.first.providerId) {
                        case 'google.com': {await providerAuth.googleLogOut();}
                        break;
                        case 'facebook.com': {await providerAuth.facebookLogOut();}
                        break;
                        default: {await providerAuth.LogOut();}
                        break;
                      }

                      if (!mounted) return;
                      setState(() {done = false;});
                    });
                  },
                  primary: primary,
                  secondary: secondary,
                  bye: bye,
                ),

                const SizedBox(height: 25,),

                //VERSION
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "v 1.0.0 by Aymen Kerrouche",
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kBottomNavigationBarHeight+10,),
              ],
            ),
          ),
        ),
    );
  }
}
