import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart'; // Added for compute()
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../data/models/communicationlog.dart';
import '../../../data/models/note_response.dart';
import '../../../data/providers/link/api_endpoints.dart';
import '../../../data/repositories/admin_communication_logs.dart';
import 'package:http/http.dart' as http;

// Top-level helper to determine file type for encoding
String getFileTypeForEncoding(File file) {
  String extension = file.path.split('.').last.toLowerCase();
  if (["jpg", "png", "jpeg", "gif"].contains(extension)) {
    return "image";
  } else if (["mp3", "wav", "aac"].contains(extension)) {
    return "audio";
  } else if (["mp4", "avi", "mov"].contains(extension)) {
    return "video";
  } else {
    return "document";
  }
}

// Top-level function used with compute() for file encoding
Future<Map<String, dynamic>> encodeInBackground(File file) async {
  try {
    final bytes = await file.readAsBytes();
    return {
      "type": getFileTypeForEncoding(file),
      "data": base64Encode(bytes),
      "name": file.path.split('/').last,
      "size": bytes.length,
    };
  } catch (e) {
    return {};
  }
}

// صفحة الشات مثل البريد الإلكتروني
class EmailLikeChatPage extends StatefulWidget {
  final CommunicationLog logs;

  const EmailLikeChatPage({Key? key, required this.logs}) : super(key: key);

  @override
  _EmailLikeChatPageState createState() => _EmailLikeChatPageState();
}

