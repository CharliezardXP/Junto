import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFilters = false;
  bool showNotifications = false;

  // Active filter tab
  String activeFilter = "";

  // Selected values (multiple selection)
  List<String> selectedPersonalities = [];
  List<String> selectedAges = [];
  List<String> selectedHobbies = [];
  List<String> selectedSchools = [];

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
      "school": "Fontys",
    },
    {
      "image": "assets/images/andrew.png",
      "name": "Andrew",
      "age": "20",
      "personality": "Introvert",
      "location": "Eindhoven",
      "interest1": "Gaming",
      "interest2": "Sports",
      "school": "TU/e",
    },
    {
      "image": "assets/images/paul.png",
      "name": "Paul",
      "age": "22",
      "personality": "Extrovert",
      "location": "Eindhoven",
      "interest1": "Culinary",
      "interest2": "Gaming",
      "school": "Fontys",
    },
    {
      "image": "assets/images/rita.png",
      "name": "Rita",
      "age": "23",
      "personality": "Ambivert",
      "location": "Eindhoven",
      "interest1": "Outdoors",
      "interest2": "Culinary",
      "school": "Avans",
    },
    {
      "image": "assets/images/sofia.png",
      "name": "Sofia",
      "age": "26",
      "personality": "Extrovert",
      "location": "Eindhoven",
      "interest1": "Gaming",
      "interest2": "Arts&Culture",
      "school": "HAN",
    },
  ];

  // ── Notification items ────────────────────────────────────────────────────
  final List<Map<String, String>> notifications = [
    {"image": "assets/images/jason.png", "name": "Jason", "age": "25"},
    {"image": "assets/images/tina.png", "name": "Tina", "age": "27"},
  ];

  // ── Filter options ────────────────────────────────────────────────────────
  final List<String> personalities = ["Extrovert", "Ambivert", "Introvert"];
  final List<String> ages = ["18-20", "21-23", "24-26", "27+"];
  final List<String> hobbies = ["Sports", "Arts&Culture", "Culinary", "Gaming", "Outdoors"];
  final List<String> schools = ["Fontys", "TU/e", "Avans", "HAN", "Other"];

  // ── Check if any filters are active ──────────────────────────────────────
  bool get hasActiveFilters =>
      selectedPersonalities.isNotEmpty ||
      selectedAges.isNotEmpty ||
      selectedHobbies.isNotEmpty ||
      selectedSchools.isNotEmpty;

  // ── All active filter labels for display ──────────────────────────────────
  List<Map<String, String>> get activeFilterChips {
    List<Map<String, String>> chips = [];
    for (var p in selectedPersonalities) chips.add({"label": p, "type": "personality"});
    for (var a in selectedAges) chips.add({"label": a, "type": "age"});
    for (var h in selectedHobbies) chips.add({"label": h, "type": "hobby"});
    for (var s in selectedSchools) chips.add({"label": s, "type": "school"});
    return chips;
  }

  // ── Filtered users ────────────────────────────────────────────────────────
  List<Map<String, String>> get filteredUsers {
    return users.where((user) {
      if (selectedPersonalities.isNotEmpty &&
          !selectedPersonalities.contains(user["personality"])) return false;

      if (selectedAges.isNotEmpty) {
        final age = int.tryParse(user["age"] ?? "0") ?? 0;
        bool matchesAge = false;
        for (var range in selectedAges) {
          if (range == "18-20" && age >= 18 && age <= 20) matchesAge = true;
          if (range == "21-23" && age >= 21 && age <= 23) matchesAge = true;
          if (range == "24-26" && age >= 24 && age <= 26) matchesAge = true;
          if (range == "27+" && age >= 27) matchesAge = true;
        }
        if (!matchesAge) return false;
      }

      if (selectedHobbies.isNotEmpty &&
          !selectedHobbies.contains(user["interest1"]) &&
          !selectedHobbies.contains(user["interest2"])) return false;

      if (selectedSchools.isNotEmpty &&
          !selectedSchools.contains(user["school"])) return false;

      return true;
    }).toList();
  }

  void _removeFilter(Map<String, String> chip) {
    setState(() {
      if (chip["type"] == "personality") selectedPersonalities.remove(chip["label"]);
      if (chip["type"] == "age") selectedAges.remove(chip["label"]);
      if (chip["type"] == "hobby") selectedHobbies.remove(chip["label"]);
      if (chip["type"] == "school") selectedSchools.remove(chip["label"]);
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFEF),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_none,
                                  size: 30,
                                  color: showNotifications ? Colors.teal : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showNotifications = !showNotifications;
                                    if (showNotifications) showFilters = false;
                                  });
                                },
                              ),
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
                                if (!showFilters) activeFilter = "";
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filter panel
                if (showFilters) buildFilterPanel(),

                // Active filter chips shown below
                if (hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Active filters:",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: activeFilterChips.map((chip) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    chip["label"]!,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _removeFilter(chip),
                                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                // Person cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredUsers.length + 1,
                    itemBuilder: (context, index) {
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
                              style: TextStyle(fontSize: 26, color: Colors.white),
                            ),
                          ),
                        );
                      }
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

          // Notification modal
          if (showNotifications) ...[
            GestureDetector(
              onTap: () => setState(() => showNotifications = false),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
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

  // ── Filter panel ──────────────────────────────────────────────────────────
  Widget buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              filterButton(
                title: "All",
                selected: !hasActiveFilters && activeFilter.isEmpty,
                onTap: () {
                  setState(() {
                    activeFilter = "";
                    selectedPersonalities = [];
                    selectedAges = [];
                    selectedHobbies = [];
                    selectedSchools = [];
                  });
                },
              ),
              filterButton(
                title: "Age",
                selected: activeFilter == "Age",
                onTap: () => setState(() {
                  activeFilter = activeFilter == "Age" ? "" : "Age";
                }),
              ),
              filterButton(
                title: "Hobbies",
                selected: activeFilter == "Hobbies",
                onTap: () => setState(() {
                  activeFilter = activeFilter == "Hobbies" ? "" : "Hobbies";
                }),
              ),
              filterButton(
                title: "School",
                selected: activeFilter == "School",
                onTap: () => setState(() {
                  activeFilter = activeFilter == "School" ? "" : "School";
                }),
              ),
              filterButton(
                title: "Personality",
                selected: activeFilter == "Personality",
                onTap: () => setState(() {
                  activeFilter = activeFilter == "Personality" ? "" : "Personality";
                }),
              ),
            ],
          ),

          if (activeFilter == "Personality") ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: personalities.map((p) => optionButton(
                title: p,
                selected: selectedPersonalities.contains(p),
                onTap: () => setState(() {
                  selectedPersonalities.contains(p)
                      ? selectedPersonalities.remove(p)
                      : selectedPersonalities.add(p);
                }),
              )).toList(),
            ),
          ],

          if (activeFilter == "Age") ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ages.map((a) => optionButton(
                title: a,
                selected: selectedAges.contains(a),
                onTap: () => setState(() {
                  selectedAges.contains(a)
                      ? selectedAges.remove(a)
                      : selectedAges.add(a);
                }),
              )).toList(),
            ),
          ],

          if (activeFilter == "Hobbies") ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hobbies.map((h) => optionButton(
                title: h,
                selected: selectedHobbies.contains(h),
                onTap: () => setState(() {
                  selectedHobbies.contains(h)
                      ? selectedHobbies.remove(h)
                      : selectedHobbies.add(h);
                }),
              )).toList(),
            ),
          ],

          if (activeFilter == "School") ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: schools.map((s) => optionButton(
                title: s,
                selected: selectedSchools.contains(s),
                onTap: () => setState(() {
                  selectedSchools.contains(s)
                      ? selectedSchools.remove(s)
                      : selectedSchools.add(s);
                }),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Filter chip button ────────────────────────────────────────────────────
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

  // ── Option button ─────────────────────────────────────────────────────────
  Widget optionButton({
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

  // ── Notification item ─────────────────────────────────────────────────────
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
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(age, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6A68),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("View Profile", style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 45, backgroundImage: AssetImage(image)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(age, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(personality, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(location, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: interestButton(interest1)),
              const SizedBox(width: 10),
              Expanded(child: interestButton(interest2)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Interest tag ──────────────────────────────────────────────────────────
  Widget interestButton(String title) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(color: Color(0xFF39A6A3)),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}