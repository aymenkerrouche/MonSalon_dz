import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monsalondz/root.dart';

import '../../theme/colors.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
            Lottie.asset("assets/animation/done.json",reverse: true),
            const Text("Félicitations,",
              style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.w700),
            ),
            const Text("Vous avez réussi à prendre rendez-vous.",
              style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed:(){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const Root()), (Route<dynamic> route) => false);},
                  style: TextButton.styleFrom(
                    backgroundColor: clr3 ,
                    //padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6)
                  ),
                  child: Row(
                    children: const [
                      Text("  Continue", style: TextStyle(fontSize: 22,color: primary,fontWeight: FontWeight.w600),),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios_rounded,size: 26,color: primary,),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
