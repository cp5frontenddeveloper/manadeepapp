import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/email_like_chat_controller.dart';
import '../../data/models/communicationlog.dart';

class EmailLikeChatView extends StatelessWidget {
  final CommunicationLog logs;
  late final EmailLikeChatController controller;

  EmailLikeChatView({Key? key, required this.logs}) : super(key: key) {
    controller = Get.put(EmailLikeChatController(logs));
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
            onPressed: controller.sendNote,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageItem(controller.messages[index]);
                  },
                )),
          ),
          _buildBottomInputArea(controller),
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
                return _buildAttachmentPreview(file, controller);
              }).toList(),
            ),
          SizedBox(height: 8),
          Text(
            controller.formatTimestamp(message.timestamp),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview(
      File file, EmailLikeChatController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.getFileType(file) == FileType.audio) {
          controller.audioPlayer.play(DeviceFileSource(file.path));
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            _getIconForFile(file),
            size: 40,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  IconData _getIconForFile(File file) {
    switch (controller.getFileType(file)) {
      // ignore: constant_pattern_never_matches_value_type
      case FileType.image:
        return Icons.image;
      // ignore: constant_pattern_never_matches_value_type
      case FileType.video:
        return Icons.video_file;
      // ignore: constant_pattern_never_matches_value_type
      case FileType.audio:
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildBottomInputArea(EmailLikeChatController controller) {
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
          if (controller.isRecording.value)
            Row(
              children: [
                Icon(Icons.mic, color: Colors.red),
                Expanded(
                  child: LinearProgressIndicator(),
                ),
                Text(controller
                    .formatDuration(controller.recordingDuration.value)),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: controller.stopRecording,
                )
              ],
            ),
          if (controller.attachedFiles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.attachedFiles.map((file) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildAttachmentPreview(file, controller),
                  );
                }).toList(),
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: controller.pickFiles,
              ),
              IconButton(
                icon:
                    Icon(controller.isRecording.value ? Icons.stop : Icons.mic),
                onPressed: controller.isRecording.value
                    ? controller.stopRecording
                    : controller.startRecording,
              ),
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Compose your message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: controller.sendNote,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
