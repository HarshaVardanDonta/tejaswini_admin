// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tejaswini_admin/constants.dart';

//custom text widget
class CustomText extends StatefulWidget {
  String content;
  double size;
  FontWeight weight;
  Color color;
  CustomText(
      {Key? key,
      required this.color,
      required this.content,
      required this.size,
      required this.weight})
      : super(key: key);

  @override
  State<CustomText> createState() => CustomTextState();
}

class CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.content,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
            letterSpacing: 0.5,
            color: widget.color,
            fontSize: widget.size,
            fontWeight: widget.weight),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  bool isObscure;
  String hint;
  String lable;
  TextEditingController controller;
  CustomTextField(
      {Key? key,
      required this.hint,
      required this.lable,
      required this.isObscure,
      required this.controller})
      : super(key: key);

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isObscure,
      style: GoogleFonts.poppins(textStyle: TextStyle(color: text)),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        label: CustomText(
            color: text,
            content: widget.lable,
            size: 15,
            weight: FontWeight.w500),
        hintText: widget.hint,
        hintStyle: GoogleFonts.poppins(textStyle: TextStyle(color: text)),
      ),
    );
  }
}

class CustomButtomWithIcon extends StatefulWidget {
  String content;
  IconData icon;
  Color buttonColor;
  double textSize;
  dynamic onPressedButon;
  CustomButtomWithIcon(
      {Key? key,
      required this.buttonColor,
      required this.content,
      required this.onPressedButon,
      required this.textSize,
      required this.icon})
      : super(key: key);

  @override
  State<CustomButtomWithIcon> createState() => _CustomButtomWithIconState();
}

class _CustomButtomWithIconState extends State<CustomButtomWithIcon> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressedButon,
      icon: Icon(
        widget.icon,
        color: text,
      ),
      label: CustomText(
          color: text,
          content: widget.content,
          size: widget.textSize,
          weight: FontWeight.w500),
      style: ElevatedButton.styleFrom(
        primary: widget.buttonColor,
        padding: EdgeInsets.all(8),
      ),
    );
  }
}

class DashboardContainer extends StatefulWidget {
  String content;
  dynamic onPress;
  double textSize;
  FontWeight textWeight;
  DashboardContainer(
      {Key? key,
      required this.content,
      required this.onPress,
      required this.textWeight,
      required this.textSize})
      : super(key: key);

  @override
  State<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends State<DashboardContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: container, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: CustomText(
              color: text,
              content: widget.content,
              size: widget.textSize,
              weight: widget.textWeight),
        ),
      ),
    );
  }
}

class ContainerEmpStatus extends StatefulWidget {
  Widget child;
  ContainerEmpStatus({Key? key, required this.child}) : super(key: key);

  @override
  State<ContainerEmpStatus> createState() => _ContainerEmpStatusState();
}

class _ContainerEmpStatusState extends State<ContainerEmpStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          color: container, borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: widget.child,
      ),
    );
  }
}
