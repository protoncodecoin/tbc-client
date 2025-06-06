import 'package:client/core/app_pallette.dart';
import 'package:client/core/utils/show_snack_msg.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/feature/auth/view/pages/login.dart';
import 'package:client/feature/auth/view/widgets/auth_button.dart';
import 'package:client/feature/auth/view/widgets/form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authViewModelProvider.select((val) => val.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (data != null) {
              showSnackMessage(
                  context, "Account created successfully. Please Login");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          },
          error: (error, st) {
            showSnackMessage(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 30),
        ),
      ),
      body: isLoading
          ? Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.vertical,
                            children: [
                              Text("THE",
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              Text("BEAUTIFUL",
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              Text("CHURCH",
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomFormField(
                      labelText: "Username",
                      textController: _usernameController,
                    ),
                    CustomFormField(
                      labelText: "Email",
                      textController: _emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      labelText: "Password",
                      textController: _passwordController,
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      labelText: "Confirm Password",
                      textController: _confirmPasswordController,
                      isPasswordField: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthButton(
                      buttonText: "Sign Up",
                      onTab: () async {
                        if (formKey.currentState!.validate()) {
                          ref.read(authViewModelProvider.notifier).signUp(
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign In",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                              style: TextStyle(
                                  color: AppPallette.gradientInlineButtonColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
