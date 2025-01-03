import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatScreen extends StatefulWidget {
  final String userId; // Current user ID
  final String recipientId; // Chat recipient ID

  const ChatScreen({
    super.key,
    required this.userId,
    required this.recipientId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();



  final bool _isRecording = false;

  final String _apiKey = "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"; // Replace with your OpenAI API key

  // Send a message to Firestore
  Future<void> _sendMessage(String message,
      {String? imageUrl, String? audioUrl}) async {
    if (message.isEmpty && imageUrl == null && audioUrl == null) return;

    try {
      final timestamp = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': widget.userId,
        'recipientId': widget.recipientId,
        'message': message,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'timestamp': timestamp,
      });

      _messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  // Upload a file to Firebase Storage
  Future<String?> _uploadFile(String path, String folder) async {
    try {
      final file = File(path);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final ref = FirebaseStorage.instance.ref('$folder/$fileName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('File upload failed: $e');
      return null;
    }
  }

  // Fetch response from ChatGPT
  Future<String> _getChatGPTResponse(String userMessage) async {
    const String apiUrl = "https://api.openai.com/v1/chat/completions";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // or "gpt-4" if available
          "messages": [
            {"role": "system", "content": "You are a helpful travel assistant."},
            {"role": "user", "content": userMessage}
          ],
          "max_tokens": 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        debugPrint("Error from API: ${response.body}");
        return "Sorry, I couldn't process your request.";
      }
    } catch (e) {
      debugPrint("Error fetching ChatGPT response: $e");
      return "An error occurred. Please try again.";
    }
  }

  // Handle user input and ChatGPT response
  Future<void> _handleSendMessage(String message) async {
    if (message.isEmpty) return;

    // Add user's message to chat
    await _sendMessage(message);

    // Fetch and add ChatGPT's response to chat
    try {
      String reply = await _getChatGPTResponse(message);
      await _sendMessage(reply);
    } catch (e) {
      debugPrint('Error fetching ChatGPT response: $e');
      await _sendMessage("Sorry, I couldn't fetch a response. Please try again.");
    }
  }

  Future<void> _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageUrl = await _uploadFile(pickedFile.path, 'images');
      if (imageUrl != null) {
        await _sendMessage('', imageUrl: imageUrl);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('senderId',
                      whereIn: [widget.userId, widget.recipientId])
                  .where('recipientId',
                      whereIn: [widget.userId, widget.recipientId])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == widget.userId;
                    final messageText = message['message'] ?? '';
                    final imageUrl = message['imageUrl'];
                    final audioUrl = message['audioUrl'];

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (imageUrl != null)
                              Image.network(imageUrl,
                                  width: 150, height: 150, fit: BoxFit.cover),
                            if (audioUrl != null)
                              IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  // Handle audio playback here
                                },
                              ),
                            if (messageText.isNotEmpty)
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: _sendImage,
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.mic : Icons.mic_none,
                      color: Colors.red),
                  onPressed: () {}, // Implement audio feature as needed
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () =>
                      _handleSendMessage(_messageController.text.trim()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
