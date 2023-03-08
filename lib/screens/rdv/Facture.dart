import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/providers/RendezVousProvider.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/utils/constants.dart';

import 'Done.dart';

class FactureScreen extends StatelessWidget {
  const FactureScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Confirmation",style: TextStyle(fontSize: 22),),
        centerTitle: true,
        elevation: .5 ,
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
                  children:  [
                    Icon(Icons.business_sharp,color: primaryLite.withOpacity(.8),size: 20,),
                    const SizedBox(width: 10,),
                    Text("salon", style: TextStyle(fontSize: 16,color: primaryLite.withOpacity(.8),fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${rdv.rendezVous?.salon}", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                    if(rdv.rendezVous?.team == true)Text("Expert: ${rdv.rendezVous?.teamInfo?.name}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey.shade600),maxLines: 2,),
                    Text("${rdv.rendezVous?.location}", style: const TextStyle(
                      fontSize: 14,fontWeight: FontWeight.w600,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  ],
                );
              }),

              const SizedBox(height: 25,),

             /* SizedBox(
                height: 20,
                child: Row(
                  children:  [
                    Icon(Icons.person_outline_rounded,color: primaryLite,size: 20,),
                    const  SizedBox(width: 10,),
                    Text("client (e)", style: TextStyle(fontSize: 16,color: primaryLite,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${rdv.rendezVous?.user}", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                    Text("${rdv.rendezVous?.userPhone}", style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,),maxLines: 2,),
                  ],
                );
              }),

              const SizedBox(height: 25,),*/

              // RDV
              SizedBox(
                height: 20,
                child: Row(
                  children:  [
                    Icon(Icons.calendar_month_rounded,color: primaryLite.withOpacity(.8),size: 20,),
                    const SizedBox(width: 10,),
                    Text("Rendez-vous", style: TextStyle(fontSize: 16,color: primaryLite.withOpacity(.8),fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${rdv.rendezVous?.date?.toTitleCase()} à ${rdv.rendezVous?.hour} h", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                  ],
                );
              }),

              const SizedBox(height: 25,),

              // SERVICES
              SizedBox(
                height: 20,
                child: Row(
                  children:  [
                    Icon(Icons.content_cut_rounded,color: primaryLite.withOpacity(.8),size: 20,),
                    const SizedBox(width: 10,),
                    Text("Prestations", style: TextStyle(fontSize: 16,color: primaryLite.withOpacity(.8),fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rdv.rendezVous!.services.map((e) =>
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
                );
              }),

              const Divider(height: 20,),

              // PRIX
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 20,
                  child: Row(
                    children: [
                      Text("Montant", style: TextStyle(fontSize: 16,color: primaryPro,fontWeight: FontWeight.w600),),
                      const Spacer(),
                      Text(rdv.rendezVous?.prixFin == rdv.rendezVous?.prix ? "${rdv.rendezVous?.prix} DA" : "${rdv.rendezVous?.prix} - ${rdv.rendezVous?.prixFin} DA", style: TextStyle(fontSize: 16,color: primaryPro,fontWeight: FontWeight.w600),),
                    ],
                  ),
                );
              }),

              // REMISE
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 20,
                  child: Row(
                    children: [
                      const Text("Remise", style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                      const Spacer(),
                      Text("- ${rdv.rendezVous?.remise} DA", style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                    ],
                  ),
                );
              }),

              // TOTAL
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 20,
                  child: Row(
                    children: [
                      Text("Total", style: TextStyle(fontSize: 16,color: primaryLite,fontWeight: FontWeight.w600),),
                      const Spacer(),
                      Text(rdv.rendezVous?.prixFin == rdv.rendezVous?.prix ? formatPrice(rdv.rendezVous!.prix!-rdv.rendezVous!.remise!) : "${formatPrice(rdv.rendezVous!.prix!-rdv.rendezVous!.remise!)} - ${formatPrice(rdv.rendezVous!.prixFin!-rdv.rendezVous!.remise!)}",
                        style:TextStyle(fontSize: 16,color: primaryLite,fontWeight: FontWeight.w600),),
                    ],
                  ),
                );
              }),

              const SizedBox(height: kToolbarHeight,),


              ElevatedButton(
                onPressed:() async {
                  await Provider.of<RDVProvider>(context,listen: false).createRDV().then((value){
                    if(value == true){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DoneScreen()),);
                    }
                  }).catchError((e){
                    GFToast.showToast("$e", context,toastDuration: 3,backgroundColor: red,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  fixedSize: const Size(double.maxFinite, 56),
                  elevation: 6,
                  foregroundColor: clr3,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Confirmer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22,color: Colors.white),),
                    SizedBox(width: 15,),
                    Icon(Icons.check_rounded,color: Colors.white,size: 30,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}