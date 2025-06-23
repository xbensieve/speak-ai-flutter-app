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

class _TutorScreenState extends State<TutorScreen>
    with SingleTickerProviderStateMixin {
  final HubConnection hubConnection =
      HubConnectionBuilder()
          .withUrl('${ApiConfig.baseUrl}/chatHub')
          .build();
  final TextEditingController _messageController =
      TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController =
      ScrollController();
  final FocusNode _textFieldFocus = FocusNode();
  String? _userId;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  bool _showTextField = false;
  bool _messageSent = false;
  int _loadingCount = 0;
  late AnimationController _micAnimationController;

  void _updateLoadingState(bool isStarting) {
    if (mounted) {
      setState(() {
        _loadingCount =
            isStarting
                ? _loadingCount + 1
                : _loadingCount - 1;
        if (_loadingCount < 0) {
          _loadingCount = 0;
        }
      });
    }
  }

  bool get _isLoading => _loadingCount > 0;

  @override
  void initState() {
    super.initState();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadUserId();
    _startHubConnection();
    _setupSignalRListeners();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        debugPrint('[Debug] Speech status: $status');
        if (mounted) {
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
        }
      },
      onError: (error) {
        debugPrint('[Debug] Speech error: $error');
        if (mounted) {
          setState(() {
            _isListening = false;
            _messageSent = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Speech recognition error. Please try again.',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
    );
    if (!available && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Speech recognition not available on this device.',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _loadUserId() {
    final decodeToken = getDecodedAccessToken();
    if (mounted) {
      setState(() {
        _userId = decodeToken?['Id']?.toString();
      });
    }
  }

  Future<void> _startHubConnection() async {
    try {
      await hubConnection.start()!.timeout(
        const Duration(seconds: 10),
        onTimeout:
            () => throw Exception('Connection timeout'),
      );
      debugPrint('[Debug] SignalR connection started.');
    } catch (e) {
      debugPrint(
        '[Debug] Error starting SignalR connection: $e',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to connect to chat server. Please check your connection.',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _setupSignalRListeners() {
    hubConnection.on('ReceiveMessage', (arguments) {
      if (arguments != null &&
          arguments.isNotEmpty &&
          mounted) {
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
        final double currentPosition =
            _scrollController.position.pixels;
        final double maxScroll =
            _scrollController.position.maxScrollExtent;
        const double threshold = 120.0;
        if (currentPosition >= maxScroll - threshold ||
            _messages.last['sender'] == 'User') {
          _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
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
    if (mounted) {
      setState(() {
        _messages.add({
          'sender': 'User',
          'message': message,
        });
        _updateLoadingState(true);
        _scrollToBottom();
      });
    }
    _messageController.clear();
    _textFieldFocus.unfocus();
    final startTime = DateTime.now();
    const minLoadingDuration = Duration(milliseconds: 500);
    try {
      final response = await hubConnection
          .invoke('SendMessage', args: [chatHubDTO])
          .timeout(
            const Duration(seconds: 15),
            onTimeout:
                () =>
                    throw Exception('Message send timeout'),
          );
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minLoadingDuration) {
        await Future.delayed(minLoadingDuration - elapsed);
      }
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'AI',
            'message': response.toString(),
          });
          _updateLoadingState(false);
          _scrollToBottom();
        });
      }
    } catch (e) {
      debugPrint('[Debug] Error sending message: $e');
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minLoadingDuration) {
        await Future.delayed(minLoadingDuration - elapsed);
      }
      if (mounted) {
        setState(() {
          _updateLoadingState(false);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send message. Please try again.',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05,
              ),
              child: const CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            ),
          ),
    );
  }

  Future<void> _endConversation() async {
    if (mounted) {
      setState(() {
        _updateLoadingState(true);
      });
    }
    try {
      final response = await hubConnection
          .invoke('EndConversation')
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () =>
                    throw Exception(
                      'End conversation timeout',
                    ),
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
      if (mounted) {
        setState(() {
          _updateLoadingState(false);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error ending conversation. Please try again.',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
      _micAnimationController.reverse();
      if (mounted) {
        setState(() {
          _isListening = false;
          _showTextField = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _messageSent = false;
          _lastWords = '';
          _isListening = true;
          _showTextField = false;
          _textFieldFocus.unfocus();
        });
      }
      _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _lastWords = result.recognizedWords;
            });
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        cancelOnError: true,
        partialResults: true,
        localeId: 'en-US',
      );
      _micAnimationController.forward();
    }
  }

  void _toggleTextField() {
    if (mounted) {
      setState(() {
        _showTextField = !_showTextField;
        if (_showTextField && _isListening) {
          _speech.stop();
          _micAnimationController.reverse();
          _isListening = false;
        }
        if (_showTextField) {
          _textFieldFocus.requestFocus();
        } else {
          _textFieldFocus.unfocus();
        }
      });
    }
  }

  void _closeInput() {
    if (mounted) {
      setState(() {
        _showTextField = false;
        if (_isListening) {
          _speech.stop();
          _micAnimationController.reverse();
          _isListening = false;
        }
        _textFieldFocus.unfocus();
      });
    }
  }

  @override
  void dispose() {
    _micAnimationController.dispose();
    hubConnection.stop();
    _messageController.dispose();
    _scrollController.dispose();
    _textFieldFocus.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet =
        MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SpeakAI',
          style: GoogleFonts.roboto(
            fontSize: isTablet ? 28 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C2C48),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            Get.defaultDialog(
              title: 'End Conversation',
              titleStyle: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87,
              ),
              middleText:
                  'Are you sure you want to end the conversation?',
              middleTextStyle: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black54,
              ),
              textConfirm: 'Yes',
              textCancel: 'No',
              confirmTextColor: Colors.white,
              buttonColor: Colors.blueAccent,
              cancelTextColor: Colors.black54,
              backgroundColor: Colors.white,
              barrierDismissible: false,
              radius: 12,
              onConfirm: () async {
                Get.back();
                _showLoadingDialog();
                await _endConversation();
              },
              onCancel: () {},
            );
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF2C2C48),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: isTablet ? 24 : 16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.scenarioPrompt,
                        style: GoogleFonts.roboto(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        cacheExtent: 1000,
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
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(
                                      context,
                                    ).size.width *
                                    0.75,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                              padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                              decoration: BoxDecoration(
                                color:
                                    isUser
                                        ? Colors.blueAccent
                                        : Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              child: Text(
                                message['message']!,
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      isTablet ? 16 : 14,
                                  color:
                                      isUser
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _showTextField
                                    ? Icons
                                        .keyboard_alt_outlined
                                    : Icons.keyboard_alt,
                                color: Colors.white70,
                                size: isTablet ? 30 : 26,
                              ),
                              onPressed:
                                  _isLoading
                                      ? null
                                      : _toggleTextField,
                              tooltip: 'Toggle keyboard',
                            ),
                            const SizedBox(width: 20),
                            ScaleTransition(
                              scale: Tween(
                                begin: 1.0,
                                end: 1.2,
                              ).animate(
                                CurvedAnimation(
                                  parent:
                                      _micAnimationController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _isListening
                                          ? Colors
                                              .blueAccent
                                          : Colors
                                              .transparent,
                                  border: Border.all(
                                    color: Colors.white70,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isListening
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: Colors.white70,
                                    size:
                                        isTablet ? 30 : 26,
                                  ),
                                  onPressed:
                                      _isLoading
                                          ? null
                                          : _toggleListening,
                                  tooltip: 'Voice input',
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const Icon(
                                Icons.close_sharp,
                                color: Colors.white70,
                                size: 26,
                              ),
                              onPressed:
                                  _isLoading
                                      ? null
                                      : _closeInput,
                              tooltip: 'Close input',
                            ),
                          ],
                        ),
                        if (_showTextField)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode:
                                        _textFieldFocus,
                                    style:
                                        GoogleFonts.roboto(
                                          fontSize:
                                              isTablet
                                                  ? 16
                                                  : 14,
                                          color:
                                              Colors.white,
                                        ),
                                    controller:
                                        _messageController,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Type your message...',
                                      hintStyle:
                                          GoogleFonts.roboto(
                                            fontSize:
                                                isTablet
                                                    ? 16
                                                    : 14,
                                            color:
                                                Colors
                                                    .white54,
                                          ),
                                      filled: true,
                                      fillColor: Colors
                                          .white
                                          .withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 20,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                              30,
                                            ),
                                        borderSide:
                                            BorderSide.none,
                                      ),
                                    ),
                                    onSubmitted:
                                        _isLoading
                                            ? null
                                            : _sendMessage,
                                    enabled: !_isLoading,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration:
                                      const BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color:
                                            Colors
                                                .blueAccent,
                                      ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.send_sharp,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed:
                                        _isLoading
                                            ? null
                                            : () => _sendMessage(
                                              _messageController
                                                  .text,
                                            ),
                                    tooltip: 'Send message',
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
              SafeArea(
                child: Stack(
                  children: [
                    // Các widget khác
                    if (_isLoading)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                                BorderRadius.circular(22),
                          ),
                          child:
                              const CupertinoActivityIndicator(
                                radius: 14,
                                color: Colors.white,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
