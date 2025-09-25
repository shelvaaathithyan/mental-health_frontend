import 'dart:async';
import 'dart:math' as math;

import 'package:ai_therapy/Controllers/chat_controller.dart';
import 'package:ai_therapy/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TherapyChatbotScreen extends StatefulWidget {
  const TherapyChatbotScreen({super.key});

  static const String routeName = '/therapy-chatbot';

  @override
  State<TherapyChatbotScreen> createState() => _TherapyChatbotScreenState();
}

class _TherapyChatbotScreenState extends State<TherapyChatbotScreen> {
  late final ChatController _chatController;
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late final Worker _aiRespWorker;
  late final Worker _listeningDoneWorker;
  late final Worker _listeningStateWorker;

  final List<_ChatMessage> _messages = [];
  ChatMode _mode = ChatMode.text;
  String _lastVoiceCapture = '';
  String? _lastAiResponse;
  Timer? _recordingTimer;
  Duration _recordingElapsed = Duration.zero;
  Timer? _bannerTimer;
  bool _showKnowledgeBanner = false;
  bool _conversationStarted = false;

  @override
  void initState() {
    super.initState();
    _chatController = Get.put(ChatController());
    _textController = TextEditingController();
    _scrollController = ScrollController();

    _aiRespWorker = ever<String>(_chatController.aiResp, (value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed == _lastAiResponse) return;
      _lastAiResponse = trimmed;
      _addMessage(
        _ChatMessage(
          text: trimmed,
          isUser: false,
          timestamp: DateTime.now(),
          tag: _EmotionTag.thinking(),
        ),
      );
      _playResponseSpeech(trimmed);
    });

    _listeningDoneWorker = ever<bool>(_chatController.isListeningDone, (done) {
      if (!done) return;
      final spoken = _chatController.lastWords.value.trim();
      if (spoken.isEmpty || spoken == _lastVoiceCapture) return;
      _lastVoiceCapture = spoken;
      _addMessage(
        _ChatMessage(
          text: spoken,
          isUser: true,
          timestamp: DateTime.now(),
          fromVoice: true,
          tag: _EmotionTag.voiceCapture(),
        ),
      );
    });

    _listeningStateWorker = ever<bool>(_chatController.isListening, (listening) {
      if (listening) {
        _startRecordingTimer();
      } else {
        _stopRecordingTimer();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _aiRespWorker.dispose();
    _listeningDoneWorker.dispose();
    _listeningStateWorker.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _scheduleBannerDismissal() {
    _bannerTimer?.cancel();
    setState(() {
      _showKnowledgeBanner = true;
    });
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _showKnowledgeBanner = false;
      });
    });
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    setState(() {
      _recordingElapsed = Duration.zero;
    });
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordingElapsed = _recordingElapsed + const Duration(seconds: 1);
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
  }

  void _addMessage(_ChatMessage message) {
    final isFirstMessage = _messages.isEmpty;
    setState(() {
      _conversationStarted = true;
      _messages.add(message);
    });
    if (isFirstMessage) {
      _scheduleBannerDismissal();
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _playResponseSpeech(String text) async {
    try {
      await _chatController.playResponseSpeech(text);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play voice response right now.'),
        ),
      );
    }
  }

  void _startNewConversation() {
    _bannerTimer?.cancel();
    setState(() {
      _conversationStarted = true;
      _messages.clear();
      _mode = ChatMode.text;
      _lastAiResponse = null;
      _lastVoiceCapture = '';
    });
    _scheduleBannerDismissal();
    _scrollToBottom();
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    _textController.clear();
    _addMessage(
      _ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    await _chatController.sendTextPrompt(text);
  }

  void _handleVoiceStart() {
    if (!_chatController.speechEnabled.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is disabled for this device.'),
        ),
      );
      return;
    }
    _lastVoiceCapture = '';
    _chatController.startListening();
  }

  void _handleVoiceCancel() {
    _chatController.lastWords.value = '';
    _chatController.isListeningDone.value = false;
    _chatController.speechToText.stop();
    _chatController.isListening.value = false;
  }

  Future<void> _handleVoiceConfirm() async {
    if (!_chatController.isListening.value) return;
    setState(() {
      _mode = ChatMode.text;
    });
    await _chatController.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ModeToggle(
                mode: _mode,
                onChanged: (mode) {
                  setState(() {
                    _mode = mode;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _mode == ChatMode.text
                    ? _buildTextMode(theme)
                    : _buildVoiceMode(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 16),
          Text(
            'Mindful AI Chatbot',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMode(ThemeData theme) {
    if (!_conversationStarted) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5E8),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Image.asset('assets/robot.png'),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Talk to Neptune AI',
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You have no AI conversations. Get your mind healthy by starting a new one.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: FreudColors.textDark.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startNewConversation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FreudColors.burntOrange,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'New Conversation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _showKnowledgeBanner
                ? _LimitedKnowledgeBanner(theme: theme)
                : const SizedBox.shrink(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            final isTyping = _chatController.processing.value;
            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                if (_messages.isNotEmpty) ...[
                  const _DayDivider(label: 'Today'),
                  const SizedBox(height: 12),
                ],
                for (final message in _messages)
                  _MessageBubble(
                    message: message,
                    theme: theme,
                  ),
                if (isTyping) const _TypingBubble(),
                const SizedBox(height: 120),
              ],
            );
          }),
        ),
        _MessageComposer(
          controller: _textController,
          onSend: _handleSend,
        ),
      ],
    );
  }

  Widget _buildVoiceMode(ThemeData theme) {
    return Obx(() {
      final speechEnabled = _chatController.speechEnabled.value;
      final isListening = _chatController.isListening.value;
      final lastWords = _chatController.lastWords.value.trim();
      final isProcessing = _chatController.processing.value;
      final isInitializing = _chatController.loading.value;

      if (!isListening && !isProcessing) {
        return _VoiceIdleView(
          onTap: _handleVoiceStart,
          microphoneReady: speechEnabled,
          initializing: isInitializing,
          isProcessing: isProcessing,
        );
      }

      return _VoiceRecordingView(
        transcript: lastWords.isEmpty ? 'Listening...' : lastWords,
        elapsed: _recordingElapsed,
        onCancel: _handleVoiceCancel,
        onConfirm: _handleVoiceConfirm,
        isProcessing: isProcessing,
        microphoneReady: speechEnabled,
        initializing: isInitializing,
      );
    });
  }
}

