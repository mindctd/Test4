import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/login.dart';
import 'package:firebase_crud/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  String _emailMessage = '';
  final TextEditingController _passwordController = TextEditingController();
  String _passwordMessage = '';
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _confirmPasswordMessage = '';
  final TextEditingController _nameSurnameController = TextEditingController();
  String _nameSurnameMessage = '';
  final TextEditingController _surnameController = TextEditingController();
  String _surnameMessage = '';
  final TextEditingController _telephoneController = TextEditingController();
  String _telephoneMessage = '';
  final TextEditingController _addressController = TextEditingController();
  String _addressMessage = '';

  String verifyMessage = '';

  DateTime? _selectedDate;
  final List<String> _items = ['Men', 'Women', 'Not specified'];
  int _selectedIndex = -1;
  // ignore: unused_field
  bool _genderSelected = false;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCupertinoPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    backgroundColor: Colors.white,
                    scrollController: FixedExtentScrollController(
                        initialItem: _selectedIndex),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _items
                        .map((item) => Center(child: Text(item)))
                        .toList(),
                  ),
                ),
              ),
              CupertinoButton(
                  child: Text('Select'),
                  onPressed: () {
                    setState(() {
                      _genderSelected = true;
                    });
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _signVerify(
      String inputemail,
      String inputpassword,
      String inputcomfirmpassword,
      String inputname,
      String inputsurname,
      String inputAddress,
      String inputtelephone,
      DateTime? inputdate,
      int inputgender) async {
    if (inputemail.isEmpty ||
        inputpassword.isEmpty ||
        inputcomfirmpassword.isEmpty ||
        inputname.isEmpty ||
        inputsurname.isEmpty ||
        inputtelephone.isEmpty ||
        inputAddress.isEmpty ||
        inputdate == null ||
        inputgender == -1 ||
        _emailMessage.isNotEmpty ||
        _passwordMessage.isNotEmpty ||
        _confirmPasswordMessage.isNotEmpty ||
        _nameSurnameMessage.isNotEmpty ||
        _surnameMessage.isNotEmpty ||
        _telephoneMessage.isNotEmpty ||
        _addressMessage.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Column(
                  children: [
                    Text(
                      "Fail to Sign Up",
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
      // setState(() {
      //   verifyMessage = ' Please fill all fields correctly';
      // });
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.white, size: 20),
                Text(
                  " Sign up Successfully !",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(Duration(seconds: 2));
        await FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                    child: Column(
                      children: [
                        Text(
                          "Fail to Sign Up",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  content: Text(
                    "This email is already in used !",
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
      } catch (e) {
        print(e);
      }
    }
  }

  void _validateEmail(String value) {
    final isValid = Utils().isValidEmail(value.trim());
    setState(() {
      _emailMessage = isValid ? '' : ' Invalid email format';
    });
  }

  void _validatePassword(String value) {
    final isValid = Utils().isValidPassword(value.trim());
    setState(() {
      _passwordMessage = isValid
          ? ''
          : ' Needs to be at least 6 characters long and contain letters and numbers';
    });
  }

  void _confirmPassword(String value) {
    setState(() {
      value == _passwordController.text
          ? _confirmPasswordMessage = ''
          : _confirmPasswordMessage = ' Passwords do not match';
    });
  }

  void _nameSurname(String value) {
    final isValid = Utils().isValidName(value.trim());
    setState(() {
      _nameSurnameMessage = isValid
          ? ''
          : ' Needs to be at least 1 characters long and contain no spaces or emojis';
    });
  }

  void _surname(String value) {
    final isValid = Utils().isValidSurname(value.trim());
    setState(() {
      _surnameMessage = isValid
          ? ''
          : ' Needs to be at least 1 characters long and contain no spaces or emojis';
    });
  }

  void _validateTelephone(String value) {
    final isValid = Utils().istelephoneNumber(value.trim());
    setState(() {
      _telephoneMessage =
          isValid ? '' : ' Needs to be only 10 numbers long and start with 0';
    });
  }

  void _validateAddress(String value) {
    final isValid = Utils().isValidAddress(value.trim());
    setState(() {
      _addressMessage = isValid
          ? ''
          : ' Needs to be at least 1 characters long and contain no emojis';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text("Create your account !"),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    TextfieldSignup(
                      icon: Icons.email,
                      suficon: null,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email"),
                      ),
                      controller: _emailController,
                      onChanged: _validateEmail,
                      inputFormatters: [
                        RemoveEmojiInputFormatter(),
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@.]'),
                        ),
                      ],
                      errorMessage: _emailMessage,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  icon: Icons.password,
                  suficon: Icons.visibility_off,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password"),
                  ),
                  controller: _passwordController,
                  onChanged: _validatePassword,
                  
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  errorMessage: _passwordMessage,
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  icon: Icons.password,
                  suficon: Icons.visibility_off,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Confirm Password"),
                  ),
                  controller: _confirmPasswordController,
                  onChanged: _confirmPassword,
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  errorMessage: _confirmPasswordMessage,
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  icon: Icons.person,
                  suficon: null,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name"),
                  ),
                  controller: _nameSurnameController,
                  onChanged: _nameSurname,
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  errorMessage: _nameSurnameMessage,
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  icon: Icons.person,
                  suficon: null,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Surname"),
                  ),
                  controller: _surnameController,
                  onChanged: _surname,
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  errorMessage: _surnameMessage,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 239, 225, 241),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 10),
                          Text(_selectedDate != null
                              ? "${_selectedDate!.toLocal().toString().split(' ')[0]}"
                              : 'Birth Date')
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showCupertinoPicker(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 239, 225, 241),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.man_4_sharp),
                          // Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text('   Gender')),
                          SizedBox(width: 10),
                          Text(_selectedIndex >= 0
                              ? _items[_selectedIndex]
                              : 'Gender')
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  suficon: null,
                  icon: Icons.person,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Telephone"),
                  ),
                  controller: _telephoneController,
                  onChanged: _validateTelephone,
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  errorMessage: _telephoneMessage,
                ),
                SizedBox(
                  height: 20,
                ),
                TextfieldSignup(
                  suficon: null,
                  icon: Icons.person,
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Address"),
                  ),
                  controller: _addressController,
                  onChanged: _validateAddress,
                  inputFormatters: [
                    RemoveEmojiInputFormatter(),
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                  ],
                  errorMessage: _addressMessage,
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        _signVerify(
                          _emailController.text,
                          _passwordController.text,
                          _confirmPasswordController.text,
                          _nameSurnameController.text,
                          _surnameController.text,
                          _addressController.text,
                          _telephoneController.text,
                          _selectedDate,
                          _selectedIndex,
                        );
                        ;
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text('Already have account')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextfieldSignup extends StatefulWidget {
  final IconData icon;
  final IconData? suficon;
  final Widget title;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  final String? errorMessage;

  const TextfieldSignup({
    super.key,
    required this.icon,
    required this.suficon,
    required this.title,
    required this.controller,
    this.onChanged,
    this.inputFormatters,
    this.obscureText = false,

    this.errorMessage,
  });

  @override
  State<TextfieldSignup> createState() => _TextfieldSignupState();
}

class _TextfieldSignupState extends State<TextfieldSignup> {
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
                  inputFormatters: widget.inputFormatters,
                  obscureText: isPassword ? obscureText :false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(widget.icon),
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            })
                        : null,
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 225, 241),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    errorText: (widget.errorMessage != null &&
                            widget.errorMessage!.isNotEmpty)
                        ? widget.errorMessage
                        : null,
                  ))),
        ],
      ),
    );
  }
}
