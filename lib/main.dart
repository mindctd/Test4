import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/crud.dart';
import 'package:firebase_crud/login.dart';
import 'package:firebase_crud/resetPassword.dart';
import 'package:firebase_crud/signUp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBpB0xC-WyvsnsLKlFkJPRGAXKEITvU7J4",
        authDomain: "crudcar-5f374.firebaseapp.com",
        projectId: "crudcar-5f374",
        storageBucket: "crudcar-5f374.firebasestorage.app",
        messagingSenderId: "423201429871",
        appId: "1:423201429871:web:68e6bfed3de50acd2f309a",
        measurementId: "G-HJ72X2BFKT",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 851),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}