enum ChatMode { text, voice }

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.onChanged,
  });

  final ChatMode mode;
  final ValueChanged<ChatMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Text Chat',
            isActive: mode == ChatMode.text,
            icon: Icons.chat_bubble_outline,
            onTap: () => onChanged(ChatMode.text),
          ),
          _ModeButton(
            label: 'Voice Chat',
            isActive: mode == ChatMode.voice,
            icon: Icons.mic_none,
            onTap: () => onChanged(ChatMode.voice),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? FreudColors.richBrown : Colors.transparent,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : FreudColors.richBrown,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : FreudColors.richBrown,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LimitedKnowledgeBanner extends StatelessWidget {
  const _LimitedKnowledgeBanner({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E8),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEEDD8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.psychology_alt_outlined,
                  size: 40,
                  color: FreudColors.cocoa,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  'Limited Knowledge',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text(
                  'Limitations',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'No human being is perfect. So are chatbots. Neptune’s knowledge is limited to 2025.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: FreudColors.textDark.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.theme,
  });

  final _ChatMessage message;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = message.isUser ? FreudColors.richBrown : const Color(0xFFFFF2DF);
    final textColor = message.isUser ? FreudColors.textLight : FreudColors.textDark;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(28),
      topRight: const Radius.circular(28),
      bottomLeft: Radius.circular(message.isUser ? 28 : 6),
      bottomRight: Radius.circular(message.isUser ? 6 : 28),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (message.tag != null)
            _EmotionChip(
              tag: message.tag!,
              alignEnd: message.isUser,
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: textColor,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            TimeOfDay.fromDateTime(message.timestamp).format(context),
            style: theme.textTheme.bodySmall?.copyWith(
              color: FreudColors.textDark.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  const _EmotionChip({required this.tag, required this.alignEnd});

  final _EmotionTag tag;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: tag.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tag.icon, color: tag.textColor, size: 16),
            const SizedBox(width: 8),
            Text(
              tag.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: tag.textColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2DF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(),
            SizedBox(width: 6),
            _Dot(delay: Duration(milliseconds: 120)),
            SizedBox(width: 6),
            _Dot(delay: Duration(milliseconds: 240)),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({this.delay = Duration.zero});

  final Duration delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            widget.delay.inMilliseconds / 700,
            1,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: const CircleAvatar(radius: 4, backgroundColor: FreudColors.cocoa),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FreudColors.cream,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type to start chatting...',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: FreudColors.richBrown,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceIdleView extends StatelessWidget {
  const _VoiceIdleView({
    required this.onTap,
    required this.microphoneReady,
    required this.initializing,
    required this.isProcessing,
  });

  final VoidCallback onTap;
  final bool microphoneReady;
  final bool initializing;
  final bool isProcessing;

  bool get _isEnabled => microphoneReady && !initializing && !isProcessing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = initializing
        ? 'Initializing microphone…'
        : !microphoneReady
            ? 'Microphone permission needed'
            : 'Ready to listen';
    final subtitle = initializing
        ? 'Give me a second to get the mic warmed up.'
        : !microphoneReady
            ? 'Enable microphone access in your browser settings.'
            : 'Tap the mic to share whatever’s on your mind.';

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scale = (height / 720).clamp(0.75, 1.0);

        double scaled(double base, {double? min}) {
          final value = base * scale;
          if (min != null) {
            return math.max(value, min);
          }
          return value;
        }

        final double avatarBase =
            math.min(math.max(width * 0.62, 160), 260).toDouble();
        final double haloBase =
            avatarBase + math.min(math.max(width * 0.18, 28), 72).toDouble();
        final double outerRingBase =
            haloBase + math.min(math.max(width * 0.14, 24), 56).toDouble();
        final double micOuterBase =
            math.min(math.max(width * 0.48, 120), 174).toDouble();

        final double avatarSize = scaled(avatarBase, min: 140);
        final double haloSize = scaled(haloBase, min: avatarSize + 24);
        final double outerRing = scaled(outerRingBase, min: haloSize + 24);
        final double micOuter = scaled(micOuterBase, min: 110);
        final double micInner = micOuter * 0.78;
        final double topSpacing = scaled(math.max(width * 0.04, 12.0));
        final double bodySpacing = scaled(math.max(width * 0.06, 18.0));

        final padding = EdgeInsets.fromLTRB(24, topSpacing, 24, bodySpacing);

        return ListView(
          padding: padding,
          physics: const BouncingScrollPhysics(),
          children: [
              _StatusBadge(
                icon: microphoneReady ? Icons.mic_none : Icons.mic_off,
                label: statusLabel,
                background: Colors.white,
                foreground: FreudColors.richBrown,
              ),
              SizedBox(height: bodySpacing * 0.8),
              SizedBox(
                height: outerRing + 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: const Alignment(-0.85, -0.8),
                      child: Container(
                        width: outerRing * 0.45,
                        height: outerRing * 0.45,
                        decoration: BoxDecoration(
                          color: FreudColors.sunshine.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.9, 0.95),
                      child: Container(
                        width: outerRing * 0.55,
                        height: outerRing * 0.55,
                        decoration: BoxDecoration(
                          color: FreudColors.burntOrange.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      width: outerRing,
                      height: outerRing,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: FreudColors.richBrown.withValues(alpha: 0.1),
                          width: 1.6,
                        ),
                      ),
                    ),
                    Container(
                      width: haloSize,
                      height: haloSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            FreudColors.sunshine.withValues(alpha: 0.14),
                            FreudColors.richBrown.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: FreudColors.richBrown.withValues(alpha: 0.1),
                            blurRadius: 32,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(avatarSize * 0.14),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset('assets/robot.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: bodySpacing),
              Text(
                'Say anything that’s on your mind.',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: math.min(24, width * 0.085),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: bodySpacing * 0.5),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: FreudColors.textDark.withValues(alpha: 0.68),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: bodySpacing * 1.2),
              Opacity(
                opacity: _isEnabled ? 1 : 0.45,
                child: GestureDetector(
                  onTap: _isEnabled ? onTap : null,
                  child: SizedBox(
                    height: micOuter,
                    width: micOuter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: micOuter,
                          height: micOuter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                FreudColors.richBrown.withValues(alpha: 0.08),
                          ),
                        ),
                        Container(
                          width: micInner,
                          height: micInner,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [FreudColors.richBrown, FreudColors.cocoa],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    FreudColors.richBrown.withValues(alpha: 0.22),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mic,
                            size: micInner * 0.38,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: bodySpacing * 0.6),
              Text(
                _isEnabled
                    ? 'Tap to start talking'
                    : !microphoneReady
                        ? 'Microphone access is required'
                        : initializing
                            ? 'Warming up the microphone'
                            : 'Processing previous request…',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: FreudColors.textDark.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: bodySpacing),
              _VoiceTips(availableWidth: width),
            ],
        );
      },
    );
  }
}

class _VoiceRecordingView extends StatelessWidget {
  const _VoiceRecordingView({
    required this.transcript,
    required this.elapsed,
    required this.onCancel,
    required this.onConfirm,
    required this.isProcessing,
    required this.microphoneReady,
    required this.initializing,
  });

  final String transcript;
  final Duration elapsed;
  final VoidCallback onCancel;
  final Future<void> Function() onConfirm;
  final bool isProcessing;
  final bool microphoneReady;
  final bool initializing;

  String get _timeLabel {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '00:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusLabel = isProcessing
        ? 'Processing response'
        : initializing
            ? 'Preparing microphone…'
            : microphoneReady
                ? 'Listening…'
                : 'Microphone unavailable';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        children: [
          _StatusBadge(
            icon: isProcessing ? Icons.auto_awesome : Icons.graphic_eq,
            label: statusLabel,
            background: Colors.white,
            foreground: FreudColors.richBrown,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          FreudColors.sunshine.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: FreudColors.richBrown.withValues(alpha: 0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFBE6D8),
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: FreudColors.richBrown,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isProcessing ? 'Transcribing' : 'Listening…',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: FreudColors.richBrown,
                            ),
                          ),
                          const Spacer(),
                          _StatusBadge(
                            icon: Icons.timer_outlined,
                            label: _timeLabel,
                            background: FreudColors.richBrown.withValues(alpha: 0.08),
                            foreground: FreudColors.richBrown,
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: FreudColors.richBrown.withValues(alpha: 0.08),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: transcript.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.graphic_eq,
                                      color: FreudColors.richBrown.withValues(alpha: 0.6),
                                      size: 40,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Speak naturally — I’ll take care of the rest.',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: FreudColors.textDark.withValues(alpha: 0.6),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : SingleChildScrollView(
                                  child: Text(
                                    transcript,
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      fontSize: 20,
                                      height: 1.58,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (isProcessing)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: LinearProgressIndicator(
                            color: FreudColors.richBrown,
                            backgroundColor: Colors.transparent,
                            minHeight: 4,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _VoiceActionButton(
                            icon: Icons.close,
                            background: const Color(0xFFFFECE5),
                            iconColor: FreudColors.cocoa,
                            onTap: onCancel,
                          ),
                          _VoiceActionButton(
                            icon: Icons.check,
                            background: const Color(0xFFDCF4D2),
                            iconColor: const Color(0xFF3F7D46),
                            onTap: onConfirm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: foreground.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _VoiceTips extends StatelessWidget {
  const _VoiceTips({required this.availableWidth});

  final double availableWidth;

  @override
  Widget build(BuildContext context) {
    final tipWidth = math.min(availableWidth * 0.9, MediaQuery.of(context).size.width * 0.85);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _VoiceTip(
          icon: Icons.noise_aware,
          label: 'Find a quiet spot for clearer transcripts',
          maxWidth: tipWidth,
        ),
        _VoiceTip(
          icon: Icons.auto_fix_normal,
          label: 'You can switch to text at any time',
          maxWidth: tipWidth,
        ),
      ],
    );
  }
}

class _VoiceTip extends StatelessWidget {
  const _VoiceTip({
    required this.icon,
    required this.label,
    required this.maxWidth,
  });

  final IconData icon;
  final String label;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxConstraint = math.min(maxWidth, screenWidth * 0.85);
    final double minConstraint = math.min(140.0, maxConstraint);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minConstraint,
        maxWidth: maxConstraint,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: FreudColors.richBrown.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: FreudColors.richBrown.withValues(alpha: 0.06),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: FreudColors.richBrown),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FreudColors.textDark.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceActionButton extends StatelessWidget {
  const _VoiceActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final FutureOr<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
        ),
        child: Icon(icon, color: iconColor, size: 32),
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: FreudColors.textDark.withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: FreudColors.textDark.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: FreudColors.textDark.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: FreudColors.richBrown, size: 20),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.tag,
    this.fromVoice = false,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
  final _EmotionTag? tag;
  final bool fromVoice;
}

class _EmotionTag {
  const _EmotionTag({
    required this.label,
    required this.background,
    required this.textColor,
    required this.icon,
  });

  final String label;
  final Color background;
  final Color textColor;
  final IconData icon;

  factory _EmotionTag.voiceCapture() {
    return const _EmotionTag(
      label: 'Voice note captured',
      background: Color(0xFFFFF2DF),
      textColor: FreudColors.cocoa,
      icon: Icons.graphic_eq,
    );
  }

  factory _EmotionTag.thinking() {
    return const _EmotionTag(
  label: 'Neptune is thinking...',
      background: Color(0xFFE8F1FF),
      textColor: Color(0xFF35507A),
      icon: Icons.auto_awesome,
    );
  }
}
