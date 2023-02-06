import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:monsalondz/root.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';


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
            enabledTrackColor: Provider.of<ThemeProvider>(context,listen: false).primary,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(width: 5,),
        ],
      ),
    );
  }
}


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<ThemeProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1),),
        backgroundColor: provider.primary,
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

              txtOption('Confidentiality',provider),
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
              txtOption('Theme',provider),
              Column(
                children: [
                  OptionSetting(txt:'Dark mode',onTap: (v){},),
                  //txt('Dark mode'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:(){
                      setState(() {
                        provider.setPrimary(Colors.green.shade700, Colors.green.shade900);
                      });
                      Timer(const Duration(milliseconds: 1000),(){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Root()),
                                (route) => false);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(side: BorderSide.none),
                        backgroundColor: provider.green,
                        fixedSize: const Size(20, 20)
                    ),
                    child: const Text("G",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              const Divider(height: 20,thickness:1),
              txtOption('Notifications',provider),
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
  Container txtOption(String txt,provider){
    return Container(margin: const EdgeInsets.only(bottom: 10,top: 10),child: Text(txt,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: provider.primary),));
  }
}


