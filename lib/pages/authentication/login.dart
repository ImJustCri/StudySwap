import 'package:flutter/material.dart';
import 'package:studyswap/auth.dart';
import 'package:studyswap/services/traslation_manager.dart';
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
                        Translation.of(context)!.translate("login.title"),
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
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Translation.of(context)!.translate("boxPassword"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/password-recovery');
                        },
                        child: Text(
                          Translation.of(context)!.translate("login.buttonToRecovery"),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.underline,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
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
                                  title: Text(Translation.of(context)!.translate("titleError")),
                                  content: Text(error),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), 
                                    child: const Text("OK")),
                                  ],
                                ),
                                );
                            }else{
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/homescreen');
                            }
                            }else{
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(Translation.of(context)!.translate("titleError")),
                                  content: Text(Translation.of(context)!.translate("login.body")),
                                  actions: [
                                    TextButton(onPressed: ()=> Navigator.pop(context), 
                                    child: const Text("OK")),
                                  ],
                                ),
                                );
                            }
                          },
                          child: Text(Translation.of(context)!.translate("login.buttonToLog")),
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
                  Translation.of(context)!.translate("login.buttonToRegister"),
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
