import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color color,
    required Color textColor,
    required double borderRadius,
    required VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15),
          ),
          borderRadius: borderRadius,
          color: color,
          // height: 40.0,
          onPressed: onPressed,
        );
}
