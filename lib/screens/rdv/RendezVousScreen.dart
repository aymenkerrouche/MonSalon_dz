// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/models/Hours.dart';
import 'package:monsalondz/models/Team.dart';
import 'package:monsalondz/screens/rdv/Facture.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../../models/Salon.dart';
import '../../models/Service.dart';
import 'package:intl/intl.dart';

import '../../providers/RendezVousProvider.dart';
import '../../utils/constants.dart';
import '../profile/account/UpdateProfileScreen.dart';

class RendezVousScreen extends StatelessWidget {
  const RendezVousScreen({Key? key, required this.salon}) : super(key: key);
  final Salon salon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Résarvation",style: TextStyle(fontSize: 22,color: Colors.white),),
        centerTitle: true,
        elevation: .5 ,
        backgroundColor: primary,
        leading: IconButton(onPressed:(){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
      ),
      body: Container(height: size.height,padding: const EdgeInsets.symmetric(horizontal: 12),color: primaryLite.withOpacity(.2),child:Body(salon: salon,) )
    );
  }
}

class Body extends StatelessWidget {

  Body({Key? key, required this.salon}) : super(key: key);
  final Salon salon;
  GroupController serviceController = GroupController(isMultipleSelection: true);
  GroupController teamController = GroupController();
  String phone = '';
  String name = '';
  bool click = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),

          ServicesList(serviceController:serviceController,service: salon.service,),

          const SizedBox(height: 50,),

          if(salon.team) teamList(teamController),

          if(salon.team)const SizedBox(height: 50,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/history.svg", width: 16, color: primary,),
                const SizedBox(width: 10,),
                const Flexible(child: Text("Choisissez la date et l'heure",style: TextStyle(fontSize: 16),maxLines: 2,)),
              ],
            ),
          ),

          const SizedBox(height: 20,),

          PickDay(hours: salon.hours!),

          const SizedBox(height: 20,),

          const PickHour(),

          const SizedBox(height: 20,),


          // BOOK
          StatefulBuilder(
            builder: (BuildContext cntxt, StateSetter setState) {
              return  ElevatedButton(
                onPressed:() async {
                  setState((){click = true;phone = '';name = '';});
                  final rdv = Provider.of<RDVProvider>(context,listen: false);
                  await getUser(context).then((then){
                    if(name != '' && phone != ''){
                      if(serviceController.selectedItem.isNotEmpty){
                        if(rdv.selectedDay == 'Selectionnez une date'){
                          GFToast.showToast("Veuillez Selectionnez une date", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                        }
                        else{
                          if(rdv.selectedHour == ''){
                            GFToast.showToast("Veuillez Selectionnez une heure", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                          }
                          else{
                            rdv.fillRDV(salon, phone, serviceController.selectedItem, teamController);
                            rdv.calcPrix();
                            if(rdv.rendezVous != null){
                              Timer(const Duration(milliseconds: 200), () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: const FactureScreen(), withNavBar: false,
                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                );
                              });
                            }
                          }
                        }
                      }
                      else{
                        GFToast.showToast("Veuillez sélectionner au moins une préstation", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                      }
                  }
                  else{
                    Timer(const Duration(milliseconds: 200),(){
                      PersistentNavBarNavigator.pushNewScreen(context,
                        screen: const UpdateProfileScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    });
                  }
                  });

                  setState((){click = false;});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    fixedSize: const Size(double.maxFinite, 54),
                    elevation: 6,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Vérifier', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white,letterSpacing: 1),),
                    const SizedBox(width: 15,),
                    click ? const SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,),) :
                    SvgPicture.asset("assets/icons/check.svg",width: 26,height: 26,color: Colors.white,),
                  ],
                ),
              );
            }
          ),


          const SizedBox(height: kToolbarHeight,)
        ],
      ),
    );
  }

  Future<void> getUser(context) async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((snapshot){
      if(snapshot.data() != null){
        phone = snapshot.data()!['phone'] ?? '';
        name = snapshot.data()!['name'] ?? '';
      }
    }).whenComplete((){
     if(phone == ''){
        GFToast.showToast("Veuillez ajouter votre numéro de téléphone", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
      }
      else if(name == ''){
        GFToast.showToast("Veuillez d'abord ajouter votre nom", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
      }
    });
  }

  Widget teamList(teamController){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: const [
              Icon(CupertinoIcons.group,color: primary,),
              SizedBox(width: 10,),
              Flexible( child:Text("Choisissez l’expert avec qui vous êtes à l’aise",style: TextStyle(fontSize: 16),maxLines: 2),),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Material(
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            child: SimpleGroupedCheckbox<Team>(
              controller: teamController,
              groupTitle: 'Nos Experts',
              groupTitleAlignment: Alignment.centerLeft,
              helperGroupTitle: false,
              isExpandableTitle: true,
              itemsTitle: salon.teams.map((e) => e.name!).toList(),
              values: salon.teams.toList(),
              groupStyle: GroupStyle(
                activeColor: primaryLite2,
                itemTitleStyle: const TextStyle(fontSize: 16),
                groupTitleStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),
              ),
              checkFirstElement: true,

            ),
          ),
        ),

      ],
    );
  }
}

