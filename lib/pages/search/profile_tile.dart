import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../profile/profile_page.dart';

class ProfileTile extends StatelessWidget {
  final String userId;
  final String pfp;
  final String username;
  final String school;

  const ProfileTile({
    super.key,
    required this.userId,
    required this.pfp,
    required this.username,
    required this.school,
  });

  void _handleTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage(userId: userId)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(pfp),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "@$school",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
