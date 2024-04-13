import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class OutPutPageAudio extends StatefulWidget {
  final String audioData;

  OutPutPageAudio({required this.audioData});

  @override
  _OutPutPageAudioState createState() => _OutPutPageAudioState();
}

class _OutPutPageAudioState extends State<OutPutPageAudio> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio(widget.audioData);
  }

  void _playAudio(String audioUrl) async {
// ...
    final player = AudioPlayer();
    await player.play(UrlSource('https://example.com/my-audio.wav'));
    setState(() {
      isPlaying = true;
    });

    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003B80),
        title: Text(
          'Output Page Audio',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the audio data
            Text(
              'Audio Data: ${widget.audioData}',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            // Add a button to play/pause the audio
            ElevatedButton(
              onPressed: () {
                if (isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.resume();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              child: Text(isPlaying ? 'Pause Audio' : 'Resume Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
