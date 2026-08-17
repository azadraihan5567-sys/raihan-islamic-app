import 'dart:convert';
import 'dart:io';

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
        colorSchemeSeed: Colors.green,
        fontFamily: 'sans',
      ),
      home: const HomePage(),
    );
  }
}

// ================= HOME =================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Raihan Islamic App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff087f5b),
                  Color(0xff20a878),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'আল্লাহর নামে শুরু করছি, যিনি পরম করুণাময়, অতি দয়ালু।',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _FeatureCard(
            icon: Icons.menu_book_rounded,
            title: 'আল-কুরআন',
            subtitle: '১১৪টি সূরা • Arabic • বাংলা অনুবাদ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuranPage(),
                ),
              );
            },
          ),

          _FeatureCard(
            icon: Icons.auto_stories_rounded,
            title: 'হাদিস',
            subtitle: 'হাদিস পড়ুন',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('হাদিস ফিচার পরের ধাপে যোগ করা হবে।'),
                ),
              );
            },
          ),

          _FeatureCard(
            icon: Icons.access_time_rounded,
            title: 'নামাজের সময়',
            subtitle: 'পাঁচ ওয়াক্তের সময়সূচি',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('নামাজের সময় পরের ধাপে যোগ করা হবে।'),
                ),
              );
            },
          ),

          _FeatureCard(
            icon: Icons.favorite_rounded,
            title: 'দোয়া',
            subtitle: 'দৈনন্দিন প্রয়োজনীয় দোয়া',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('দোয়া ফিচার পরের ধাপে যোগ করা হবে।'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          radius: 25,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}

// ================= QURAN API =================

class QuranApi {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  static Future<dynamic> getJson(String url) async {
    final client = HttpClient();

    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final body = await response.transform(utf8.decoder).join();

      return jsonDecode(body);
    } finally {
      client.close();
    }
  }

  // ১১৪টি সূরার তালিকা
  static Future<List<Surah>> getSurahs() async {
    final json = await getJson('$baseUrl/surah');

    final List data = json['data'];

    return data
        .map(
          (item) => Surah.fromJson(item),
        )
        .toList();
  }

  // Arabic + বাংলা অনুবাদ
  static Future<List<Ayah>> getAyahs(int surahNumber) async {
    final url =
        '$baseUrl/surah/$surahNumber/editions/quran-uthmani,bn.bengali';

    final json = await getJson(url);

    final List editions = json['data'];

    final List arabicAyahs = editions[0]['ayahs'];
    final List banglaAyahs = editions[1]['ayahs'];

    final List<Ayah> result = [];

    for (int i = 0; i < arabicAyahs.length; i++) {
      result.add(
        Ayah(
          numberInSurah: arabicAyahs[i]['numberInSurah'],
          arabic: arabicAyahs[i]['text'],
          bangla: banglaAyahs[i]['text'],
        ),
      );
    }

    return result;
  }
}

// ================= DATA MODELS =================

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishTranslation;
  final int numberOfAyahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishTranslation,
    required this.numberOfAyahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
    );
  }
}

class Ayah {
  final int numberInSurah;
  final String arabic;
  final String bangla;

  Ayah({
    required this.numberInSurah,
    required this.arabic,
    required this.bangla,
  });
}

// ================= SURAH LIST =================

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<Surah> allSurahs = [];
  List<Surah> filteredSurahs = [];

  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    try {
      final result = await QuranApi.getSurahs();

      if (!mounted) return;

      setState(() {
        allSurahs = result;
        filteredSurahs = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error = 'সূরার তালিকা লোড করা যায়নি।\nইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  void searchSurah(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredSurahs = allSurahs;
      } else {
        filteredSurahs = allSurahs.where((surah) {
          return surah.number.toString().contains(query) ||
              surah.name.toLowerCase().contains(query) ||
              surah.englishName.toLowerCase().contains(query) ||
              surah.englishTranslation.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'আল-কুরআন',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                              error = null;
                            });
                            loadSurahs();
                          },
                          child: const Text('আবার চেষ্টা করুন'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: searchSurah,
                        decoration: InputDecoration(
                          hintText: 'সূরা খুঁজুন...',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredSurahs.isEmpty
                          ? const Center(
                              child: Text(
                                'কোনো সূরা পাওয়া যায়নি।',
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filteredSurahs.length,
                              itemBuilder: (context, index) {
                                final surah =
                                    filteredSurahs[index];

                                return Card(
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      child: Text(
                                        '${surah.number}',
                                      ),
                                    ),
                                    title: Text(
                                      surah.name,
                                      textDirection:
                                          TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${surah.englishName} • ${surah.numberOfAyahs} আয়াত',
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SurahPage(
                                            surah: surah,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

// ================= SURAH READER =================

class SurahPage extends StatefulWidget {
  final Surah surah;

  const SurahPage({
    super.key,
    required this.surah,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<Ayah> ayahs = [];

  bool loading = true;
  String? error;

  final ScrollController scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();
    loadAyahs();
  }

  Future<void> loadAyahs() async {
    try {
      final result =
          await QuranApi.getAyahs(widget.surah.number);

      if (!mounted) return;

      setState(() {
        ayahs = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        error =
            'এই সূরার আয়াত লোড করা যায়নি।\nইন্টারনেট সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  void goToAyah() {
    if (ayahs.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();

        return AlertDialog(
          title: const Text('আয়াতে যান'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'আয়াত নম্বর লিখুন',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                final number =
                    int.tryParse(controller.text);

                if (number == null ||
                    number < 1 ||
                    number > ayahs.length) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '১ থেকে ${ayahs.length} এর মধ্যে আয়াত নম্বর দিন।',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                scrollController.animateTo(
                  (number - 1) * 250.0,
                  duration:
                      const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('যান'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surah.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'আয়াতে যান',
            onPressed: loading ? null : goToAyah,
            icon: const Icon(
              Icons.format_list_numbered_rounded,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                              error = null;
                            });
                            loadAyahs();
                          },
                          child: const Text('আবার চেষ্টা করুন'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(20),
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.surah.name,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.surah.englishName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.surah.englishTranslation,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.surah.numberOfAyahs} আয়াত',
                          ),
                        ],
                      ),
                    ),

                    if (widget.surah.number != 1 &&
                        widget.surah.number != 9)
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 18,
                        ),
                        child: Text(
                          'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ...ayahs.map(
                      (ayah) => AyahCard(
                        ayah: ayah,
                      ),
                    ),
                  ],
                ),
    );
  }
}

// ================= AYAH CARD =================

class AyahCard extends StatelessWidget {
  final Ayah ayah;

  const AyahCard({
    super.key,
    required this.ayah,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    '${ayah.numberInSurah}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'আয়াত ${ayah.numberInSurah}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              ayah.arabic,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 28,
                height: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(height: 30),

            const Text(
              'বাংলা অনুবাদ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              ayah.bangla,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 17,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
