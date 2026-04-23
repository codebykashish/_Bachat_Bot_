import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'auth_service.dart';
import 'chatbot_page.dart';

const Color primaryColor = Color(0xFF2DBE7F);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final AuthService _auth = AuthService();

  final List<Widget> pages = [
    const HomeContent(),
    const Center(child: Text("Categories Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Reports Page", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Settings Page", style: TextStyle(fontSize: 24))),
  ];

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          // ← Fixed: Makes drawer scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drawer Header
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: primaryColor),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: primaryColor),
                ),
                accountName: const Text(
                  "Alex",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text("alex@example.com"),
              ),

              // Main Navigation
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                selected: currentIndex == 0,
                selectedTileColor: primaryColor.withOpacity(0.1),
                onTap: () {
                  setState(() => currentIndex = 0);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.grid_view),
                title: const Text("Categories"),
                selected: currentIndex == 1,
                selectedTileColor: primaryColor.withOpacity(0.1),
                onTap: () {
                  setState(() => currentIndex = 1);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text("Reports"),
                selected: currentIndex == 2,
                selectedTileColor: primaryColor.withOpacity(0.1),
                onTap: () {
                  setState(() => currentIndex = 2);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                selected: currentIndex == 3,
                selectedTileColor: primaryColor.withOpacity(0.1),
                onTap: () {
                  setState(() => currentIndex = 3);
                  Navigator.pop(context);
                },
              ),

              const Divider(height: 8),

              // Additional Features
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Budget"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Budget feature coming soon")),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Transaction History"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("History feature coming soon"),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text("Analytics"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Analytics coming soon")),
                  );
                },
              ),

              const Divider(height: 8),

              // Settings Section
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 12, bottom: 8),
                child: Text(
                  "SETTINGS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notifications"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notifications settings")),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Privacy & Security"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Security settings")),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Help & Support"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Help & Support")),
                  );
                },
              ),

              const SizedBox(height: 20), // Extra space before logout
              // Logout at bottom
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            _logout();
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30), // Bottom padding
            ],
          ),
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.flash_on, color: Colors.white),
        ),
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: pages[currentIndex],
      floatingActionButton: FloatingActionButton(
  backgroundColor: primaryColor,
  elevation: 6,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatbotPage(),
      ),
    );
  },
  child: const Icon(Icons.chat, color: Colors.white),
), 

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

// ==================== HOME CONTENT (Unchanged - already safe with SingleChildScrollView) ====================
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Hello, Alex!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Your financial health looks steady.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor),
                ),
                child: const Text(
                  "Oct 2023",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _card(
                  "INCOME",
                  Icons.arrow_upward,
                  primaryColor.withOpacity(0.1),
                  primaryColor,
                ),
                const SizedBox(width: 12),
                _card(
                  "EXPENSE",
                  Icons.arrow_downward,
                  Colors.red.withOpacity(0.1),
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryItem(Icons.fastfood, "Food", "\$450", Colors.orange),
                  CategoryItem(
                    Icons.directions_car,
                    "Transport",
                    "\$120",
                    Colors.blue,
                  ),
                  CategoryItem(Icons.home, "Rent", "\$1200", Colors.green),
                  CategoryItem(Icons.movie, "Fun", "\$300", Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "7-Day Spending Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.2), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(child: Text("Graph UI")),
            ),

            const SizedBox(height: 24),

            const Text(
              "Today's Snapshot",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.receipt, color: primaryColor),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Daily Expense Summary\nYou've spent \$28 today",
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                  Text("ON TRACK", style: TextStyle(color: primaryColor)),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Color bg, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
// ==================== CATEGORY ITEM ====================

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final Color color;

  const CategoryItem(this.icon, this.title, this.amount, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // keeps your original color style
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}