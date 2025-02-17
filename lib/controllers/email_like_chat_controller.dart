import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/communicationlog.dart';
import '../../../data/repositories/admin_communication_logs.dart';

class EmailLikeChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  final AdminCommunicationLogs repository = AdminCommunicationLogs(Get.find());

  var messages = <ChatMessage>[].obs;
  var isRecording = false.obs;
  var attachedFiles = <File>[].obs;
  var recordingDuration = 0.obs;

  final CommunicationLog logs;

  EmailLikeChatController(this.logs);

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onPlayerComplete.listen((event) {
      update();
    });
    messages.add(ChatMessage(
      text: logs.title,
      attachments: [],
      timestamp: logs.createdAt,
      isReceived: true,
    ));
  }

  Future<Map<String, dynamic>> encodeFile(File file) async {
    try {
      if (await file.length() > 5 * 1024 * 1024) {
        Get.snackbar("Error", "File size exceeds 5MB limit");
        return {};
      }

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
    if (messageController.text.isEmpty && attachedFiles.isEmpty) {
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
        Uri.parse('http://192.168.0.108:8000/api/notes'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Add log_id
      request.fields['log_id'] = logs.id.toString();

      if (attachedFiles.isNotEmpty) {
        // Handle file upload
        File file = attachedFiles.first;
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
        request.fields['note_value'] = messageController.text;
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      Navigator.pop(Get.context!); // Close loading dialog

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Note sent successfully");
        updateUI(messageController.text, attachedFiles);
        messageController.clear();
        attachedFiles.clear();
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

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      attachedFiles.addAll(result.paths.map((path) => File(path!)).toList());
    }
  }

  Future<void> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final appDir = await getApplicationDocumentsDirectory();
      final path =
          '${appDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      await audioRecorder.start(const RecordConfig(), path: path);
      isRecording.value = true;
      recordingDuration.value = 0;
      startTimer();
    }
  }

  Future<void> stopRecording() async {
    final path = await audioRecorder.stop();
    isRecording.value = false;
    if (path != null) {
      attachedFiles.add(File(path));
    }
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isRecording.value) {
        recordingDuration.value++;
        return true;
      }
      return false;
    });
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void updateUI(String note, List<File> attachedFiles) {
    messages.add(ChatMessage(
      text: note,
      attachments: List.from(attachedFiles),
      timestamp: DateTime.now(),
      isReceived: false,
    ));
  }

  String formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    return '${hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour < 12 ? 'AM' : 'PM'}';
  }
}

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
