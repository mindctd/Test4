import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ResetpasswordPage extends StatelessWidget {
  final String email;
  ResetpasswordPage({super.key, required this.email});

  late final TextEditingController _emailConntroller =
      TextEditingController(text: email);

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reset your password",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text("Please enter your email !"),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 225, 241),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                controller: _emailConntroller,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              child: ElevatedButton(
                onPressed: () async {
                  final email = _emailConntroller.text.trim();
                  if (email.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Fail to reset password",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            content: Text(
                              "Please fill the email !",
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
                    return;
                  }
                  final emailValid = RegExp(
                    r'^[^\s][\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
                  ).hasMatch(email);
                  if (!emailValid) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Fail to reset password",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            content: Text(
                              "Not correct the email format !",
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
                    return;
                  }
                  try {
                    await resetPassword(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.thumb_up, color: Colors.white, size: 20),
                            Text(
                              " Please check your email !",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("เกิดข้อผิดพลาด: ${e}")),
                    );
                  }
                },
                child: Text("Reset"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
