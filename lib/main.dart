import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(SimpleMusicApp());
}

class SimpleMusicApp extends StatelessWidget {
  const SimpleMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;

  // Local MP3 file paths (assets)
  final List<String> _songs = [
    'assets/music/Legends.mp3',  // Asset path for Legends
    'assets/music/Misfit.mp3',   // Asset path for Misfit
    'assets/music/Lucid_Dreams.mp3',  // Asset path for Lucid Dreams
  ];

  final List<String> _songTitles = [
    'Juice WRLD - Legends',
    'Juice WRLD - Misfit',
    'Juice WRLD - Lucid Dreams',
  ];

  @override
  void initState() {
    super.initState();
    _playSong(_currentIndex);
  }

  // Play the song by loading it from the assets folder
  void _playSong(int index) async {
    try {
      await _audioPlayer.setAsset(_songs[index]);  // Load from assets
      _audioPlayer.play();
    } catch (e) {
      print('Error loading the song: $e');
    }
  }

  void _playNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
      _playSong(_currentIndex);
    });
  }

  void _playPrevious() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
      _playSong(_currentIndex);
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
        backgroundColor: Colors.green.shade700,
        title: Text('Simple Music App', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Colors.grey[850], // Dark Grey background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Now Playing Text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Now Playing: ${_songTitles[_currentIndex]}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

            // Song List
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Choose a Song:', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _songTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: _currentIndex == index ? Colors.green.shade300 : null,
                    title: Text(
                      _songTitles[index],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _playSong(_currentIndex);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Controls at the Bottom
      bottomNavigationBar: BottomAppBar(
        color: Colors.green.shade700,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Button
              ElevatedButton(
                onPressed: _playPrevious,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(1),
                  backgroundColor: Colors.green.shade800, // Darker green for buttons
                  elevation: 5,
                ),
                child: Icon(Icons.skip_previous, color: Colors.white, size: 30),
              ),

              // Play/Pause Button
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data?.playing ?? false;
                  return ElevatedButton(
                    onPressed: () {
                      isPlaying ? _audioPlayer.pause() : _audioPlayer.play();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(1),
                      backgroundColor: Colors.green.shade800, // Darker green for buttons
                      elevation: 5,
                    ),
                    child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 30),
                  );
                },
              ),

              // Next Button
              ElevatedButton(
                onPressed: _playNext,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(1),
                  backgroundColor: Colors.green.shade800, // Darker green for buttons
                  elevation: 5,
                ),
                child: Icon(Icons.skip_next, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
