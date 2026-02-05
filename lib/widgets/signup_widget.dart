import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/config/app_texts.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class SignupWidget extends StatefulWidget {
  final Function(String email)? onSignupAttempt;

  const SignupWidget({super.key, this.onSignupAttempt});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppTexts.auth.createAccount),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppTexts.auth.emailPlaceholder,
              ),
              validator: (value) =>
                  value!.isEmpty ? AppTexts.auth.invalidEmail : null,
            ),

            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppTexts.auth.passwordPlaceholder,
              ),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? AppTexts.auth.invalidPassword : null,
            ),
          ],
        ),
      ),
      actions: [
        UpperCaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppTexts.common.cancel),
        ),
        const SizedBox(height: AppConstants.appPaddingBase * 2),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return UpperCaseElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSignupAttempt?.call(_emailController.text);
                  context.read<AuthCubit>().signUp(
                    _emailController.text,
                    _passwordController.text,
                  );
                }
              },
              child: state is AuthLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(AppTexts.auth.signUp),
            );
          },
        ),
      ],
    );
  }
}
