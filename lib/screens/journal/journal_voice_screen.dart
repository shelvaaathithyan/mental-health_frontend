import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'package:get/get.dart';
import '../../Controllers/journal_controller.dart';

class JournalVoiceScreen extends StatefulWidget {
  static const routeName = '/journal/voice';
  const JournalVoiceScreen({super.key});

  @override
  State<JournalVoiceScreen> createState() => _JournalVoiceScreenState();
}

class _JournalVoiceScreenState extends State<JournalVoiceScreen> {
  bool _recording = false;
  int _seconds = 0;
  Timer? _timer;

  void _toggleRecord() {
    setState(() {
      _recording = !_recording;
    });
    _timer?.cancel();
    if (_recording) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int s) {
    final m = s ~/ 60;
    final ss = s % 60;
    return '${m.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: FreudColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: FreudColors.richBrown),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text('Voice Journal', style: theme.textTheme.displaySmall),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: FreudColors.richBrown.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: FreudColors.richBrown.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _format(_seconds),
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: FreudColors.richBrown,
                              fontSize: 48,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _recording ? 'Recording...' : 'Ready to record',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: FreudColors.richBrown.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _seconds > 0
                                ? () {
                                    Get.find<JournalController>().addVoice(
                                      date: DateTime.now(),
                                      durationSec: _seconds,
                                      publish: false,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Voice draft saved')),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _recording
                                ? _toggleRecord
                                : () {
                                    if (_seconds == 0) {
                                      // start recording
                                      _toggleRecord();
                                    } else {
                                      // publish current recording
                                      Get.find<JournalController>().addVoice(
                                        date: DateTime.now(),
                                        durationSec: _seconds,
                                        publish: true,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Voice journal published')),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                            icon: Icon(_recording ? Icons.pause : (_seconds == 0 ? Icons.mic : Icons.check)),
                            label: Text(_recording ? 'Pause' : (_seconds == 0 ? 'Record' : 'Publish')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
