import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class PassRecovery extends StatelessWidget {
  const PassRecovery({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = TextEditingController();
    final auth = Auth(); // Creates Auth Object

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translation.of(context)!.translate("recoveryPassword.title"),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 104),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: Translation.of(context)!.translate("boxEmail"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final emailT = email.text.trim();
                          if (emailT.isNotEmpty) {
                            if (!emailT.endsWith('.edu.it')) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(Translation.of(context)!.translate("invalidEmail")),
                                  content: Text(Translation.of(context)!.translate("recoveryPassword.invalidEmailbody")),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK")
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              await auth.resetPassword(emailT);
                              Navigator.pushNamed(context, "/login"); // a
                              return;
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:  Text(Translation.of(context)!.translate("titleError")),
                                content:  Text(Translation.of(context)!.translate("recoveryPassword.emailEmptybody")),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK")
                                  ),
                                ],
                              )
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(Translation.of(context)!.translate("recoveryPassword.button")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}