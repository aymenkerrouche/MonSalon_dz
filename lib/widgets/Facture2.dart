import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/utils/constants.dart';
import '../../models/RendezVous.dart';
import '../../providers/SalonProvider.dart';
import 'SnaKeBar.dart';
import 'TextInformation.dart';

class FactureScreen2 extends StatelessWidget {
  const FactureScreen2({Key? key, required this.rdv,required this.color}) : super(key: key);
  final RendezVous rdv;
  final Color color;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Rendez-vous",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 24)),
        backgroundColor: color,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),

              // SALON
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Icon(Icons.business_sharp,color: color,size: 20,),
                    const SizedBox(width: 10,),
                    Text("Salon", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.shade200,
                     spreadRadius: 1,
                     blurRadius: 10,
                     offset: const Offset(0, 1), // changes position of shadow
                   ),
                 ],
              ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal:12,vertical: 8),
                width: size.width,
                child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("${rdv.salon}", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                       if(rdv.team == true)Text("Expert: ${rdv.teamInfo?.name}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey.shade600),maxLines: 2,),
                       Text("${rdv.location}", style: const TextStyle(
                         fontSize: 14,fontWeight: FontWeight.w600,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                     ],
                   ),
              ),

              const SizedBox(height: 20,),

              // RDV
              SizedBox(
                height: 20,
                child: Row(
                  children:  [
                    Icon(Icons.calendar_month_rounded,color: color,size: 20,),
                    const SizedBox(width: 10,),
                    Text("Rendez-vous", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal:12,vertical: 12),
                child: Text("${rdv.date?.toTitleCase()} à ${rdv.hour} h", style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w700,),maxLines: 2,)
              ),

              const SizedBox(height: 20,),

              // SERVICES
              SizedBox(
                height: 20,
                child: Row(
                  children:   [
                    Icon(Icons.content_cut_rounded,color: color,size: 20,),
                    const SizedBox(width: 10,),
                    Text("Prestations", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal:10,vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rdv.services.map((e) =>
                        SizedBox(
                          width: size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                constraints: BoxConstraints(maxWidth: size.width * 0.55),
                                child: Text("${e.service}".toTitleCase(), style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,),maxLines: 2,)),
                              Flexible(
                                child: Text( e.prixFin! > e.prix! ? "${e.prix} - ${e.prixFin} DA" : "${e.prix} DA", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),),
                              ),
                            ],
                          ),
                        ),
                    ).toList()
                ),
              ),

              const SizedBox(height: 20,),


              Text("PRIX", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.bold),),

              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal:12,vertical: 12),
                child: Column(
                  children: [
                    // PRIX
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 20,
                      child: Row(
                        children: [
                          const Text("Montant", style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                          const Spacer(),
                          Text(rdv.prixFin == rdv.prix ? "${rdv.prix} DA" : "${rdv.prix} - ${rdv.prixFin} DA", style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),

                    // REMISE
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 20,
                      child: Row(
                        children: [
                          const Text("Remise", style: TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.w600),),
                          const Spacer(),
                          Text("- ${rdv.remise} DA", style: const TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),

                    // TOTAL
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 20,
                      child: Row(
                        children: [
                          Text("TOTAL", style: TextStyle(fontSize: 18,color: color ,fontWeight: FontWeight.w700),),
                          const Spacer(),
                          Text(rdv.prixFin == rdv.prix ? "${formatPrice(rdv.prix!-rdv.remise!)} DA" : "${formatPrice(rdv.prix!-rdv.remise!)} - ${formatPrice(rdv.prixFin!-rdv.remise!)} DA",
                            style: TextStyle(fontSize: 18,color: color ,fontWeight: FontWeight.w700,fontFamily: "roboto"),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: kToolbarHeight,),

              if((rdv.etat == 1 || rdv.etat == 3) && rdv.note == false )ElevatedButton(
                onPressed: () async {
                  TextEditingController commantaire = TextEditingController();
                  double rate = 0;
                  if(DateTime.now().isBefore(rdv.date2!.toDate())){
                    final snackBar = snaKeBar("vous ne pouvez pas le terminer avant la date du rendez-vous");
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    await Provider.of<SalonProvider>(context,listen: false).terminerRDV(rdv.id!,rdv.salonID!,context).then((value){
                      showDialog<void>(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (BuildContext cxt) {
                          return Dialog(
                            surfaceTintColor: Colors.white,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lottie.asset("assets/animation/rate.json",reverse: true,height: size.height * 0.2),
                                    const Text("Évaluez votre expérience",textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,letterSpacing: 0.8),),
                                    const SizedBox(height: 20,),
                                    RatingBar.builder(
                                      initialRating: 1,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating){rate=rating;},
                                    ),
                                    const SizedBox(height: 20,),
                                    TextDescription(textController: commantaire,label: "Commantaire",hint: "J'aime le salon ..."),
                                    const SizedBox(height: 20,),
                                    ElevatedButton(
                                      onPressed:() async =>
                                      await Provider.of<SalonProvider>(context,listen: false).setCommment(commantaire.text, rate, rdv.salonID!, rdv.userID!, rdv.user!, context, rdv.id!).whenComplete(() => Navigator.pop(context)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: color,
                                        foregroundColor: Colors.white,
                                        fixedSize: const Size(double.maxFinite, 48),
                                        elevation: 6,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                                      child: const Text("Terminer", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white),),
                                    ),
                                    const SizedBox(height: 20,),
                                  ],
                                ),
                              )
                            ),
                          );
                        },
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(double.maxFinite, 48),
                  elevation: 4,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text( rdv.etat == 3 ? "Évaluer" : "Terminer", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white),),
                    const SizedBox(width: 15,),
                    Icon(rdv.etat == 3 ? Icons.star_half_rounded : CupertinoIcons.checkmark_alt,color: Colors.white)
                  ],
                ),

              ),

              if(rdv.etat == 1 || rdv.etat == 3) const SizedBox(height: 25,),

              OutlinedButton(
                onPressed: (){
                  Timer(const Duration(milliseconds: 200),() async {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext cxt) {
                        return AlertDialog(
                          title:  const Text("Annuler",style: TextStyle(fontWeight: FontWeight.w700),),
                          content: const Text("Êtes-vous sûr de vouloir annuler le Rendez Vous ?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                final provider = Provider.of<SalonProvider>(context,listen: false);
                                if(rdv.etat == 0){
                                  await provider.deleteDemande(rdv.salonID!,rdv.id!,context).then((value) => Navigator.of(cxt).pop()).then((v) => Navigator.of(context).pop());
                                }
                                else{
                                  await provider.deleteRDV(rdv.id!, rdv.salonID!,context).then((value) => Navigator.of(cxt).pop()).then((v) => Navigator.of(context).pop());
                                }
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red.shade700,
                                  side: BorderSide(color: Colors.red.shade700),
                                  padding: const EdgeInsets.symmetric(horizontal: 20)
                              ),
                              child: const Text('Refuser'),
                            ),
                            TextButton(
                              onPressed: () {Navigator.of(cxt).pop();},
                              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700,),
                              child: const Text('Non'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  side: BorderSide(color: Colors.red.shade800, width: 1),
                  foregroundColor: Colors.red.shade800,
                  fixedSize: const Size(double.maxFinite, 48),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Annuler" , style: TextStyle(color: Colors.red.shade800,fontWeight: FontWeight.w600,fontSize: 20),),
                    const SizedBox(width: 15,),
                    Icon(CupertinoIcons.clear_thick,color: Colors.red.shade800)
                  ],
                ),
              ),

              const SizedBox(height: kToolbarHeight,),

            ],
          ),
        ),
      ),
    );
  }
}