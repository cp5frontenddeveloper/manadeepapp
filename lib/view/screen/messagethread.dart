import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MessageThread extends StatefulWidget {
  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> messages = [
    {
      'id': 1,
      'author': 'Abdulfattah',
      'content': "مراجع جميع الطلبات التي قمت بطلبها",
      'timestamp': 'Yesterday at 10:26 pm',
      'avatar': 'A',
      'isReplyOpen': false,
      'attachments': [],
    },
  ];

  String newReply = '';
  List<Map<String, dynamic>> attachments = [];
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String? recordingPath;
  late AnimationController _animationController;
  int recordingDuration = 0;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => audioDuration = d);
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => audioPosition = p);
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        audioPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  void handleReplyClick(int messageId) {
    setState(() {
      messages.forEach((msg) {
        if (msg['id'] == messageId) {
          msg['isReplyOpen'] = !msg['isReplyOpen'];
        }
      });
    });
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        handleFileUpload(File(image.path), 'image');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        handleFileUpload(File(video.path), 'video');
      }
    } catch (e) {
      print('Error picking video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick video: $e')),
      );
    }
  }

  Future<void> pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        handleFileUpload(File(file.path), 'file');
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }

  void handleFileUpload(File file, String type) {
    setState(() {
      attachments.add({'type': type, 'url': file, 'name': p.basename(file.path)});
    });
  }

  void removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  void handleSendReply(int messageId) {
    if (newReply.trim().isNotEmpty || attachments.isNotEmpty) {
      setState(() {
        messages.add({
          'id': messages.length + 1,
          'author': 'User',
          'content': newReply,
          'timestamp': 'Just now',
          'avatar': 'U',
          'attachments': [...attachments],
        });
        newReply = '';
        attachments = [];
        handleReplyClick(messageId);
      });
    }
  }

  Future<void> _handleRecording() async {
    try {
      if (isRecording) {
        final filepath = await audioRecorder.stop();
        setState(() {
          isRecording = false;
          recordingPath = filepath;
          recordingDuration = 0;
        });
        _animationController.stop();
        handleFileUpload(File(recordingPath!), 'audio');
      } else {
        if (await audioRecorder.hasPermission()) {
          final appDir = await getApplicationDocumentsDirectory();
          final filepath = p.join(
              appDir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.wav');
          await audioRecorder.start(const RecordConfig(), path: filepath);
          setState(() {
            isRecording = true;
            recordingPath = null;
          });
          _animationController.repeat(reverse: true);
          _startTimer();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Microphone permission denied')),
          );
        }
      }
    } catch (e) {
      print('Recording error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording failed: $e')),
      );
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isRecording) {
        timer.cancel();
      } else {
        setState(() {
          recordingDuration++;
        });
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Thread'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          var message = messages[index];
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(message['avatar']),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message['author'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(message['timestamp'],
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(message['content'], textDirection: TextDirection.rtl),
                  if (message['attachments'].isNotEmpty)
                    Column(
                      children: message['attachments'].map<Widget>((attachment) {
                        return Container(
                          margin: EdgeInsets.only(top: 8),
                          child: attachment['type'] == 'image'
                              ? Image.file(attachment['url'], height: 160)
                              : attachment['type'] == 'video'
                                  ? VideoWidget(url: attachment['url'])
                                  : attachment['type'] == 'audio'
                                      ? AudioWidget(url: attachment['url'])
                                      : Text(attachment['name']),
                        );
                      }).toList(),
                    ),
                  TextButton(
                    onPressed: () => handleReplyClick(message['id']),
                    child: Text('Reply'),
                  ),
                  if (message['isReplyOpen'])
                    Column(
                      children: [
                        if (attachments.isNotEmpty)
                          Wrap(
                            children: attachments.map<Widget>((attachment) {
                              int idx = attachments.indexOf(attachment);
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(4),
                                    child: attachment['type'] == 'image'
                                        ? Image.file(attachment['url'],
                                            height: 64, width: 64)
                                        : attachment['type'] == 'video'
                                            ? VideoWidget(url: attachment['url'])
                                            : attachment['type'] == 'audio'
                                                ? AudioWidget(url: attachment['url'])
                                                : Text(attachment['name']),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.close, size: 16),
                                      onPressed: () => removeAttachment(idx),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type your reply...',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) => newReply = value,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () => handleSendReply(message['id']),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.image),
                              onPressed: pickImage,
                            ),
                            IconButton(
                              icon: Icon(Icons.video_library),
                              onPressed: pickVideo,
                            ),
                            IconButton(
                              icon: Icon(Icons.attach_file),
                              onPressed: pickFile,
                            ),
                            IconButton(
                              icon: Icon(Icons.mic),
                              onPressed: _handleRecording,
                            ),
                          ],
                        ),
                        if (isRecording)
                          Row(
                            children: [
                              Icon(Icons.mic, color: Colors.red),
                              SizedBox(width: 8),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CustomPaint(
                                      painter: WaveformPainter(
                                        animation: _animationController.value,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              Text(
                                _formatDuration(recordingDuration),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String url;
  VideoWidget({required this.url});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.url))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AudioWidget extends StatefulWidget {
  final String url;
  AudioWidget({required this.url});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => audioDuration = d);
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => audioPosition = p);
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        audioPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handlePlayback() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
        setState(() => isPlaying = false);
      } else {
        if (audioPosition.inSeconds == 0) {
          await audioPlayer.play(DeviceFileSource(widget.url));
        } else {
          await audioPlayer.resume();
        }
        setState(() => isPlaying = true);
      }
    } catch (e) {
      print('Playback error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3942),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 48,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: Colors.teal,
                ),
                onPressed: _handlePlayback,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: audioPosition.inSeconds.toDouble(),
            max: audioDuration.inSeconds.toDouble(),
            onChanged: (value) {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.teal,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(audioPosition.inSeconds),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(audioDuration.inSeconds),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class WaveformPainter extends CustomPainter {
  final double animation;

  WaveformPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final segments = 30;
    final segmentWidth = width / segments;

    for (var i = 0; i < segments; i++) {
      final x = i * segmentWidth;
      final normalizedX = i / segments;
      final amplitude = sin(normalizedX * 10 + animation * 2 * pi) * 0.5 + 0.5;
      final y = height / 2;
      final lineHeight = height * 0.6 * amplitude;

      canvas.drawLine(
        Offset(x, y - lineHeight / 2),
        Offset(x, y + lineHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => true;
}