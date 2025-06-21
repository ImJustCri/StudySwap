import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final email = FirebaseAuth.instance.currentUser?.email;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<Map<String, dynamic>?> findUserProfile() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(email).get();
      final data = doc.data()!;
      final username=data['username'];
      final bio=data['aboutme'];
      _nameController.text=username;
      _bioController.text=bio;
    } catch (e) {
      return null;
    }
    return null;
  }
  

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    findUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [

            // Profile Picture
            GestureDetector(
              onTap: () {
                // TODO: Implement profile picture change
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primary.withAlpha(25),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                hintText: 'Enter your new username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
                hintText: 'Tell us about yourself',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  final nameT = _nameController.text;
                  if(nameT.isNotEmpty){
                    if(nameT.length<20){
                      try{
                       FirebaseFirestore.instance.collection('Users').doc(email).update({
                         // Removes spaces and sets every letter to lowercase
                        'username': nameT.split(" ").join(".").toLowerCase(),
                        'aboutme': _bioController.text,
                      });
                      showDialog(context: context,
                       builder: (context)=> AlertDialog(
                        title: const Text("Profile updated"),
                        content: Text("Your profile has been updated successfully"),
                        actions: [
                          TextButton(onPressed: ()=>Navigator.pushReplacementNamed(context, '/homescreen'), child: const Text("Back to home"))
                        ],
                       )
                       );
                      } on FirebaseAuthException catch(ex){
                        showDialog(context: context,
                         builder: (context)=>AlertDialog(
                          title: const Text("Error"),
                          content: Text("Something went wrong. Please try again later"),
                          actions: [
                            TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("OK"))
                          ],
                         )
                        );
                      }
                      }else{
                      showDialog(context: context, 
                      builder: (context)=>AlertDialog(
                        title: const Text("Error"),
                        content: Text("The username cannot exceed 20 characters."),
                        actions: [
                          TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("OK"))
                        ],
                      )
                      );
                  }      
                  }else{
                    showDialog(context: context,
                     builder: (context)=>AlertDialog(
                      title: const Text("Error"),
                      content: Text("A username is required to save the changes."),
                      actions: [
                        TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("OK"))
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
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