class ServicesList extends StatelessWidget {
  ServicesList({Key? key, required this.serviceController, required this.service}) : super(key: key);
  GroupController serviceController;
  List<Service> service;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/cut.svg", width: 16, color: primary,),
              const SizedBox(width: 10,),
              const Flexible(child: Text("Choisissez la prestation qui vous convient",style: TextStyle(fontSize: 16),maxLines: 2,)),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Material(
          elevation: 2,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child:  ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: SimpleGroupedCheckbox<Service>(
            controller: serviceController,
            groupTitle: "Prestations",
            groupTitleAlignment: Alignment.centerLeft,
            helperGroupTitle: false,
            isExpandableTitle: true,
            itemsTitle: List.generate(service.length, (index) => "${service[index].service}"),
            itemsSubTitle: List.generate(service.length, (index) => service[index].prixFin == 0 ?
            "${service[index].prix} DA" : "${service[index].prix} - ${service[index].prixFin} DA"
            ),
            values: service.toList(),
            groupStyle: GroupStyle(
              activeColor: primaryLite2,
              itemTitleStyle: const TextStyle(fontSize: 16),
              groupTitleStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),
            ),
            checkFirstElement: false,
          ),
        ),
        ),

      ],
    );
  }
}

class PickDay extends StatelessWidget {
  PickDay({Key? key, required this.hours}) : super(key: key);
  DateTime selectedDay = DateTime.now().add(const Duration(days: 1));
  final Hours hours;
  @override
  Widget build(BuildContext context){
    final provider = Provider.of<RDVProvider>(context,listen: false);
    return  Column(
      children: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return  Material(
              elevation: 1,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                splashColor: primaryLite2,
                onTap: () async {
                  bool ok = false;
                  while(ok == false){
                    if(
                    (selectedDay.weekday == 7 && hours.jours["dimanche"]["active"]  == false ) == true ||
                        (selectedDay.weekday == 1 && hours.jours['lundi']["active"]  == false)  == true ||
                        (selectedDay.weekday == 2 && hours.jours["mardi"]["active"]  == false)  == true ||
                        (selectedDay.weekday == 3 && hours.jours["mercredi"]["active"]  == false)  == true ||
                        (selectedDay.weekday == 4 && hours.jours["jeudi"]["active"]  == false)  == true ||
                        (selectedDay.weekday == 5 && hours.jours["vendredi"]["active"] == false)  == true ||
                        (selectedDay.weekday == 6 && hours.jours["samedi"]["active"]  == false) == true
                    )
                    {setState((){selectedDay = selectedDay.add(const Duration(days: 1));});}

                    else{setState((){ok = true;});}
                  }

                  bool decideWhichDayToEnable(DateTime date) {
                    if (date.weekday == 7 && hours.jours["dimanche"]["active"] == true) {
                      return true;
                    }
                    if (date.weekday == 1 && hours.jours['lundi']["active"] == true) {
                      return true;
                    }
                    if (date.weekday == 2 && hours.jours["mardi"]["active"] == true ) {
                      return true;
                    }
                    if (date.weekday == 3 &&hours.jours["mercredi"]["active"] == true ) {
                      return true;
                    }
                    if (date.weekday == 4 && hours.jours["jeudi"]["active"] == true ) {
                      return true;
                    }
                    if (date.weekday == 5 && hours.jours["vendredi"]["active"] == true ) {
                      return true;
                    }
                    if (date.weekday == 6 && hours.jours["samedi"]["active"] == true ) {
                      return true;
                    }
                    return false;
                  }

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    locale: const Locale("fr", "FR"),
                    initialDate: selectedDay,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 120)),
                    selectableDayPredicate: decideWhichDayToEnable,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: primary,
                            surfaceTint: Colors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: primary, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    setState((){selectedDay = pickedDate;});
                    provider.getHours(pickedDate,hours);
                    provider.selectedDay = "${weekdayName[pickedDate.weekday]} ${DateFormat('dd-MM-yyyy').format(pickedDate)}";
                  }
                },
                child: ListTile(
                  title: Text(provider.selectedDay,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),),
                  trailing: const Icon(CupertinoIcons.calendar, color: primary,),
                  tileColor: Colors.white,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)),),
                ),
              ),
            );
          }),
      ],
    );
  }
}

class PickHour extends StatelessWidget {
  const PickHour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Consumer<RDVProvider>(
          builder: (context, rdv, child){

            if(rdv.heures.isNotEmpty){
              return ListView.builder(
                itemCount: rdv.heures.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterChip(
                      label: Text(rdv.heures[index],style: TextStyle(color: rdv.selectedHour == rdv.heures[index] ? Colors.white : primaryPro,fontSize: 16),),
                      selected: rdv.selectedHour == rdv.heures[index] ? true : false,
                      onSelected: (v){
                        if(v == true){
                          rdv.selectedHour = rdv.heures[index];
                        }
                        else{
                          rdv.selectedHour = '';
                        }
                      },

                      backgroundColor: primaryLite,
                      selectedColor: primaryLite2,
                      side: BorderSide.none,
                      checkmarkColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                    ),
                  );
                },
              );
            }
            return ListView.builder(
              itemCount: rdv.heuresSHIMER.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Chip(
                    label: GFShimmer(mainColor: primaryLite2,child: Text(rdv.heuresSHIMER[index],style: const TextStyle(color:primaryPro,fontSize: 16),)),
                    backgroundColor: primaryLite.withOpacity(.5),
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}

