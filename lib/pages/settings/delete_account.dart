import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';
import 'package:studyswap/services/traslation_manager.dart';

Future<void> showDeleteAccountDialog(BuildContext context) async {
  final auth = Auth();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Translation.of(context)!.translate("settings.titleDeleteA")),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Translation.of(context)!.translate("settings.bodyDeleteA")),
            SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: Translation.of(context)!.translate("settings.passwordLabel"),
                border: OutlineInputBorder(),
                errorStyle: const TextStyle(color: Colors.red),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Translation.of(context)!.translate("settings.enterPasswordMessage");
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(Translation.of(context)!.translate("settings.buttonCalcelA")),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              bool isDeleted = await auth.deleteAccount(passwordController.text);

              if (isDeleted && context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(Translation.of(context)!.translate("settings.MessageDeleteA"))),
                );
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(Translation.of(context)!.translate("settings.wrongPassword"))),
                );
              };
            }
          },
          child: Text(
            Translation.of(context)!.translate("settings.buttonDeleteA"),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
