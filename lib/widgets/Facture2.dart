import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/providers/RendezVousProvider.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/utils/constants.dart';
import '../../models/RendezVous.dart';
import '../../providers/SalonProvider.dart';

class FactureScreen2 extends StatelessWidget {
  const FactureScreen2({Key? key, required this.rdv,required this.color}) : super(key: key);
  final RendezVous rdv;
  final Color color;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Rendez-vous",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 24)),
        backgroundColor: color,
        elevation: 5,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    Text("Salon", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${rdv.salon}", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                  if(rdv.team == true)Text("Expert: ${rdv.teamInfo?.name}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey.shade600),maxLines: 2,),
                  Text("${rdv.location}", style: const TextStyle(
                    fontSize: 14,fontWeight: FontWeight.w600,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                ],
              ),

              const SizedBox(height: 35,),

              // RDV
              SizedBox(
                height: 20,
                child: Row(
                  children:  [
                    Icon(Icons.calendar_month_rounded,color: color,size: 20,),
                    const SizedBox(width: 10,),
                    Text("Rendez-vous", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Text("${rdv.date?.toTitleCase()} à ${rdv.hour} h", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),

              const SizedBox(height: 35,),

              // SERVICES
              SizedBox(
                height: 20,
                child: Row(
                  children:   [
                    Icon(Icons.content_cut_rounded,color: color,size: 20,),
                    const SizedBox(width: 10,),
                    Text("Prestations", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Column(
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
                                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                                child: Text("${e.service}", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,),maxLines: 2,)),
                            Flexible(
                              child: Text( e.prixFin != 0 ? "${e.prix} - ${e.prixFin} DA" : "${e.prix} DA", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),maxLines: 1,),
                            ),
                          ],
                        ),
                      ),
                  ).toList()
              ),
              const SizedBox(height: 35,),


              Text("Prix", style: TextStyle(fontSize: 16,color: color,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
              const Divider(height: 20,),


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
                    Text("Total", style: TextStyle(fontSize: 16,color: color ,fontWeight: FontWeight.w700),),
                    const Spacer(),
                    Text(rdv.prixFin == rdv.prix ? formatPrice(rdv.prix!-rdv.remise!) : "${formatPrice(rdv.prix!-rdv.remise!)} - ${formatPrice(rdv.prixFin!-rdv.remise!)}",
                      style: TextStyle(fontSize: 16,color: color ,fontWeight: FontWeight.w700),),
                  ],
                ),
              ),

              const SizedBox(height: kToolbarHeight,),

              if(rdv.etat == 1)ElevatedButton(
                onPressed: (){
                  if(rdv.etat == 1 && DateTime.now().isBefore(rdv.date2!.toDate())){
                    const snackBar = SnackBar(
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      content: Text("vous ne pouvez pas le terminer avant la date du rendez-vous", style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else if(rdv.etat == 1){
                    Timer(const Duration(milliseconds: 200),() async {
                      await Provider.of<SalonProvider>(context,listen: false).terminerRDV(rdv.id!,rdv.salonID!,context)
                          .then((value) => Navigator.of(context).pop());
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(double.maxFinite, 48),
                    elevation: 6,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  const [
                    Text("Terminer", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white),),
                    SizedBox(width: 15,),
                    Icon(CupertinoIcons.checkmark_alt,color: Colors.white)
                  ],
                ),

              ),

              if(rdv.etat == 1) const SizedBox(height: 25,),

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