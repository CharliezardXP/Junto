import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/supabase_service.dart';

// ── Home Page ────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFilters = false;
  bool showNotifications = false;
  String selectedPersonality = "";
  bool isLoading = true;
  String? errorMessage;

  final _service = SupabaseService();

  // Real data from Supabase (replaces the old hardcoded lists)
  List<ProfileModel> users = [];
  List<Map<String, dynamic>> notifications = [];

  // The currently logged-in user (null if login not done yet)
  String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Fetch profiles and notifications from Supabase
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final profiles = await _service.getSuggestedProfiles(currentUserId);
      final notifs = currentUserId != null
          ? await _service.getPendingRequests(currentUserId!)
          : <Map<String, dynamic>>[];

      setState(() {
        users = profiles;
        notifications = notifs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Could not load profiles. Check your connection.';
      });
      debugPrint('Supabase error: $e');
    }
  }

  // ── Filtered users based on selected personality ──────────────────────────
  List<ProfileModel> get filteredUsers {
    if (selectedPersonality.isEmpty) return users;
    return users
        .where((u) => u.personalityType == selectedPersonality)
        .toList();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFEF),

      body: Stack(
        children: [
          // ── Main content ────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo avatar
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF1E6A68),
                        child: const Text(
                          "Junto.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Icon buttons
                      Row(
                        children: [
                          // Notification bell
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_none,
                                  size: 30,
                                  color: showNotifications
                                      ? Colors.teal
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showNotifications = !showNotifications;
                                    if (showNotifications) showFilters = false;
                                  });
                                },
                              ),
                              // Red badge — only shown when there are pending requests
                              if (notifications.isNotEmpty)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(width: 5),

                          // Filter icon
                          IconButton(
                            icon: Icon(
                              Icons.tune,
                              size: 30,
                              color: showFilters ? Colors.teal : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                showFilters = !showFilters;
                                if (showFilters) showNotifications = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filter panel (shown/hidden)
                if (showFilters) buildFilterPanel(),

                // Error message
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                // Loading spinner
                if (isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E6A68),
                      ),
                    ),
                  )
                // Empty state
                else if (filteredUsers.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No profiles found.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                // Person cards list
                else
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFF1E6A68),
                      onRefresh: _loadData, // pull down to refresh
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredUsers.length + 1,
                        itemBuilder: (context, index) {
                          // Last item = View More button
                          if (index == filteredUsers.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: ElevatedButton(
                                onPressed: _loadData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E6A68),
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                                child: const Text(
                                  "View More",
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }

                          // Person card from real Supabase data
                          final user = filteredUsers[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: personCard(user: user),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Notification modal overlay ───────────────────────────────────
          if (showNotifications) ...[
            // Dark background — tap to close
            GestureDetector(
              onTap: () => setState(() => showNotifications = false),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),

            // White modal panel
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: notifications.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'No new connection requests.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: notifications.map((notif) {
                            final profile =
                                (notif['profile'] as Map<String, dynamic>?) ??
                                {};
                            return notificationItem(
                              requestId: notif['connection_request_id'] ?? '',
                              senderId: notif['sender_id'] ?? '',
                              avatarUrl: profile['avatar_url'] as String?,
                              name:
                                  (profile['full_name'] as String?)
                                          ?.isNotEmpty ==
                                      true
                                  ? profile['full_name'] as String
                                  : (profile['username'] as String? ??
                                        'Unknown'),
                              age: profile['age']?.toString() ?? '?',
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Notification item row ─────────────────────────────────────────────────
  Widget notificationItem({
    required String requestId,
    required String senderId,
    String? avatarUrl,
    required String name,
    required String age,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Profile picture or initials fallback
          CircleAvatar(
            radius: 30,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl) as ImageProvider
                : null,
            backgroundColor: const Color(0xFF1E6A68),
            child: avatarUrl == null || avatarUrl.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                : null,
          ),

          const SizedBox(width: 16),

          // Name and age
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  age,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Accept button — creates match + chat in Supabase
          ElevatedButton(
            onPressed: currentUserId == null
                ? null
                : () async {
                    try {
                      await _service.acceptConnectionRequest(
                        requestId: requestId,
                        senderId: senderId,
                        receiverId: currentUserId!,
                      );
                      await _loadData(); // refresh notifications
                      setState(() => showNotifications = false);
                    } catch (e) {
                      debugPrint('Error accepting request: $e');
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6A68),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Accept",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter panel ──────────────────────────────────────────────────────────
  Widget buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              filterButton(
                title: "All",
                selected: selectedPersonality.isEmpty,
                onTap: () => setState(() => selectedPersonality = ""),
              ),
              filterButton(title: "Age", selected: false, onTap: () {}),
              filterButton(title: "Hobbies", selected: false, onTap: () {}),
              filterButton(title: "School", selected: false, onTap: () {}),
            ],
          ),

          const SizedBox(height: 20),

          filterButton(title: "Personality", selected: true, onTap: () {}),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              personalityButton("Extrovert"),
              personalityButton("Ambivert"),
              personalityButton("Introvert"),
            ],
          ),
        ],
      ),
    );
  }

  // ── Filter button ─────────────────────────────────────────────────────────
  Widget filterButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.white,
          border: Border.all(color: Colors.teal),
        ),
        child: Text(
          title,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // ── Personality toggle button ─────────────────────────────────────────────
  Widget personalityButton(String personality) {
    final isSelected = selectedPersonality == personality;
    return GestureDetector(
      onTap: () => setState(() {
        selectedPersonality = selectedPersonality == personality
            ? ""
            : personality;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.white,
          border: Border.all(color: Colors.teal),
        ),
        child: Text(
          personality,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // ── Person card ───────────────────────────────────────────────────────────
  Widget personCard({required ProfileModel user}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar — network image from Supabase Storage, or initials fallback
              CircleAvatar(
                radius: 75,
                backgroundImage:
                    user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? NetworkImage(user.avatarUrl!) as ImageProvider
                    : null,
                backgroundColor: const Color(0xFF1E6A68),
                child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                    ? Text(
                        user.avatarInitial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 30),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.age?.toString() ?? '?',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.personalityType ?? '',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.location ?? '',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Hobby tags from database
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (user.hobbies.isNotEmpty) interestButton(user.hobbies[0]),
              if (user.hobbies.length > 1) interestButton(user.hobbies[1]),
              if (user.hobbies.isEmpty) interestButton('No hobbies listed'),
            ],
          ),
        ],
      ),
    );
  }

  // ── Interest tag button ───────────────────────────────────────────────────
  Widget interestButton(String title) {
    return Container(
      width: 140,
      height: 40,
      decoration: const BoxDecoration(color: Color(0xFF39A6A3)),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
