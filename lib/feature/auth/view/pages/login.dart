import 'package:client/core/app_pallette.dart';
import 'package:client/core/utils/show_snack_msg.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/feature/auth/view/pages/signup.dart';
import 'package:client/feature/auth/view/widgets/auth_button.dart';
import 'package:client/feature/auth/view/widgets/form_field.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/feature/home/view/pages/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authViewModelProvider.select((val) => val.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next.when(
          data: (data) {
            if (data != null) {
              showSnackMessage(context, "Login successful");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (_) => false);
            }
          },
          error: (error, stacktrace) {
            showSnackMessage(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
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
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: 120,
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: AssetImage("assets/logo.jpeg"),
                    //     ),
                    //   ),
                    // ),
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
                      labelText: "Email",
                      textController: _emailController,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      labelText: "Password",
                      textController: _passwordController,
                      isPasswordField: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthButton(
                      buttonText: "Sign In",
                      onTab: () async {
                        if (formKey.currentState!.validate()) {
                          // send data to server
                          ref.read(authViewModelProvider.notifier).login(
                              email: _emailController.text,
                              password: _passwordController.text);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              );
                            },
                          children: [
                            TextSpan(
                              text: "Register here",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupPage(),
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
