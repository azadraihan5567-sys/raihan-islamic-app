import 'package:flutter/material.dart';

void main() {
  runApp(const RaihanIslamicApp());
}

class RaihanIslamicApp extends StatelessWidget {
  const RaihanIslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raihan Islamic App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006B4F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F6EF),
        fontFamily: 'Arial',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const green = Color(0xFF006B4F);
  static const gold = Color(0xFFD8A83E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Raihan Islamic App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('দীন জানুন, জীবন গড়ুন', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _dateLocationCard(),
          const SizedBox(height: 12),
          _nextPrayerCard(context),
          const SizedBox(height: 16),
          const Text(
            'আজকের নামাজের সময়',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _prayerRow('ফজর', '04:36 AM', Icons.nightlight_round),
          _prayerRow('যোহর', '12:45 PM', Icons.wb_sunny_outlined),
          _prayerRow('আসর', '04:15 PM', Icons.wb_twilight),
          _prayerRow('মাগরিব', '06:35 PM', Icons.wb_twilight),
          _prayerRow('এশা', '07:50 PM', Icons.nightlight),
          const SizedBox(height: 16),
          const Text(
            'ইসলামিক বিষয়সমূহ',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.35,
            children: [
              _feature(context, '📖', 'কুরআন', 'তিলাওয়াত ও অনুবাদ'),
              _feature(context, '📜', 'হাদিস', 'সহিহ হাদিসসমূহ'),
              _feature(context, '📚', 'মাসআলা', 'ইসলামিক মাসআলা'),
              _feature(context, '🤲', 'দোয়া ও যিকির', 'দৈনন্দিন দোয়া'),
              _feature(context, '🧭', 'কিবলা', 'কিবলা নির্দেশনা'),
              _feature(context, '📿', 'তাসবিহ', 'ডিজিটাল তাসবিহ'),
              _feature(context, '🌙', 'রমজান', 'সেহরি, ইফতার ও রোজা'),
              _feature(context, '📅', 'ইসলামিক ক্যালেন্ডার', 'হিজরি তারিখ'),
              _feature(context, '👦', 'নামাজ শিক্ষা', 'ধাপে ধাপে নামাজ'),
              _feature(context, '📚', 'ইসলামিক গল্প', 'শিক্ষামূলক গল্প'),
              _feature(context, '⭐', 'বুকমার্ক / প্রিয়', 'সংরক্ষিত কনটেন্ট'),
              _feature(context, '🔔', 'আজান Alarm', 'নামাজের সময় অ্যালার্ম'),
            ],
          ),
          const SizedBox(height: 16),
          _simpleCard(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'ভাষা, নোটিফিকেশন ও অন্যান্য সেটিংস',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'হোম'),
          NavigationDestination(icon: Icon(Icons.access_time), label: 'নামাজ'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'কুরআন'),
          NavigationDestination(icon: Icon(Icons.library_books), label: 'হাদিস'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'আরও'),
        ],
      ),
    );
  }

  Widget _dateLocationCard() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: green, size: 30),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ঢাকা, বাংলাদেশ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('আজ • ১৬ আগস্ট ২০২৬'),
                  Text('হিজরি তারিখ • লোকেশন অনুযায়ী আপডেট হবে'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.my_location),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextPrayerCard(BuildContext context) {
    return Card(
      color: green,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('পরবর্তী নামাজ',
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 4),
                  Text('যোহর',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  Text('12:45 PM',
                      style: TextStyle(color: gold, fontSize: 22)),
                ],
              ),
            ),
            Column(
              children: [
                const Text('01:45:32',
                    style: TextStyle(color: Colors.white, fontSize: 23)),
                const Text('বাকি সময়',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: green,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AlarmPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Alarm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerRow(String name, String time, IconData icon) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: green),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time),
            const SizedBox(width: 8),
            Icon(Icons.notifications_none, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _feature(
    BuildContext context,
    String emoji,
    String title,
    String subtitle,
  ) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FeaturePage(title: title, subtitle: subtitle),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 5),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.settings, color: green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String title;
  final String subtitle;

  const FeaturePage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🕌', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 20),
              Text(title,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              const Text(
                'এই পেজটি পরের ধাপে সম্পূর্ণ ফিচারসহ তৈরি করা হবে।',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final Map<String, bool> alarms = {
    'ফজর': true,
    'যোহর': true,
    'আসর': true,
    'মাগরিব': true,
    'এশা': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('আজান Alarm Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'নামাজের সময় অনুযায়ী আজান/নোটিফিকেশন',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...alarms.keys.map(
            (name) => Card(
              child: SwitchListTile(
                value: alarms[name]!,
                title: Text(name),
                subtitle: const Text('আজানের সময় notification'),
                secondary: const Icon(Icons.notifications_active_outlined),
                onChanged: (value) {
                  setState(() => alarms[name] = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'নোট: এই starter version-এ UI ও toggle তৈরি আছে। '
                'পরের ধাপে Android/iPhone-এর আসল local notification, '
                'azan audio, location এবং prayer-time calculation যুক্ত করা হবে।',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
