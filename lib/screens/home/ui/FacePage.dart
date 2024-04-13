import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'OutPutPage.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FacePage(),
    );
  }
}

class FacePage extends StatelessWidget {
  Future<void> uploadFileToFirebase(File file, String folderName) async {
    try {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('$folderName/${DateTime.now()}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata to Realtime Database
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
      await databaseReference.child('files').push().set({
        'name': file.path.split('/').last, // or any other metadata you want to save
        'url': downloadUrl,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadFileToFirebase(imageFile, 'images');
    }
  }

  Future<void> _selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadFileToFirebase(imageFile, 'images');
    }
  }

  Future<void> _selectVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      File videoFile = File(result.files.single.path!);
      await uploadFileToFirebase(videoFile, 'videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Face Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        titleSpacing: 3.0,
        iconTheme: IconThemeData(color: Colors.white, size: 42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                _openCamera(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
              ).merge(
                ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Color(0xff003B80);
                    },
                  ),
                ),
              ),
              child: Text(
                'Open Camera',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _selectImage(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
              ).merge(
                ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Color(0xff003B80);
                    },
                  ),
                ),
              ),
              child: Text(
                'Select Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _selectVideo(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
              ).merge(
                ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue;
                      }
                      return Color(0xff003B80);
                    },
                  ),
                ),
              ),
              child: Text(
                'Select Video',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle submit action
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OutPutPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff003B80),
            padding: EdgeInsets.all(16.0),
            minimumSize: Size(double.infinity, 0),
          ).merge(
            ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  }
                  return Color(0xff003B80);
                },
              ),
            ),
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
