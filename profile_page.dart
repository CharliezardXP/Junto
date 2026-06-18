import 'package:flutter/material.dart';

class ProfileViewPage extends StatefulWidget {
  final List<String> profileImages; // remember

  const ProfileViewPage({super.key, required this.profileImages});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  final List<String> profileImages = [
    'assets/images/fatima1.jpg',
    'assets/images/gina1.jpg',
    'assets/images/gina.jpg',
  ];

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          "Profile View",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 30),

                // Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE VIEWER
                      SizedBox(
                        height: 380,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: widget.profileImages.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                widget.profileImages[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Image Counter
                      Center(
                        child: Text(
                          "${currentImageIndex + 1}/${profileImages.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Name
                      const Text(
                        "Fatima",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text("25", style: TextStyle(fontSize: 24)),

                      const SizedBox(height: 8),

                      const Text("Ambivert", style: TextStyle(fontSize: 24)),

                      const SizedBox(height: 8),

                      const Text("Eindhoven", style: TextStyle(fontSize: 24)),

                      const SizedBox(height: 25),

                      // Interests
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              color: const Color(0xFF36A7A7),
                              child: const Text(
                                "Sports",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              color: const Color(0xFF36A7A7),
                              child: const Text(
                                "Arts & Culture",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Bio Title
                const Text("Bio", style: TextStyle(fontSize: 24)),

                const SizedBox(height: 10),

                // Bio Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "Hey guys I am someone who loves playing basketball and also I love painting and I am here to meet new people who share my interests.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 40),

                // Like Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F6D6D),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Like",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ignore Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF1F6D6D),
                        width: 2,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Ignore",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
