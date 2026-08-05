import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class AudiobookPlayerScreen extends StatefulWidget {
  final String title;
  final String? coverUrl;
  final String rssUrl;

  const AudiobookPlayerScreen({
    super.key,
    required this.title,
    required this.rssUrl,
    this.coverUrl,
  });

  @override
  _AudiobookPlayerScreenState createState() => _AudiobookPlayerScreenState();
}

class _AudiobookPlayerScreenState extends State<AudiobookPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _audioUrl;
  bool _isLoading = true;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    loadAudio();

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });
  }

  Future<void> loadAudio() async {
    final url = await getFirstAudioUrl(widget.rssUrl);
    if (url != null) {
      setState(() {
        _audioUrl = url;
        _isLoading = false;
      });
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getFirstAudioUrl(String rssUrl) async {
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final item = document.findAllElements('item').first;
        final enclosure = item.findElements('enclosure').first;
        final url = enclosure.getAttribute('url');
        return url;
      }
    } catch (e) {
      print('Error parsing RSS: $e');
    }
    return null;
  }

  void togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_audioUrl != null) {
        await _audioPlayer.resume();
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    final coverUrl = widget.coverUrl ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFB30000),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: coverUrl.isNotEmpty
                          ? Image.network(
                              coverUrl,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.4,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.4,
                              color: Colors.white24,
                              child: const Icon(Icons.image,
                                  size: 100, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAD2C2C),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(_currentPosition),
                                style: TextStyle(color: Colors.white)),
                            Text(formatDuration(_totalDuration),
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            min: 0,
                            max: _totalDuration.inSeconds.toDouble() > 0
                                ? _totalDuration.inSeconds.toDouble()
                                : 1,
                            value: _currentPosition.inSeconds.toDouble().clamp(
                                0,
                                _totalDuration.inSeconds.toDouble() > 0
                                    ? _totalDuration.inSeconds.toDouble()
                                    : 1),
                            onChanged: (value) async {
                              final position = Duration(seconds: value.toInt());
                              await _audioPlayer.seek(position);
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.white38,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10,
                                  color: Colors.white, size: 32),
                              onPressed: () async {
                                final newPosition = _currentPosition -
                                    const Duration(seconds: 10);
                                await _audioPlayer.seek(
                                    newPosition >= Duration.zero
                                        ? newPosition
                                        : Duration.zero);
                              },
                            ),
                            GestureDetector(
                              onTap: togglePlayPause,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: const Color(0xFFB30000),
                                  size: 32,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.forward_10,
                                  color: Colors.white, size: 32),
                              onPressed: () async {
                                final newPosition = _currentPosition +
                                    const Duration(seconds: 10);
                                if (newPosition < _totalDuration) {
                                  await _audioPlayer.seek(newPosition);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
