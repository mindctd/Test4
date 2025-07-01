import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/crud.dart';
import 'package:firebase_crud/resetPassword.dart';
import 'package:firebase_crud/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void>? _loginVerify(String inputemail, String inputpassword) async {
    if (inputemail.isEmpty || inputpassword.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Column(
                  children: [
                    Text(
                      "Fail to Login !",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              content: Text(
                "Please fill all of Field and Correctly!",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ),
              ],
            );
          });
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.white, size: 20),
                Text(
                  " Login Successfully !",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(Duration(seconds: 2));
        // await FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CrudPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Column(
                    children: [
                      Text(
                        "Fail to Login !",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                content: Text(
                  "Username or Password is incorrct",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"),
                    ),
                  ),
                ],
              );
            });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text("Welcome back !"),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextfieldLogin(
                    icon: Icons.person,
                    suficon: null,
                    title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Username')),
                    controller: _emailController,
                    inputFormatters: [
                      RemoveEmojiInputFormatter(),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@.]'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextfieldLogin(
                      icon: Icons.person,
                      suficon: Icons.visibility_off,
                      inputFormatters: [
                        RemoveEmojiInputFormatter(),
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                      ],
                      title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password')),
                      controller: _passwordController),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetpasswordPage(
                                        email: _emailController.text.trim())));
                          },
                          child: Text("Reset password",
                              style: TextStyle(
                                color: Colors.purple,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.purple,
                                decorationThickness: 2,
                              ))),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _loginVerify(_emailController.text.trim(),
                              _passwordController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                        child: Text('Create new account')),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       analytics.logEvent(
                  //           name: 'Check', parameters: {'mind': "test"});
                  //       print("✅ Analytics event sent: Check");
                  //     },
                  //     child: Text('test analytics'))
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class TextfieldLogin extends StatefulWidget {
  final IconData icon;
  final IconData? suficon;
  final Widget title;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;

  const TextfieldLogin(
      {super.key,
      required this.icon,
      required this.suficon,
      required this.title,
      required this.controller,
      this.onChanged,
      this.obscureText = false,
      this.inputFormatters = const <TextInputFormatter>[]});

  @override
  State<TextfieldLogin> createState() => _TextfieldLoginState();
}

class _TextfieldLoginState extends State<TextfieldLogin> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.suficon != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          widget.title,
          SizedBox(
              width: double.infinity,
              child: TextField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  obscureText: isPassword ? obscureText : false,
                  inputFormatters: widget.inputFormatters,
                  decoration: InputDecoration(
                    prefixIcon: Icon(widget.icon),
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 225, 241),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ))),
        ],
      ),
    );
  }
}
