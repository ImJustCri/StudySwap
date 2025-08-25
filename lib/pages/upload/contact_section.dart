import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/contact_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/traslation_manager.dart';

class ContactSection extends ConsumerWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider).value!.uid;
    final contactAsyncValue = ref.watch(contactProvider(userId));

    return contactAsyncValue.when(
      data: (contact) {
        final platform = contact?["platform"] ?? '';
        final handle = contact?["handle"] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              // Use your translation method accordingly
              Translation.of(context)!.translate("uploadContact.title"),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(platform),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      handle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Translation.of(context)!.translate("uploadContact.hint"),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
