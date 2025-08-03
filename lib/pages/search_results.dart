// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:studyswap/pages/profile/profile_page.dart';
//
// class SearchResults extends StatefulWidget {
//   const SearchResults({super.key});
//
//   @override
//   State<SearchResults> createState() => _SearchResultsState();
// }
//
// class _SearchResultsState extends State<SearchResults> {
//   String _searchText = "";
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               autofocus: true,
//               decoration: InputDecoration(
//                 hintText: "Search for notes or profiles",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//                 filled: true,
//                 fillColor: theme.colorScheme.surface,
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchText = value.trim();
//                 });
//               },
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Results",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: _searchText.isEmpty
//                   ? const Center()
//                   : StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('Users')
//                     .where('username', isGreaterThanOrEqualTo: _searchText)
//                     .where('username', isLessThanOrEqualTo: '$_searchText\uf8ff')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("Nessun profilo trovato"));
//                   }
//                   final docs = snapshot.data!.docs;
//                   return ListView.separated(
//                     itemCount: docs.length,
//                     separatorBuilder: (context, index) => const SizedBox(height: 8),
//                     itemBuilder: (context, index) {
//                       final User? userData = docs[index].data();
//                       return Material(
//                         borderRadius: BorderRadius.circular(16),
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProfilePage(
//                                   isMine: false,
//                                   user: userData,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   backgroundColor: Color((userData['color'] ?? 0xFF2196F3)).withAlpha(255),
//                                   child: Text(
//                                     (userData['username'] ?? "?")[0].toUpperCase(),
//                                     style: const TextStyle(color: Colors.white, fontSize: 20),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       userData['username'] ?? "",
//                                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       userData['school'],
//                                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
