import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_cubit.dart';
import 'package:flutter_herodex_3000/auth/cubit/auth_state.dart';
import 'package:flutter_herodex_3000/config/texts.dart';
import 'package:flutter_herodex_3000/utils/constants.dart';
import 'package:flutter_herodex_3000/utils/snackbar.dart';
import 'package:flutter_herodex_3000/widgets/herodex_logo.dart';
import 'package:flutter_herodex_3000/widgets/signup_widget.dart';
import 'package:flutter_herodex_3000/widgets/uppercase_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _signupAttemptEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Close dialog if open
          if (Navigator.canPop(context) && state.type != 'weak-password') {
            Navigator.of(context).pop();
          }
          // Populate email field if we have a signup attempt email
          if (_signupAttemptEmail != null) {
            _emailController.text = _signupAttemptEmail!;
            _signupAttemptEmail = null;
          }
          // Show error message
          AppSnackBar.of(
            context,
            behavior: SnackBarBehavior.floating,
          ).showError(state.message);
        } else if (state is AuthAuthenticated) {
          // Close dialog if open
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          _signupAttemptEmail = null;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.appPaddingBase * 1.5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const HerodexLogo(),
                  const SizedBox(height: AppConstants.appPaddingBase * 2),
                  Text(
                    AppTexts.common.title.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppConstants.appPaddingBase * 2),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: AppTexts.auth.emailPlaceholder,
                          ),
                          validator: (value) => value!.isEmpty
                              ? AppTexts.auth.invalidEmail
                              : null,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: AppTexts.auth.passwordPlaceholder,
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                          validator: (value) => value!.isEmpty
                              ? AppTexts.auth.invalidPassword
                              : null,
                        ),
                        const SizedBox(height: AppConstants.appPaddingBase),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                UpperCaseElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().signIn(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                  },
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(AppTexts.auth.signIn),
                                ),
                                const SizedBox(
                                  height: AppConstants.appPaddingBase,
                                ),
                                UpperCaseElevatedButton(
                                  onPressed: () async {
                                    // Show sign-up dialog
                                    await showDialog<String>(
                                      context: context,
                                      builder: (context) {
                                        return SignupWidget(
                                          onSignupAttempt: (email) {
                                            _signupAttemptEmail = email;
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text(AppTexts.auth.signUp),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
