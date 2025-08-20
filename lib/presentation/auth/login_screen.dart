import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/auth_model.dart';
import 'package:student/presentation/auth/login_state.dart';
import 'package:student/presentation/bottom_nav/bottom_nav.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();

    final TextEditingController email = TextEditingController();
    final TextEditingController psw = TextEditingController();

    ref.listen(loginProvider, (p, n) {
      n.when(
        data: (_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login success')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BottomNav();
              },
            ),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    final loginstate = ref.watch(loginProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff5A3F37), Color(0xff2C7744)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/uu.png'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    SizedBox(height: 30),
                    textField(email, 'Email', 'Eamil'),
                    SizedBox(height: 10),
                    pasTextField(psw, 'Password', 'Password'),
                    SizedBox(height: 10),
                    loginstate.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: Colors.black),
                            ),
                            onPressed: () {
                              if (!key.currentState!.validate()) return;
                              ref
                                  .read(loginProvider.notifier)
                                  .login(
                                    LoginModel(
                                      email: email.text.trim(),
                                      password: psw.text.trim(),
                                    ),
                                  );
                            },
                            child: Text(
                              'Login',
                              style: 13.sp(color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account  ',
                            style: 12.sp(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Register here',
                            style: 15
                                .sp(color: Colors.white)
                                .copyWith(decoration: TextDecoration.underline),
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
      ),
    );
  }
}

Widget textField(TextEditingController c, String hint, String label) {
  return TextFormField(
    controller: c,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: hint,
      hintStyle: 14.sp(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return '$label is Missing';
      return null;
    },
  );
}

Widget pasTextField(TextEditingController c, String hint, String label) {
  return Consumer(
    builder: (context, ref, child) {
      final isObscure = ref.watch(passwordProvider);
      return TextFormField(
        controller: c,
        obscureText: isObscure,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          hintStyle: 14.sp(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              ref.read(passwordProvider.notifier).state = !isObscure;
            },
            icon: Icon(
              isObscure ? Icons.visibility_off_outlined : Icons.visibility,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return '$label is Missing';
          if (value.length < 6) return '$label must be at least 6';
          return null;
        },
      );
    },
  );
}
