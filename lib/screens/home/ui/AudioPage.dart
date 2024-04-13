import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'OutPutPageAudio.dart';

class AudioPage extends StatelessWidget {
  // Method to store text in Firebase Realtime Database
  void _storeTextInFirebase(String text) {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
      databaseReference.child('text').push().set({
        'content': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }).then((_) {
        print('Text uploaded to Firebase Realtime Database');
      }).catchError((error) {
        print('Error uploading text to Firebase Realtime Database: $error');
      });
    } catch (e) {
      print('Error uploading text to Firebase Realtime Database: $e');
    }
  }

  // Method to handle audio selection
  Future<void> _selectAudio(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        Reference storageReference = FirebaseStorage.instance.ref().child('audios/${DateTime.now()}');
        UploadTask uploadTask = storageReference.putFile(File(file.path!));

        uploadTask.whenComplete(() async {
          String audioUrl = await storageReference.getDownloadURL();
          try {
            DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
            databaseReference.child('audio').push().set({
              'url': audioUrl,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            }).then((_) {
              print('Audio URL uploaded to Firebase Realtime Database');
            }).catchError((error) {
              print('Error uploading audio URL to Firebase Realtime Database: $error');
            });
          } catch (e) {
            print('Error uploading audio URL to Firebase Realtime Database: $e');
          }
        });
      }
    } catch (e) {
      print('Error selecting audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String textFieldValue = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Generate Audio',
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
            TextField(
              onChanged: (value) {
                textFieldValue = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter text for Text-to-Speech',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _storeTextInFirebase(textFieldValue);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
              ).merge(
                ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                'Save Text',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectAudio(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
              ).merge(
                ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                'Select Audio',
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OutPutPageAudio(audioData: '',)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff003B80),
            padding: EdgeInsets.all(16.0),
            minimumSize: Size(double.infinity, 0),
          ).merge(
            ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
