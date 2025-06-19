import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Auth(); // Creates Auth Object
    final email=TextEditingController();
    final password=TextEditingController();
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
                        "Look who's back!",
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
                      Row(
                        children: [
                          Switch(
                            value: false,
                            onChanged: (_) {
                              // TODO: Implement "remember me"
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot your password?',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
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
                          onPressed: () async{
                            final emailT=email.text.trim();
                            final passwordT=password.text.trim();
                            if(emailT.isNotEmpty && passwordT.isNotEmpty){
                              final error= await auth.login(emailT, passwordT);
                              if(error != null){
                              showDialog(
                                context: context,
                                builder: (context)=> 
                                AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(error),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), 
                                    child: const Text("OK")),
                                  ],
                                ),
                                );
                            }else{
                              Navigator.pushReplacementNamed(context, '/homescreen');
                            }
                            }else{
                              showDialog(
                                context: context, 
                                builder: (context) => AlertDialog(
                                  title: const Text("Error"),
                                  content: Text("Enter a valid email o password before continuing"),
                                  actions: [
                                    TextButton(onPressed: ()=> Navigator.pop(context), 
                                    child: const Text("OK")),
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
                          child: const Text('Log In'),
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
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text(
                  "Don’t have an account?",
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
