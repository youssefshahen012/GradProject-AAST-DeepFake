import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class OutPutPage extends StatefulWidget {
  @override
  _OutPutPageState createState() => _OutPutPageState();
}

class _OutPutPageState extends State<OutPutPage> {
  final String videoUrl = 'gs://deepfake-c64a9.appspot.com/videotest/wav2lip final video.mp4'; // Firebase Storage video URL

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Create a reference to the Firebase Storage video URL
      final storageRef = FirebaseStorage.instance.refFromURL(videoUrl);

      // Get download URL for the video
      final downloadUrl = await storageRef.getDownloadURL();

      // Initialize video player controller
      _videoPlayerController = VideoPlayerController.network(downloadUrl);

      // Initialize chewie controller
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: true,
        allowFullScreen: true,
      );

      setState(() {});
    } catch (e) {
      print('Error initializing video: $e');
      // Handle error initializing video
    }
  }

  Future<void> _downloadVideo() async {
    try {
      // Get the app's directory path
      final directory = await getExternalStorageDirectory();
      final savePath = '${directory!.path}/video.mp4';

      // Start downloading the video
      final taskId = await FlutterDownloader.enqueue(
        url: videoUrl,
        savedDir: directory.path,
        fileName: 'video.mp4',
        showNotification: true,
        openFileFromNotification: true,
      );
    } catch (e) {
      // Handle any errors that occur during the download process
      print('Download failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Download failed: $e'),
      ));
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Output Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 40,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _videoPlayerController != null && _chewieController != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1, // Adjust the aspect ratio as per your video's dimensions
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Video Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _downloadVideo();
            },
            child: Text('Download Video'),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