class _EmailLikeChatPageState extends State<EmailLikeChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AdminCommunicationLogs _repository = AdminCommunicationLogs(Get.find());
  // ignore: unused_field
  final _logger = Logger();
  List<ChatMessage> _messages = [];
  bool _isRecording = false;
  List<File> _attachedFiles = [];
  int _recordingDuration = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {});
    });
    fetchNotes(); // Fetch notes when page loads
  }

  // دالة لترميز الملفات
  Future<Map<String, dynamic>> encodeFile(File file) async {
    try {
      // إضافة تحقق من حجم الملف
      if (await file.length() > 5 * 1024 * 1024) {
        // 5MB كحد أقصى
        Get.snackbar("Error", "File size exceeds 5MB limit");
        return {};
      }

      // استخدام stream للقراءة الجزئية
      final fileStream = file.openRead();
      final bytes = await fileStream.expand((chunk) => chunk).toList();
      final base64File = base64Encode(bytes);

      return {
        "type": getFileType(file),
        "data": base64File,
        "name": file.path.split('/').last,
        "size": bytes.length,
      };
    } catch (e) {
      print("Error encoding file: $e");
      return {};
    }
  }

  // دالة لتحديد نوع الملف (لـ UI)
  String getFileType(File file) {
    String extension = file.path.split('.').last.toLowerCase();
    if (["jpg", "png", "jpeg", "gif"].contains(extension)) {
      return "image";
    } else if (["mp3", "wav", "aac"].contains(extension)) {
      return "audio";
    } else if (["mp4", "avi", "mov"].contains(extension)) {
      return "video";
    } else {
      return "document";
    }
  }

  void sendNote() async {
    if (_messageController.text.isEmpty && _attachedFiles.isEmpty) {
      Get.snackbar("Error", "Note or file is required");
      return;
    }
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(addNote),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Add log_id
      request.fields['log_id'] = widget.logs.id.toString();

      if (_attachedFiles.isNotEmpty) {
        // Handle file upload
        File file = _attachedFiles.first;
        String extension = file.path.split('.').last.toLowerCase();

        // Set note_type based on file extension
        String noteType;
        if (['jpg', 'jpeg', 'png'].contains(extension)) {
          noteType = 'image';
        } else if (['mp4', 'mov', 'avi'].contains(extension)) {
          noteType = 'video';
        } else if (['mp3', 'wav', 'ogg'].contains(extension)) {
          noteType = 'audio';
        } else {
          noteType = 'file';
        }

        request.fields['note_type'] = noteType;

        // Add the file
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path),
        );
      } else {
        // Handle text note
        request.fields['note_type'] = 'text';
        request.fields['note_value'] = _messageController.text;
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      Navigator.pop(Get.context!); // Close loading dialog
      if (response.statusCode == 201) {
        if (widget.logs.note == null) {
          final success = await _repository.updatelogs(
              widget.logs.id.toString(), _messageController.text);
          if (!success) {
            Get.snackbar(
              "Warning",
              "Failed to update log status",
              duration: Duration(seconds: 3),
            );
          }
        }
        Get.snackbar("Success", "Note sent successfully");
        _messageController.clear();
        _attachedFiles.clear();
        fetchNotes(); // Refresh notes after sending

        // تحقق مما إذا كانت هذه أول رسالة وتحديث السجل
        
      } else {
        Get.snackbar(
          "Error",
          jsonResponse['message'] ?? "Failed to send note",
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        duration: Duration(seconds: 3),
      );
    }
  }

 
  // دالة لضغط الصور باستخدام FlutterImageCompress
  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.path,
      quality: 85,
      minWidth: 800,
      minHeight: 800,
    );
    return File(result!.path);
  }

  // دالة لاختيار الملفات
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _attachedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  // دالة لبدء التسجيل
  Future<void> _startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final appDir = await getApplicationDocumentsDirectory();
      final path =
          '${appDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      await _audioRecorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _startTimer();
      });
    }
  }

  // دالة لإيقاف التسجيل
  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      if (path != null) {
        _attachedFiles.add(File(path));
      }
    });
  }

  // دالة لبدء مؤقت التسجيل
  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRecording) {
        setState(() {
          _recordingDuration++;
        });
        return true;
      }
      return false;
    });
  }

  // دالة لتنسيق مدة التسجيل
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Compose'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendNote,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(_messages[index]);
                    },
                  ),
                ),
                _buildBottomInputArea(),
              ],
            ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: message.isReceived ? Colors.grey[100] : Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: message.isReceived
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (message.text.isNotEmpty)
            Text(
              message.text,
              style: TextStyle(fontSize: 16),
            ),
          if (message.attachments.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: message.attachments.map((file) {
                return _buildAttachmentPreview(file);
              }).toList(),
            ),
          SizedBox(height: 8),
          Text(
            _formatTimestamp(message.timestamp),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview(File file) {
    // Check if the file path is a URL
    bool isUrl = file.path.startsWith('http');
    String fileType = _getFileType(file).name.toLowerCase();

    return GestureDetector(
      onTap: () {
        if (fileType == 'audio') {
          if (isUrl) {
            _audioPlayer.play(UrlSource(file.path));
          } else {
            _audioPlayer.play(DeviceFileSource(file.path));
          }
        }
      },
      child: Container(
        width: fileType == 'image' ? 200 : 60, // Larger size for images
        height: fileType == 'image' ? 200 : 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: fileType == 'image' && isUrl
            ? Image.network(
                file.path,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              )
            : Center(
                child: Icon(
                  _getIconForFile(file),
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
      ),
    );
  }

  // Helper method to get file type from URL or file path
  FileType _getFileType(File file) {
    String path = file.path.toLowerCase();

    if (path.contains('image') ||
        path.endsWith('.jpg') ||
        path.endsWith('.png') ||
        path.endsWith('.jpeg')) {
      return FileType.image;
    } else if (path.contains('audio') ||
        path.endsWith('.wav') ||
        path.endsWith('.mp3')) {
      return FileType.audio;
    } else if (path.contains('video') ||
        path.endsWith('.mp4') ||
        path.endsWith('.mov')) {
      return FileType.video;
    }
    return FileType.any;
  }

  IconData _getIconForFile(File file) {
    switch (_getFileType(file)) {
      case FileType.image:
        return Icons.image;
      case FileType.video:
        return Icons.video_file;
      case FileType.audio:
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          if (_isRecording)
            Row(
              children: [
                Icon(Icons.mic, color: Colors.red),
                Expanded(
                  child: LinearProgressIndicator(),
                ),
                Text(_formatDuration(_recordingDuration)),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _stopRecording,
                )
              ],
            ),
          if (_attachedFiles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _attachedFiles.map((file) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildAttachmentPreview(file),
                  );
                }).toList(),
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: _pickFiles,
              ),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Compose your message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendNote,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateUI(String note, List<File> attachedFiles) {
    setState(() {
      _messages.add(ChatMessage(
        text: note,
        attachments: List.from(attachedFiles),
        timestamp: DateTime.now(),
        isReceived: false,
      ));
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    return '${hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour < 12 ? 'AM' : 'PM'}';
  }

  Future<void> fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(getNote(widget.logs.id.toString())),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final NoteResponse noteResponse =
            NoteResponse.fromJson(json.decode(response.body));

        setState(() {
          // Add initial message (title)
          _messages = [
            ChatMessage(
              text: widget.logs.title,
              attachments: [],
              timestamp: widget.logs.createdAt,
              isReceived: true,
            )
          ];

          // Add notes from the response
          _messages.addAll(
            noteResponse.data.map((note) {
              List<File> attachments = [];
              String text = '';

              switch (note.noteType) {
                case 'text':
                  text = note.noteValue;
                  break;
                case 'audio':
                  // Create a temporary file for audio URL
                  final audioUrl = 'http://${note.noteValue}';
                  attachments.add(File(audioUrl));
                  break;
                case 'image':
                  // Create a temporary file for image URL
                  final imageUrl = 'http://${note.noteValue}';
                  attachments.add(File(imageUrl));
                  break;
                default:
                  text = note.noteValue;
              }

              return ChatMessage(
                text: text,
                attachments: attachments,
                timestamp: note.createdAt,
                isReceived: false,
              );
            }).toList(),
          );
        });
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch notes",
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print("Error fetching notes: $e");
      Get.snackbar(
        "Error",
        "An error occurred while fetching notes",
        duration: Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class ChatMessage {
  final String text;
  final List<File> attachments;
  final DateTime timestamp;
  final bool isReceived;

  ChatMessage({
    required this.text,
    this.attachments = const [],
    required this.timestamp,
    required this.isReceived,
  });
}
