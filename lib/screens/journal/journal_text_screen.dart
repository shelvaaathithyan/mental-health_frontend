import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'package:get/get.dart';
import '../../Controllers/journal_controller.dart';

class JournalTextScreen extends StatefulWidget {
  static const routeName = '/journal/text';
  const JournalTextScreen({super.key});

  @override
  State<JournalTextScreen> createState() => _JournalTextScreenState();
}

class _JournalTextScreenState extends State<JournalTextScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  Text('Text Journal', style: theme.textTheme.displaySmall),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How are you feeling today?',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: FreudColors.richBrown,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: FreudColors.richBrown.withValues(alpha: 0.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: FreudColors.richBrown.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Write your thoughts...\n\nPrompt ideas: gratitude, worries, wins, plans',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: FreudColors.textDark.withValues(alpha: 0.35),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _controller.text.trim().isNotEmpty
                                ? () {
                                    Get.find<JournalController>().addText(
                                      date: DateTime.now(),
                                      content: _controller.text.trim(),
                                      publish: false,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Draft saved')),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Save Draft'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _controller.text.trim().isNotEmpty
                                ? () {
                                    Get.find<JournalController>().addText(
                                      date: DateTime.now(),
                                      content: _controller.text.trim(),
                                      publish: true,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Journal published')),
                                    );
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            icon: const Icon(Icons.check),
                            label: const Text('Publish'),
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
