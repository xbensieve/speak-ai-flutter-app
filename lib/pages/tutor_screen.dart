import 'package:english_app_with_ai/config/api_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../utils/decode_token.dart';
import 'assessment_screen.dart';

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
      HubConnectionBuilder()
          .withUrl('${ApiConfig.baseUrl}/chatHub')
          .build();
  final TextEditingController _messageController =
      TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController =
      ScrollController();
  String? _userId;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  bool _showTextField = false;
  bool _messageSent = false;

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
        debugPrint('[Debug] Speech status: $status');
        setState(() {
          _isListening = false;
          if (status == 'done' ||
              status == 'notListening') {
            if (_lastWords.isNotEmpty && !_messageSent) {
              _sendMessage(_lastWords);
              _messageSent = true;
            }
          }
        });
      },
      onError: (error) {
        debugPrint('[Debug] Speech error: $error');
        setState(() {
          _isListening = false;
          _messageSent = false;
        });
      },
    );
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition not available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  void _loadUserId() {
    final decodeToken = getDecodedAccessToken();
    setState(() {
      _userId = decodeToken?['Id']?.toString();
    });
  }

  Future<void> _startHubConnection() async {
    try {
      await hubConnection.start();
      debugPrint('[Debug] SignalR connection started.');
    } catch (e) {
      debugPrint(
        '[Debug] Error starting SignalR connection: $e',
      );
    }
  }

  void _setupSignalRListeners() {
    hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        setState(() {
          _messages.add({
            'sender': 'AI',
            'message': arguments[0].toString(),
          });
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
    if (message.trim().isEmpty) {
      debugPrint('[Debug] Message is empty');
      return;
    }
    final chatHubDTO = {
      'UserId': _userId,
      'Message': message.trim(),
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
        _messages.add({
          'sender': 'AI',
          'message': response.toString(),
        });
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('[Debug] Error sending message: $e');
      return;
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            ),
          ),
    );
  }

  Future<void> _endConversation() async {
    try {
      final response = await hubConnection.invoke(
        'EndConversation',
      );
      debugPrint(
        '[Debug] EndConversation response: $response',
      );
      await hubConnection.stop();
      debugPrint('Status: ${hubConnection.state}');
      Map<String, String> parsedResponse = _parseResponse(
        response.toString(),
      );
      Get.offAll(
        () => AssessmentScreen(
          botResponse:
              'Thanks for chatting! Here\'s your summary and feedback:',
          summary: parsedResponse['Summary'] ?? '',
          strengths: parsedResponse['Strengths'] ?? '',
          weaknesses: parsedResponse['Weaknesses'] ?? '',
          suggestions: parsedResponse['Suggestions'] ?? '',
        ),
      );
    } catch (e) {
      debugPrint('Error ending conversation: $e');
    }
  }

  Map<String, String> _parseResponse(String response) {
    Map<String, String> result = {};
    final lines = response.split('\n');
    for (var line in lines) {
      if (line.contains('Summary:')) {
        result['Summary'] =
            line.replaceAll('Summary:', '').trim();
      }
      if (line.contains('Strengths:')) {
        result['Strengths'] =
            line.replaceAll('Strengths:', '').trim();
      }
      if (line.contains('Weaknesses:')) {
        result['Weaknesses'] =
            line.replaceAll('Weaknesses:', '').trim();
      }
      if (line.contains('Suggestions:')) {
        result['Suggestions'] =
            line.replaceAll('Suggestions:', '').trim();
      }
    }
    return result;
  }

  void _toggleListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _showTextField = false;
      });
    } else {
      setState(() {
        _messageSent = false;
        _lastWords = '';
      });
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
        localeId: 'en-US',
      );
      setState(() {
        _isListening = true;
        _showTextField = false;
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
          'SpeakAI',
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            Get.defaultDialog(
              title: 'Confirmation',
              titleStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              middleText:
                  'Are you sure you want to end the conversation?',
              middleTextStyle: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.black,
              ),
              textConfirm: 'Yes',
              textCancel: 'No',
              confirmTextColor: Colors.white,
              buttonColor: Colors.blue,
              cancelTextColor: Colors.black,
              backgroundColor: Colors.white,
              onConfirm: () async {
                Get.back();
                _showLoadingDialog();
                try {
                  await _endConversation();
                } catch (e) {
                  debugPrint(
                    'Error ending conversation: $e',
                  );
                }
              },
              onCancel: () {},
            );
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.scenarioPrompt,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                      final isUser =
                          message['sender'] == 'User';
                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin:
                              const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ),
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isUser
                                    ? Colors.blueAccent
                                    : Colors.grey[300],
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                          child: Text(
                            message['message']!,
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              color:
                                  isUser
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.keyboard_alt_outlined,
                            color: Colors.white70,
                            size: 25,
                          ),
                          onPressed: _toggleTextField,
                        ),
                        const SizedBox(width: 25),
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
                              _isListening
                                  ? Icons.mic
                                  : Icons.mic_none,
                              color: Colors.white70,
                              size: 25,
                            ),
                            onPressed: _toggleListening,
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(
                            Icons.close_sharp,
                            color: Colors.white70,
                            size: 25,
                          ),
                          onPressed: _closeInput,
                        ),
                      ],
                    ),
                    if (_showTextField)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                controller:
                                    _messageController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Type your message...',
                                  hintStyle:
                                      GoogleFonts.roboto(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),

                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          30,
                                        ),
                                  ),
                                ),
                                onSubmitted: _sendMessage,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.send_sharp,
                                color: Colors.blueAccent,
                                size: 25,
                              ),
                              onPressed:
                                  () => _sendMessage(
                                    _messageController.text,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
