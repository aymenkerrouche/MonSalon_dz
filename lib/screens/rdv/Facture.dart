
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
        title: const Text("Confirmation",style: TextStyle(fontSize: 22,color: Colors.white),),
        centerTitle: true,
        elevation: .5 ,
        backgroundColor: primary,
        leading: IconButton(onPressed:(){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
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
                  children:  const [
                    Icon(Icons.business_sharp,color: primaryLite2,size: 20,),
                    SizedBox(width: 10,),
                    Text("Salon", style: TextStyle(fontSize: 16,color: primaryLite2,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
                  width: size.width,
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
                  padding: const EdgeInsets.symmetric(horizontal:8,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${rdv.rendezVous?.salon}", style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700,),maxLines: 2,),
                      if(rdv.rendezVous?.team == true)Text("Expert: ${rdv.rendezVous?.teamInfo?.name}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey.shade600),maxLines: 2,),
                      Text("${rdv.rendezVous?.location}", style: const TextStyle(
                        fontSize: 14,fontWeight: FontWeight.w600,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20,),

              // RDV
              SizedBox(
                height: 20,
                child: Row(
                  children:  const [
                    Icon(Icons.calendar_month_rounded,color: primaryLite2,size: 20,),
                    SizedBox(width: 10,),
                    Text("Rendez-vous", style: TextStyle(fontSize: 16,color: primaryLite2,fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${rdv.rendezVous?.date?.toTitleCase()} à ${rdv.rendezVous?.hour} h", style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w700,),maxLines: 2,),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20,),

              // SERVICES
              SizedBox(
                height: 20,
                child: Row(
                  children:  const [
                    Icon(Icons.content_cut_rounded,color: primaryLite2,size: 20,),
                    SizedBox(width: 10,),
                    Text("Prestations", style: TextStyle(fontSize: 16,color: primaryLite2,fontWeight: FontWeight.w600,fontFamily: "Roboto"),),
                  ],
                ),
              ),
              Consumer<RDVProvider>(builder: (context, rdv, child){
                return Container(
                  width: size.width,
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
                  padding: const EdgeInsets.symmetric(horizontal:8,vertical: 12),
                  child: Column(
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
                              constraints: BoxConstraints(maxWidth: size.width * 0.55),
                              child: Text("${e.service}", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700,),maxLines: 2,)),
                            Flexible(
                              child: Text( e.prixFin! > e.prix! ? "${e.prix} - ${e.prixFin} DA" : "${e.prix} DA", style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,),maxLines: 1,),
                            ),
                          ],
                        ),
                      ),
                    ).toList()
                  ),
                );
              }),
              const SizedBox(height: 35,),


              const Text("PRIX", style: TextStyle(fontSize: 16,color: primaryLite2,fontWeight: FontWeight.w700),),

              Container(
                width: size.width,
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
                padding: const EdgeInsets.symmetric(horizontal:8,vertical: 12),
                child: Column(
                  children: [
                    // PRIX
                    Consumer<RDVProvider>(builder: (context, rdv, child){
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 20,
                        child: Row(
                          children: [
                            const Text("Montant", style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                            const Spacer(),
                            Text(rdv.rendezVous?.prixFin == rdv.rendezVous?.prix ? "${rdv.rendezVous?.prix} DA" : "${rdv.rendezVous?.prix} - ${rdv.rendezVous?.prixFin} DA", style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
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
                            const Text("Remise", style: TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.w600),),
                            const Spacer(),
                            Text("- ${rdv.rendezVous?.remise} DA", style: const TextStyle(fontSize: 16,color: Colors.teal,fontWeight: FontWeight.w600),),
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
                            const Text("TOTAL", style: TextStyle(fontSize: 18,color: primary,fontWeight: FontWeight.w700),),
                            const Spacer(),
                            Text(rdv.rendezVous?.prixFin == rdv.rendezVous?.prix ? formatPrice(rdv.rendezVous!.prix!-rdv.rendezVous!.remise!) : "${formatPrice(rdv.rendezVous!.prix!-rdv.rendezVous!.remise!)} - ${formatPrice(rdv.rendezVous!.prixFin!-rdv.rendezVous!.remise!)}",
                              style:const TextStyle(fontSize: 17,color: primary,fontWeight: FontWeight.w700),),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),


              const SizedBox(height: kToolbarHeight,),


              ElevatedButton(
                onPressed:() async {
                  await Provider.of<RDVProvider>(context,listen: false).createRDV().then((value){
                    
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DoneScreen()),);
                  
                  }).catchError((e){
                    GFToast.showToast("$e", context,toastDuration: 3,backgroundColor: red,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM, );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  fixedSize: const Size(double.maxFinite, 52),
                  elevation: 6,
                  foregroundColor: Colors.white,
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

              const SizedBox(height: kToolbarHeight,),
            ],
          ),
        ),
      ),
    );
  }
}


