import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agreeTerms = false;
  final auth = Auth();// Creates Auth object
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
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
                        "Welcome!",
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
                          hintText: 'Insert email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Insert password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: confirmPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirm password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                agreeTerms = value ?? false;
                              });
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree with '),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // TODO: Redirect to studyswap.it for terms and conditions
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: agreeTerms ? () async {
  			  final emailT = email.text.trim();
  			  final passwordT= password.text.trim();
  			  final confirmPasswordT = confirmPassword.text.trim();

  			  if (!emailT.endsWith('.edu.it')) {
    				showDialog(
      				context: context,
      				builder: (context) => AlertDialog(
        			title: const Text("Invalid email"),
        			content: const Text("You can register only with an institutional email"),
        				actions: [
          				TextButton(
            				onPressed: () => Navigator.pop(context),
            				child: const Text("OK"),
          				)
        				],
     					 ),
    					);
    					return;
  					}

  			if (passwordT != confirmPasswordT) {
    				showDialog(
      				context: context,
     				builder: (context) => AlertDialog(
        			title: const Text("Error"),
        			content: const Text("Incorrect password"),
        			actions: [
         		 	TextButton(
            			onPressed: () => Navigator.pop(context),
            			child: const Text("OK"),
          			)
        			],
      				),
    				);
    				return;
  				}

	  			
	  			final error = await auth.registerWithEmail(emailT, passwordT); // Calls method created in auth.dart
  				if (error != null) {
    					showDialog(
      					context: context,
      					builder: (context) => AlertDialog(
        				title: const Text("Error"),
        				content: Text(error),
        				actions: [
          				TextButton(
            				onPressed: () => Navigator.pop(context),
            				child: const Text("OK"),
          				)
        				],
      					),
   				 	);
    					return;
  					}
  				Navigator.pushNamed(context, '/mail-verification');
				} : null,
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
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  "Already have an account?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
