import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app.sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app.sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app.sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app.sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggelFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'test@test.com',
            enabled: model.isLoading == false),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: model.updateEmail,
        onEditingComplete: () => _emailEditingComplete(),
      ),
      SizedBox(
        height: 8.0,
      ),
      TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          // errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        onChanged: model.updatePassword,
      ),
      SizedBox(
        height: 12.0,
      ),
      FormSubmitButton(
        onPressed: _submit,
        text: model.primaryButtonText,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        // onPressed: _toggleFormType(model),
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
