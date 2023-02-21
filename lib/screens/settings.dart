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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1),),
        backgroundColor: primary,
        centerTitle: true,
        leading: IconButton(
            onPressed:(){Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              txtOption('Confidentiality'),
              Column(
                children: const [
                  OptionSetting(txt:'Accept messages'),
                  OptionSetting(txt:'Show your e-mail'),
                  OptionSetting(txt:'Show your profile picture'),
                  OptionSetting(txt:'Clear cache automatically'),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),
              txtOption('Theme'),
              Column(
                children: [
                  OptionSetting(txt:'Dark mode',onTap: (v){},),
                  //txt('Dark mode'),
                ],
              ),
              const Divider(height: 20,thickness:1),
              txtOption('Notifications'),
              Column(
                children: const [
                  OptionSetting(txt:'Orders'),
                  OptionSetting(txt:'Messages'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container txtOption(String txt){
    return Container(margin: const EdgeInsets.only(bottom: 10,top: 10),child: Text(txt,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: primary),));
  }
}

class OptionSetting extends StatelessWidget {
  const OptionSetting({Key? key,this.txt,this.onTap}) : super(key: key);
  final String? txt;
  final void Function(bool?)? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 10,),
          Text("$txt",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
          const Spacer(flex: 4,),
          GFToggle(
            onChanged: onTap ?? (v){},
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
}

