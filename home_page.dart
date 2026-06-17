import 'package:flutter/material.dart';
import 'package:junto/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFilters = false;
  bool showNotifications = false;
  String selectedPersonality = "";

  // ── People list ──────────────────────────────────────────────────────────
  final List<Map<String, String>> users = [
    {
      "image": "assets/images/fatima.png",
      "name": "Fatima",
      "age": "20",
      "personality": "Ambivert",
      "location": "Eindhoven",
      "interest1": "Sports",
      "interest2": "Culinary",
    },
    {
      "image": "assets/images/andrew.png",
      "name": "Andrew",
      "age": "20",
      "personality": "Introvert",
      "location": "Eindhoven",
      "interest1": "Gaming",
      "interest2": "Sports",
    },
    {
      "image": "assets/images/paul.png",
      "name": "Paul",
      "age": "22",
      "personality": "Extrovert",
      "location": "Eindhoven",
      "interest1": "Culinary",
      "interest2": "Gaming",
    },
    {
      "image": "assets/images/rita.png",
      "name": "Rita",
      "age": "23",
      "personality": "Ambivert",
      "location": "Eindhoven",
      "interest1": "Outdoors",
      "interest2": "Culinary",
    },
    {
      "image": "assets/images/sofia.png",
      "name": "Sofia",
      "age": "26",
      "personality": "Extrovert",
      "location": "Eindhoven",
      "interest1": "Gaming",
      "interest2": "Arts&Culture",
    },
  ];

  // ── Notification items ────────────────────────────────────────────────────
  final List<Map<String, String>> notifications = [
    {"image": "assets/images/jason.png", "name": "Jason", "age": "25"},
    {"image": "assets/images/tina.png", "name": "Tina", "age": "27"},
  ];

  // ── Filtered users based on selected personality ──────────────────────────
  List<Map<String, String>> get filteredUsers {
    if (selectedPersonality.isEmpty) return users;
    return users.where((user) {
      return user["personality"] == selectedPersonality;
    }).toList();
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
                                    // Close filters if open
                                    if (showNotifications) {
                                      showFilters = false;
                                    }
                                  });
                                },
                              ),
                              // Red badge dot
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
                                // Close notifications if open
                                if (showFilters) {
                                  showNotifications = false;
                                }
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

                // s list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredUsers.length + 1,
                    itemBuilder: (context, index) {
                      // Last item = View More button
                      if (index == filteredUsers.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {},
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

                      // Person card
                      final user = filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: personCard(
                          image: user["image"]!,
                          name: user["name"]!,
                          age: user["age"]!,
                          personality: user["personality"]!,
                          location: user["location"]!,
                          interest1: user["interest1"]!,
                          interest2: user["interest2"]!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Notification modal overlay ───────────────────────────────────
          if (showNotifications) ...[
            // Dark dimmed background — tapping it closes the modal
            GestureDetector(
              onTap: () {
                setState(() {
                  showNotifications = false;
                });
              },
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: notifications.map((person) {
                      return notificationItem(
                        image: person["image"]!,
                        name: person["name"]!,
                        age: person["age"]!,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),

      // ── Bottom navigation bar ─────────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  // ── Notification item row ─────────────────────────────────────────────────
  Widget notificationItem({
    required String image,
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
          // Profile picture
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),

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

          // View Profile button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6A68),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "View Profile",
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
                onTap: () {
                  setState(() {
                    selectedPersonality = "";
                  });
                },
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
    bool isSelected = selectedPersonality == personality;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPersonality = selectedPersonality == personality
              ? ""
              : personality;
        });
      },
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
  Widget personCard({
    required String image,
    required String name,
    required String age,
    required String personality,
    required String location,
    required String interest1,
    required String interest2,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileViewPage(profileImages: [image]),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(image),
                ),
              ),

              const SizedBox(width: 30),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 20),
                    Text(age, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 20),
                    Text(personality, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 20),
                    Text(location, style: const TextStyle(fontSize: 22)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [interestButton(interest1), interestButton(interest2)],
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
