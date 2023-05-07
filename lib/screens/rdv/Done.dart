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
            Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextButton(
                onPressed:() async {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Root()), (Route<dynamic> route) => false);
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
                    elevation: 20,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("  Continue", style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600),),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward_rounded,size: 26,color: Colors.white,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
