import 'package:flutter/material.dart';
import 'package:studyswap/services/traslation_manager.dart';
class ContactInput extends StatefulWidget {
  final String? initialPlatform;
  final String? initialHandle;
  final void Function(String platform, String handle) onChanged;

  const ContactInput({
    super.key,
    this.initialPlatform,
    this.initialHandle,
    required this.onChanged,
  });

  @override
  State<ContactInput> createState() => _ContactInputState();
}

class _ContactInputState extends State<ContactInput> {
  final List<String> _platforms = ['Telegram', 'Discord', 'Signal', 'Threema'];

  late String _selectedPlatform;
  late TextEditingController _handleController;

  @override
  void initState() {
    super.initState();
    _selectedPlatform = _platforms.contains(widget.initialPlatform)
        ? widget.initialPlatform!
        : 'Telegram';
    _handleController = TextEditingController(text: widget.initialHandle ?? '');

    _handleController.addListener(() {
      widget.onChanged(_selectedPlatform, _handleController.text.trim());
    });
  }

  @override
  void dispose() {
    _handleController.dispose();
    super.dispose();
  }

  void _onPlatformChanged(String? newPlatform) {
    if (newPlatform != null) {
      setState(() {
        _selectedPlatform = newPlatform;
      });
      widget.onChanged(_selectedPlatform, _handleController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getPlatformIcon(String platform) {
      switch (platform.toLowerCase()) {
        case 'telegram':
          return const Icon(Icons.send, color: Colors.blue);
        case 'discord':
          return const Icon(Icons.chat_bubble_outline, color: Colors.indigo);
        case 'signal':
          return const Icon(Icons.signal_cellular_alt, color: Colors.lightBlue);
        case 'threema':
          return const Icon(Icons.lock, color: Colors.green);
        default:
          return const Icon(Icons.person);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: _selectedPlatform,
            isExpanded: true,
            underline: Container(),
            items: _platforms
                .map((platform) => DropdownMenuItem(
              value: platform,
              child: Row(
                children: [
                  getPlatformIcon(platform),
                  const SizedBox(width: 8),
                  Text(platform),
                ],
              ),
            ))
                .toList(),
            onChanged: _onPlatformChanged,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _handleController,
          decoration: InputDecoration(
            labelText: Translation.of(context)!.translate("hanle"),
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.account_circle),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return Translation.of(context)!.translate("contactHandle");
            }
            return null;
          },
        ),
      ],
    );
  }
}
