import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:monsalondz/theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Paramètres",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1),),
        backgroundColor: primary,
        centerTitle: true,
        leading: IconButton(
            onPressed:(){Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 5,
          right: 15,
          left: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Row(
                children: [
                  txtOption('Confidentialités'),
                  const SizedBox(width: 15,),
                  newOption(),
                ],
              ),
              Column(
                children: const [
                  OptionSetting(txt:"Autoriser la collecte des données d'utilisation"),
                  OptionSetting(txt:'Montrez votre e-mail'),
                  OptionSetting(txt:'Montrez votre photo de profil'),
                  OptionSetting(txt:'Vider le cache automatiquement'),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),

              Row(
                children: [
                  txtOption('Thème'),
                  const SizedBox(width: 15,),
                  newOption(),
                ],
              ),
              Column(
                children: [
                  OptionSetting(txt:'Dark mode',onTap: (v){},),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),

              Row(
                children: [
                  txtOption('Notifications'),
                  const SizedBox(width: 15,),
                  newOption(),
                ],
              ),
              Column(
                children: const [
                  OptionSetting(txt:'Rendez-vous'),
                  OptionSetting(txt:'Promo'),
                  OptionSetting(txt:'Nouveaux salons'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container txtOption(String txt){
    return Container(margin: const EdgeInsets.only(bottom: 10,top: 10),child: Text(txt,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: primary),));
  }

  Widget newOption(){
    return Chip(
      elevation: 0,
      side: BorderSide.none,
      shape: const RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(12))),
      label: const GFShimmer(secondaryColor: primary,mainColor: primary,child: Text("bientôt disponible")),
      backgroundColor: primaryLite2.withOpacity(.1),
      labelStyle: const TextStyle(color: primaryPro,fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 0),);
  }
}

class OptionSetting extends StatelessWidget {
  const OptionSetting({Key? key,this.txt,this.onTap}) : super(key: key);
  final String? txt;
  final void Function(bool?)? onTap;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 10,),
          SizedBox(width: size.width * 0.7,child: Text("$txt",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
          const Spacer(),
          GFToggle(
            onChanged: onTap ?? (v){},
            value: false,
            type: GFToggleType.ios,
            enabledTrackColor: primary,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(width: 5,),
        ],
      ),
    );
  }
}

