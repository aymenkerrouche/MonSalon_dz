import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:monsalondz/theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: primary,
        centerTitle: true,
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              txtOption('Confidentiality'),
              Column(
                children: [
                  txt('Accept messages'),
                  txt('Show your e-mail'),
                  txt('Show your profile picture'),
                  txt('Clear cache automatically'),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),
              txtOption('Theme'),
              Column(
                children: [
                  txt('Dark mode'),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),
              txtOption('Notifications'),
              Column(
                children: [
                  txt('Orders'),
                  txt('Messages'),
                  //txt('Dark mode'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  SizedBox txt(String txt){
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 10,),
           Text(txt,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          const Spacer(flex: 4,),
          GFToggle(
            onChanged: (val){},
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

  Container txtOption(String txt){
    return Container(margin: const EdgeInsets.only(bottom: 10,top: 10),child: Text(txt,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: primary),));
  }
}
