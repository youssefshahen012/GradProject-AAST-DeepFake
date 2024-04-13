import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../theming/colors.dart';
import '/helpers/extensions.dart';
import '/routing/routes.dart';
import '/theming/styles.dart';
import '../../../core/widgets/app_text_button.dart';

import 'VideoPage.dart';
import 'FacePage.dart';
import 'AudioPage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the common ButtonStyle
    final commonButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff003B80),
    ).merge(
      ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue; // Change color when pressed
            }
            return const Color(0xff003B80); // Set default color
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff003B80),
        title: const Text(
          'Deep Fake',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titleSpacing: 3.0,
        iconTheme: const IconThemeData(color: Colors.white, size: 42),
        actions: [],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xff003B80),
              ),
              child: Text(
                FirebaseAuth.instance.currentUser?.email ?? 'Email not available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('AAST college Of AI ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25,),),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Supervisor: \nDr : Ali Fahmy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30,)),
              onTap: () {
                // Handle supervisor tap
              },
            ),
            ListTile(
              title: Text('Dr: Hany Hanfy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25)),
              onTap: () {
                // Handle supervisor tap
              },
            ),
            ListTile(
              title: Text('eng: Alia Hanafy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25)),
              onTap: () {
                // Handle supervisor tap
              },
            ),
            ListTile(
              title: Text('Students:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25)),
              onTap: () {
                // Handle students tap
              },
            ),
            ListTile(
              title: Text('Youssef Hesham Shahen',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
            ListTile(
              title: Text('Ahmed Salem',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
            ListTile(
              title: Text('Ahmed Hesham',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
            ListTile(
              title: Text('Abdelrhman lasheen',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
            ListTile(
              title: Text('Mohamed Dawood',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
            ListTile(
              title: Text('Yasser Salah',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22,)),
              onTap: () {
                // Handle student tap
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VideoPage()),
                          );
                        },
                        style: commonButtonStyle,
                        child: const Text(
                          'Generate Video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FacePage()),
                          );
                        },
                        style: commonButtonStyle,
                        child: const Text(
                          'Face Swapping',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AudioPage()),
                          );
                        },
                        style: commonButtonStyle,
                        child: const Text(
                          'Generate Audio',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h), // Added padding to bottom button
                child: TextButton(
                  onPressed: () async {
                    try {
                      GoogleSignIn().disconnect();
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.loginScreen,
                            (route) => false,
                      );
                    } catch (e) {
                      await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Sign out error',
                        desc: e.toString(),
                      ).show();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff003B80), // Use the same background color
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
