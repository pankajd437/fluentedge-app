import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:go_router/go_router.dart';

class FriendDetailPage extends StatelessWidget {
  final String friendName;
  final String avatarEmoji;
  final int xp;
  final List<Map<String, dynamic>> badges;

  const FriendDetailPage({
    Key? key,
    required this.friendName,
    required this.avatarEmoji,
    required this.xp,
    required this.badges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        title: Text("👥 $friendName"),
        backgroundColor: kPrimaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 👤 Avatar + Name + XP
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(avatarEmoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    friendName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryIconBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "XP: $xp",
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: kAccentGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🏅 Friend's Badges
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🏅 Unlocked Badges",
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryIconBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),

            badges.isEmpty
                ? const Text("No badges yet.", style: TextStyle(color: Colors.grey))
                : Expanded(
                    child: GridView.builder(
                      itemCount: badges.length,
                      padding: const EdgeInsets.only(top: 4),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: kAccentGreen.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                badge['animation'],
                                height: 60,
                                repeat: true,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                badge['title'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
