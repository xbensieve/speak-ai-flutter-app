import 'package:english_app_with_ai/components/navigation_menu.dart';
import 'package:english_app_with_ai/config/api_configuration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils/decode_token.dart';

class TutorScreen extends StatefulWidget {
  final int topicId;
  final String scenarioPrompt;

  const TutorScreen({
    super.key,
    required this.topicId,
    required this.scenarioPrompt,
  });

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  final HubConnection hubConnection =
      HubConnectionBuilder().withUrl('${ApiConfig.baseUrl}/chatHub').build();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  String? _userId;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  bool _showTextField = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _startHubConnection();
    _setupSignalRListeners();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech status: $status');
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) => print('Speech error: $error'),
    );
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  Future<void> _loadUserId() async {
    try {
      final decodeToken = getDecodedAccessToken();
      setState(() {
        _userId = decodeToken?['Id']?.toString();
      });
    } catch (e) {
      print('Error decoding token: $e');
    }
  }

  Future<void> _startHubConnection() async {
    try {
      await hubConnection.start();
      print('SignalR connection started.');
    } catch (e) {
      print('Error starting SignalR connection: $e');
    }
  }

  void _setupSignalRListeners() {
    hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        setState(() {
          _messages.add({'sender': 'AI', 'message': arguments[0].toString()});
          _scrollToBottom();
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (_userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID not found')));
      return;
    }

    if (message.trim().isEmpty) return;

    final chatHubDTO = {
      'UserId': _userId,
      'Message': message,
      'TopicId': widget.topicId,
    };

    setState(() {
      _messages.add({'sender': 'User', 'message': message});
      _scrollToBottom();
    });
    _messageController.clear();

    try {
      final response = await hubConnection.invoke(
        'SendMessage',
        args: [chatHubDTO],
      );
      setState(() {
        _messages.add({'sender': 'AI', 'message': response.toString()});
        _scrollToBottom();
      });
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  Future<void> _endConversation() async {
    try {
      final response = await hubConnection.invoke('EndConversation');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.toString(),
            style: const TextStyle(fontSize: 14),
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));

      // Stop the SignalR connection
      await hubConnection.stop();
      print('SignalR connection stopped.');

      Get.off(() => const NavigationMenu());
      print('SignalR connection stopped.');
    } catch (e) {
      print('Error ending conversation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error ending conversation')),
      );
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _showTextField = false; // Hide TextField when stopping listening
      });
    } else {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _messageController.text = _lastWords;
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        cancelOnError: true,
        partialResults: true,
      );
      setState(() {
        _isListening = true;
        _showTextField = false; // Ensure TextField is hidden when listening
      });
    }
  }

  void _toggleTextField() {
    setState(() {
      _showTextField = !_showTextField;
      if (_showTextField && _isListening) {
        _speech.stop();
        _isListening = false;
      }
    });
  }

  void _closeInput() {
    setState(() {
      _showTextField = false;
      if (_isListening) {
        _speech.stop();
        _isListening = false;
      }
    });
  }

  @override
  void dispose() {
    hubConnection.stop();
    _messageController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Chat',
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            await _endConversation();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.scenarioPrompt,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'User';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['message']!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard,
                          color: Colors.white70,
                          size: 30,
                        ),
                        onPressed: _toggleTextField,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _isListening
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _toggleListening,
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 30,
                        ),
                        onPressed: _closeInput,
                      ),
                    ],
                  ),
                  if (_showTextField)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blueAccent,
                            ),
                            onPressed:
                                () => _sendMessage(_messageController.text),
                          ),
                        ],
                      ),
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
