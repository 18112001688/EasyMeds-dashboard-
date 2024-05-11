import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medcs_dashboard/core/utlity/sanck_bar.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';
import 'package:medcs_dashboard/views/dashboard_view.dart';
import 'package:medcs_dashboard/widgets/custom_password_form_field.dart';
import 'package:medcs_dashboard/widgets/email_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
final _form = GlobalKey<FormState>();
bool _isLoding = false;

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoding,
      child: Scaffold(
        body: Form(
          key: _form,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: 500,
                    padding: const EdgeInsets.only(top: 300),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'EasyMeds',
                          style: TextStyle(
                            color: Color(0xff1E2772),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Login to the admin pannel',
                          style: StylesLight.titleRegualar22,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomEmailFormField(controller: _emailController),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomPassFormField(
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 50,
                          width: 410,
                          child: TextButton(
                            onPressed: () {
                              login();
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff283342)),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Color(0xffF1F3F6),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffF1F3F6),
                            spreadRadius: 10,
                            blurRadius: 15,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 500),
                      child: SvgPicture.asset('assets/images/Group 2014.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      if (_form.currentState!.validate()) {
        setState(() {
          _isLoding = true;
        });
        String email = _emailController.text.trim();
        String pass = _passwordController.text.trim();
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.buildSnackBar(
              message: 'Logged in successfully',
              color: Colors.green,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        // Handle different authentication errors
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.buildSnackBar(
              message: 'No user found for this email!',
              color: Colors.red,
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.buildSnackBar(
              message: 'Wrong password for this email!',
              color: Colors.red,
            ),
          );
        } else {
          // Display the specific Firebase authentication error message
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar.buildSnackBar(
              message: '${e.message}',
              color: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.buildSnackBar(
            message: '$e',
            color: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoding = false;
        });
      }
    }
  }
}
