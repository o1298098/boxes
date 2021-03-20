import 'package:boxes/style/colors.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key key,
    @required this.hintText,
    this.controller,
    this.onSubmit,
    this.focusNode,
    this.inputType,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.autofillHints,
  }) : super(key: key);
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final List<String> autofillHints;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding * .8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: kGrayColor.withAlpha(100),
          )),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: inputType,
          enableSuggestions: false,
          autofillHints: autofillHints,
          obscureText: obscureText,
          scrollPadding: EdgeInsets.zero,
          cursorColor: kBadgeColor,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
          ),
          onSubmitted: onSubmit,
        ),
      ),
    );
  }
}
