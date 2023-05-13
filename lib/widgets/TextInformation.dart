import 'package:flutter/material.dart';

import '../theme/colors.dart';


class TextInfomation extends StatelessWidget {
  TextInfomation({Key? key, required this.textController, this.hint, this.label,this.icon, this.textType = TextInputType.number, this.readOnly = false, this.maxLine= 1}) : super(key: key);
  TextEditingController textController;
  String? label ;
  String? hint ;
  IconData? icon;
  TextInputType? textType;
  bool readOnly;
  int maxLine;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.white,),
      child: TextFormField(
        keyboardType: textType,
        controller: textController,
        cursorColor: primary,
        textCapitalization: TextCapitalization.sentences,
        readOnly: readOnly,
        maxLines: maxLine,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black45),
          labelStyle: const TextStyle(color: primary),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:  Icon(
            icon,
            color: primary,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primary, width: 1.5),
              gapPadding: 6),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: clr3.withOpacity(.5), width: 1.5),
              gapPadding: 6),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        ),
      ),
    );
  }
}


class TextDescription extends StatelessWidget {
  TextDescription({Key? key, required this.textController, this.hint, this.label,}) : super(key: key);
  TextEditingController textController;
  String? label ;
  String? hint ;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.white,),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: textController,
        cursorColor: primary,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black45),
          labelStyle: const TextStyle(color: primary),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primary, width: 1.5),
              gapPadding: 6),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: clr3.withOpacity(.5), width: 1.5),
              gapPadding: 6),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        ),
      ),
    );
  }
}