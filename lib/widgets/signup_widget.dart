import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
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
      title: const Text('Create account'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an email' : null,
            ),

            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
            ),
          ],
        ),
      ),
      actions: [
        UpperCaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'Cancel',
        ),
        const SizedBox(height: 32),
        UpperCaseElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSignupAttempt?.call(_emailController.text);
              context.read<AuthCubit>().signUp(
                _emailController.text,
                _passwordController.text,
              );
            }
          },
          text: 'Save',
        ),
      ],
    );
  }
}
