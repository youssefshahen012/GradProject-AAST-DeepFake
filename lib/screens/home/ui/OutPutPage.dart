import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class OutPutPage extends StatelessWidget {
  // Sample list of video URLs
  final List<String> videoUrls = [
    'lib/screens/home/ui/VideosShow/wav2lip final video.mp4',
    // Add more video URLs here...
  ];

  Future<void> _downloadVideo(String videoUrl) async {
    final taskId = await FlutterDownloader.enqueue(
      url: videoUrl,
      savedDir: '/path/to/download', // Specify the directory where you want to save the video
      fileName: 'video.mp4', // Specify the filename for the downloaded video
      showNotification: true, // Show download progress notification
      openFileFromNotification: true, // Open the downloaded file when tapping the notification
    );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio:0.8,
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: VideoPlayerController.network(
                  videoUrls.first,
                ),
                autoPlay: true,
                looping: true,
                 allowFullScreen:true,


              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Video Catalog',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle video tap
                    // Navigate to a video detail page or play the video
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300], // Placeholder for video thumbnail
                          // You can use CachedNetworkImage or Image.network to load thumbnails
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Video Title ${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Video Description ${index + 1}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () {
                                  _downloadVideo(videoUrls[index]);
                                },
                                child: Text('Download Video'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
