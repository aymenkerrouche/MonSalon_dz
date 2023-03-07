// ignore_for_file: must_be_immutable

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
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import '../models/Salon.dart';
import '../models/Service.dart';
import 'package:intl/intl.dart';

import '../providers/RendezVousProvider.dart';
import '../utils/constants.dart';

class RendezVousScreen extends StatelessWidget {
  const RendezVousScreen({Key? key, required this.salon}) : super(key: key);
  final Salon salon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Résarvation",style: TextStyle(fontSize: 22),),
        centerTitle: true,
        elevation: 1 ,
        //leading: IconButton(onPressed:(){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Body(salon: salon,)
      ),
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

          listService(serviceController),

          const SizedBox(height: 50,),

          if(salon.team) teamList(teamController),

          const SizedBox(height: 50,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/history.svg", width: 16, color: primaryLite,),
                const SizedBox(width: 10,),
                const Flexible(child: Text("Choisissez la date et l'heure",style: TextStyle(fontSize: 18),maxLines: 2,)),
              ],
            ),
          ),

          const SizedBox(height: 20,),

          PickDay(hours: salon.hours!),

          const SizedBox(height: 20,),

          const PickHour(),


          // BOOK
          StatefulBuilder(
            builder: (BuildContext cntxt, StateSetter setState) {
              return  ElevatedButton(
                onPressed:() async {
                  setState((){click = true;});
                  final rdv = Provider.of<RDVProvider>(context,listen: false);
                  await getUser(context);
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
                          rdv.rendezVous?.salon = salon.nom;
                          rdv.rendezVous?.location = salon.location;
                          rdv.rendezVous?.salonID = salon.id;
                          rdv.rendezVous?.userID = FirebaseAuth.instance.currentUser?.uid;
                          rdv.rendezVous?.user = FirebaseAuth.instance.currentUser?.displayName;


                          rdv.rendezVous?.services = serviceController.selectedItem;
                          rdv.rendezVous?.servicesID = rdv.rendezVous!.services.map((e) => e.id!).toList();


                          if(teamController.selectedItem.name != "N'importe qui"){
                            rdv.rendezVous?.team = true;
                            rdv.rendezVous?.teamName = teamController.selectedItem.name;
                            rdv.rendezVous?.teamID = teamController.selectedItem.userID;
                          }
                        }
                      }
                    }
                    else{
                      GFToast.showToast("Veuillez sélectionner au moins une préstation", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                    }
                  }



                  /*
            if(rdv.rendezVous != null){

              Provider.of<RDVProvider>(context,listen: false).salon = salon;
              Timer(const Duration(milliseconds: 100), () {
                PersistentNavBarNavigator.pushNewScreen(context,
                  screen: RendezVousScreen(salon: salon),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.slideUp,
                );
                //Navigator.push(context, MaterialPageRoute(builder: (context) => RendezVous(salon: salon,)),);
              });
            }

*/
                  setState((){click = false;});
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    fixedSize: const Size(double.maxFinite, 56),
                    elevation: 6,
                    foregroundColor: clr3,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Vérifier votre RDV', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18,color: Colors.white),),
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
      if(FirebaseAuth.instance.currentUser?.displayName == null && FirebaseAuth.instance.currentUser?.phoneNumber == null){
        GFToast.showToast("Veuillez d'abord remplir votre profil et votre numéro téléphone", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
      }
      else if(phone == ''){
        GFToast.showToast("Veuillez d'abord ajouter votre numéro de téléphone à votre profil", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
      }
      else if(name == ''){
        GFToast.showToast("Veuillez d'abord ajouter votre notre à votre profil", context,toastDuration: 3,backgroundColor: black,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
      }
    });
  }

  Widget listService(serviceController){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/cut.svg", width: 16, color: primaryLite,),
              const SizedBox(width: 10,),
              const Flexible(child: Text("Choisissez la prestation qui vous convient",style: TextStyle(fontSize: 18),maxLines: 2,)),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: SimpleGroupedCheckbox<Service>(
            controller: serviceController,
            groupTitle: "Prestations",
            groupTitleAlignment: Alignment.centerLeft,
            helperGroupTitle: false,
            isExpandableTitle: true,
            itemsTitle: List.generate(salon.service.length, (index) => "${salon.service[index].service}"),
            itemsSubTitle: List.generate(salon.service.length, (index) => salon.service[index].prixFin == 0 ?
            "${salon.service[index].prix} DA" : "${salon.service[index].prix} - ${salon.service[index].prixFin} DA"
            ),
            values: salon.service.toList(),
            groupStyle: GroupStyle(
              activeColor: primaryLite,
              itemTitleStyle: const TextStyle(fontSize: 16),
              groupTitleStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),
            ),
            checkFirstElement: false,
          ),
        ),
      ],
    );
  }

  Widget teamList(teamController){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Icon(CupertinoIcons.group,color: primaryLite,),
              const SizedBox(width: 10,),
              const Flexible( child:Text("Choisissez l’expert avec qui vous êtes à l’aise",style: TextStyle(fontSize: 18),maxLines: 2),),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        ClipRRect(
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
              activeColor: primaryLite,
              itemTitleStyle: const TextStyle(fontSize: 16),
              groupTitleStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),
            ),
            checkFirstElement: true,

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
              elevation: 6,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                splashColor: clr3,
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
                          colorScheme: ColorScheme.light(
                            primary: primary,
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
                    provider.getHours(pickedDate);
                    provider.selectedDay = "${weekdayName[pickedDate.weekday]} ${DateFormat('dd-MM-yyyy').format(pickedDate)}";
                  }
                },
                child: ListTile(
                  title: Text(provider.selectedDay,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: primaryPro,),),
                  trailing: Icon(CupertinoIcons.calendar, color: primaryPro,),
                  tileColor: clr4.withOpacity(.15),
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

                      backgroundColor: clr4,
                      //pressElevation: 1,
                      selectedColor: primaryLite,
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
                  child: FilterChip(
                    label: GFShimmer(mainColor: clr3, secondaryColor: clr4,child: Text(rdv.heuresSHIMER[index],style: TextStyle(color:primaryPro,fontSize: 16),)),
                    selected: false,
                    onSelected: (v){},
                    backgroundColor: clr4,
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

