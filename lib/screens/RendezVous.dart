// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monsalondz/models/Team.dart';
import 'package:monsalondz/theme/colors.dart';
import '../models/Salon.dart';
import '../models/Service.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class RendezVous extends StatelessWidget {
  const RendezVous({Key? key, required this.salon}) : super(key: key);
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
  TextEditingController day = TextEditingController(text: "Selectionnez une date");
  DateTime selectedDay = DateTime.now();
  List<String> heures = [];

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

          PickDay(salon: salon,),



          /*StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return  Column(
                  children:  [
                    ListTile(
                      title:  Text(day.text ,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),),
                      trailing: IconButton(
                          onPressed: () async {},
                          icon: const Icon(CupertinoIcons.calendar_badge_plus)
                      ),
                    ),
                    const ListTile(
                      title: Text("à 13:30",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black,),),
                    ),
                  ],
                );
              }),*/

          const SizedBox(height: kToolbarHeight,),

        ],
      ),
    );
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
            groupTitle: 'Services',
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
  PickDay({Key? key, required this.salon}) : super(key: key);
  TextEditingController day = TextEditingController(text: "Selectionnez une date");
  DateTime selectedDay = DateTime.now();
  final Salon salon;
  @override
  Widget build(BuildContext context){
    return  StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return  Column(
            children: [
              Material(
                elevation: 6,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  splashColor: clr3,
                  onTap: () async {
                    bool ok = false;
                    while(ok == false){

                      if(
                      (selectedDay.weekday == 7 && salon.hours?.jours["dimanche"]["active"]  == false ) == true ||
                          (selectedDay.weekday == 1 && salon.hours?.jours['lundi']["active"]  == false)  == true ||
                          (selectedDay.weekday == 2 && salon.hours?.jours["mardi"]["active"]  == false)  == true ||
                          (selectedDay.weekday == 3 && salon.hours?.jours["mercredi"]["active"]  == false)  == true ||
                          (selectedDay.weekday == 4 && salon.hours?.jours["jeudi"]["active"]  == false)  == true ||
                          (selectedDay.weekday == 5 && salon.hours?.jours["vendredi"]["active"] == false)  == true ||
                          (selectedDay.weekday == 6 && salon.hours?.jours["samedi"]["active"]  == false) == true
                      )
                      {setState((){selectedDay = selectedDay.add(const Duration(days: 1));});}

                      else{setState((){ok = true;});}
                    }
                    bool decideWhichDayToEnable(DateTime date) {
                      if (date.weekday == 7 && salon.hours?.jours["dimanche"]["active"] == true) {
                        return true;
                      }
                      if (date.weekday == 1 && salon.hours?.jours['lundi']["active"] == true) {
                        return true;
                      }
                      if (date.weekday == 2 && salon.hours?.jours["mardi"]["active"] == true ) {
                        return true;
                      }
                      if (date.weekday == 3 && salon.hours?.jours["mercredi"]["active"] == true ) {
                        return true;
                      }
                      if (date.weekday == 4 && salon.hours?.jours["jeudi"]["active"] == true ) {
                        return true;
                      }
                      if (date.weekday == 5 && salon.hours?.jours["vendredi"]["active"] == true ) {
                        return true;
                      }
                      if (date.weekday == 6 && salon.hours?.jours["samedi"]["active"] == true ) {
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
                      setState((){
                        day.text = "${weekdayName[pickedDate.weekday]} ${DateFormat('dd-MM-yyyy').format(pickedDate)}";
                        selectedDay = pickedDate;
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(day.text ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: primaryPro,),),
                    trailing: Icon(CupertinoIcons.calendar, color: primaryPro,),
                    tileColor: clr4.withOpacity(.15),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)),),
                  ),
                ),
              ),
              PickHour(salon: salon,pickedDay: selectedDay,),
            ],
          );
        });
  }
}


class PickHour extends StatelessWidget {
  PickHour({Key? key, required this.salon, required this.pickedDay}) : super(key: key);
  
  final Salon salon;
  final DateTime pickedDay;
  
  List<String> heures = [];
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  String selected = '';
  
  getHours(){

    print("=========================================");

    String start = salon.hours?.jours[weekdayName[pickedDay.weekday]]["start"];
    String end = salon.hours?.jours[weekdayName[pickedDay.weekday]]["fin"];


    DateTime dateTimeStart = dateFormat.parse("${DateFormat("dd-MM-yyyy").format(pickedDay)} $start");
    DateTime dateTimeEnd = dateFormat.parse("${DateFormat("dd-MM-yyyy").format(pickedDay)} $end");
    DateTime dateTimeTemp = dateTimeStart;
    
    
    while(dateTimeTemp.isBefore(dateTimeEnd)){
      heures.add(DateFormat.Hm().format(dateTimeTemp));
      dateTimeTemp = dateTimeTemp.add(const Duration(minutes: 30));
    }

  }

  @override
  Widget build(BuildContext context) {
    getHours();
    return SizedBox(
      height: 100,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemCount: heures.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(heures[index],style: TextStyle(color: selected == heures[index] ? Colors.white : primaryPro,fontSize: 16),),
                    selected: selected == heures[index] ? true : false,
                    onSelected: (v){
                      if(v == true){
                        setState((){selected = heures[index];});

                      }
                      else{
                        setState((){ selected = '';});

                      }
                    },
                    backgroundColor: clr4,
                    pressElevation: 1,
                    selectedColor: primaryLite,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                  ),
                );
              },
        );}
      ),
    );
  }
}

