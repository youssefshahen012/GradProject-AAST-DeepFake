import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'OutPutPage.dart';
Future<String?> uploadImageToFirebase(String imagePath) async {
  final Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now()}');
  final UploadTask uploadTask = storageReference.putFile(File(imagePath));

  try {
    await uploadTask;
    final String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<String?> uploadAudioToFirebase(String audioPath) async {
  final Reference storageReference = FirebaseStorage.instance.ref().child('audios/${DateTime.now()}');
  final UploadTask uploadTask = storageReference.putFile(File(audioPath));

  try {
    await uploadTask;
    final String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading audio: $e');
    return null;
  }
}

class OutputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Output Page'),
      ),
      body: Center(
        child: Text('Output Page'),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  File? _image;
  File? _audio;

  Future<void> _captureImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save the image to local storage
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String localImagePath = '${appDirectory.path}/captured_image.png';
      final File localImageFile = File(localImagePath);
      await localImageFile.writeAsBytes(await pickedFile.readAsBytes());

      // Upload the image to Firebase Storage
      final imageUrl = await uploadImageToFirebase(localImagePath);

      // Save the image path to Firebase Database
      if (imageUrl != null) {
        DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('images');
        databaseReference.push().set({'imagePath': imageUrl});
      }
    }
  }

  Future<void> _selectImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save the image to local storage
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String localImagePath = '${appDirectory.path}/selected_image.png';
      final File localImageFile = File(localImagePath);
      await localImageFile.writeAsBytes(await pickedFile.readAsBytes());

      // Upload the image to Firebase Storage
      final imageUrl = await uploadImageToFirebase(localImagePath);

      // Save the image path to Firebase Database
      if (imageUrl != null) {
        DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('images');
        databaseReference.push().set({'imagePath': imageUrl});
      }
    }
  }

  Future<void> _selectAudioFromDevice() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false, // Only allow selecting one audio file
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      setState(() {
        _audio = File(pickedFile.files.single.path!);
      });

      final audioUrl = await uploadAudioToFirebase(_audio!.path);

      // Save the audio path to Firebase Database
      if (audioUrl != null) {
        DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('audios');
        databaseReference.push().set({'audioPath': audioUrl});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Video Page',
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
              onPressed: _captureImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
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
                'Open Camera',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectImageFromGallery,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
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
                'Select Image from Gallery',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectAudioFromDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff003B80),
                padding: EdgeInsets.all(16.0),
                minimumSize: Size(double.infinity, 0),
                fixedSize: Size(200, 60),
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
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle submit action
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OutPutPage()), // Replace with your OutputPage
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
