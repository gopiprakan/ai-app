import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/glass_card.dart';
import 'camera_screen.dart';
import 'chat_screen.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AgriAI ASSISTANT'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0C1410), Color(0xFF1B5E20), Color(0xFF0C1410)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: const WeatherWidget(),
                ),
                const SizedBox(height: 25),
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        title: "Scan Leaf",
                        icon: Icons.camera_alt_rounded,
                        color: Colors.greenAccent,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraScreen())),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ActionCard(
                        title: "AI Chat",
                        icon: Icons.chat_bubble_rounded,
                        color: Colors.blueAccent,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Text(
                  "Crop Health Tips",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const TipsCarousel(),
                const SizedBox(height: 25),
                Text(
                  "Recent Scans",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const RecentScansList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return GlassCard(
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, "Home", true),
          _navItem(Icons.analytics_rounded, "Insights", false),
          _navItem(Icons.eco_rounded, "My Crops", false),
          _navItem(Icons.settings, "Tools", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.greenAccent : Colors.grey),
        Text(label, style: TextStyle(color: active ? Colors.greenAccent : Colors.grey, fontSize: 10)),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Karur, Tamil Nadu", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 5),
              Text("32°C", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text("Partly Cloudy • Humidity 65%", style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const Icon(Icons.wb_cloudy_rounded, size: 64, color: Colors.white70),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: GlassCard(
        opacity: 0.15,
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class TipsCarousel extends StatelessWidget {
  const TipsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      "Use Neem oil for natural pest control in Chili.",
      "Ensure proper space between Paddy plants for ventilation.",
      "Check Tomato leaves for black spots after rain."
    ];
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) => Container(
          width: 250,
          child: GlassCard(
            opacity: 0.05,
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.orangeAccent),
                const SizedBox(width: 10),
                Expanded(child: Text(tips[index], style: const TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentScansList extends StatelessWidget {
  const RecentScansList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GlassCard(
          opacity: 0.08,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(width: 50, height: 50, color: Colors.white10, child: const Icon(Icons.image)),
            ),
            title: Text(index == 0 ? "Rice Blast Detected" : "Tomato Healthy"),
            subtitle: Text("Scanned on Feb 05, 2026"),
            trailing: const Icon(Icons.chevron_right, color: Colors.white30),
          ),
        ),
      )),
    );
  }
}
