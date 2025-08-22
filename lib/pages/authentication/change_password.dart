import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';
import 'package:studyswap/providers/traslation_provider.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final auth = Auth();

  // Flags for password requirements
  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  @override
  void initState() {
    super.initState();

    newPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = newPasswordController.text;

    // Requirement conditions
    setState(() {
      hasMinLength = password.length >= 9;
      hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      hasNumber = password.contains(RegExp(r'\d'));
      hasSpecialChar = password.contains(RegExp(r'[^a-zA-Z0-9]'));
    });
  }

  Widget _buildGuidelineItem(String text, bool isValid) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel_outlined,
            size: 20,
            color: isValid ? theme.colorScheme.primary : theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isValid
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidPassword(String password) {
    return hasMinLength && hasUpperCase && hasNumber && hasSpecialChar;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // You can remove or change this to true for better keyboard handling.
      resizeToAvoidBottomInset: true,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 48,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translation.of(context)!.translate("changePassword.title"),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 104),
                      TextField(
                        controller: oldPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Translation.of(context)!.translate("changePassword.labelOld"),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Translation.of(context)!.translate("changePassword.labelNew"),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Translation.of(context)!.translate("changePassword.labelConfirm"),
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password requirements
                      Text(
                        Translation.of(context)!.translate("changePassword.passwordRequirements.title"),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildGuidelineItem(Translation.of(context)!.translate("changePassword.passwordRequirements.1"), hasMinLength),
                      _buildGuidelineItem(Translation.of(context)!.translate("changePassword.passwordRequirements.2"), hasUpperCase),
                      _buildGuidelineItem(Translation.of(context)!.translate("changePassword.passwordRequirements.3"), hasNumber),
                      _buildGuidelineItem(Translation.of(context)!.translate("changePassword.passwordRequirements.4"), hasSpecialChar),
                    ],
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final oldPassword = oldPasswordController.text.trim();
                        final newPassword = newPasswordController.text.trim();
                        final confirmPassword = confirmPasswordController.text.trim();

                        if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Translation.of(context)!.translate("changePassword.titleError")),
                              content: Text(Translation.of(context)!.translate("changePassword.errors.Empty")),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        if (newPassword != confirmPassword) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Translation.of(context)!.translate("changePassword.titleError")),
                              content: Text(Translation.of(context)!.translate("changePassword.errors.DifferentPassword")),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        if (!isValidPassword(newPassword)) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Translation.of(context)!.translate("changePassword.errors.NoRespecttitle")),
                              content:  Text(Translation.of(context)!.translate("changePassword.errors.NoRespectbody")),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        try {
                          await auth.changePassword(oldPassword, newPassword);
                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:  Text(Translation.of(context)!.translate("changePassword.errors.oldPasswordtitle")),
                              content: Text(
                                  Translation.of(context)!.translate("changePassword.errors.oldPasswordbody")),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
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
                      child: Text(Translation.of(context)!.translate("changePassword.button")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
