import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      ),
      home: const HomePage(),
    );
  }
}

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
                    fontSize: 25,
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

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.menu_book_rounded),
              ),
              title: const Text(
                'আল-কুরআন',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: const Text(
                '১১৪ সূরা • আরবি • বাংলা অনুবাদ • Search',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuranPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.access_time),
              ),
              title: const Text(
                'নামাজের সময়',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('শীঘ্রই যোগ করা হবে'),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.auto_stories),
              ),
              title: const Text(
                'হাদিস',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('শীঘ্রই যোগ করা হবে'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<Surah> surahs = [];
  List<Surah> filteredSurahs = [];

  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.alquran.cloud/v1/surah'),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error');
      }

      final json = jsonDecode(response.body);

      final List data = json['data'];

      final result = data.map((item) {
        return Surah(
          number: item['number'],
          name: item['name'],
          englishName: item['englishName'],
          translation: item['englishNameTranslation'],
          numberOfAyahs: item['numberOfAyahs'],
          revelationType: item['revelationType'],
        );
      }).toList();

      setState(() {
        surahs = result;
        filteredSurahs = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = 'কুরআনের তথ্য লোড করা যাচ্ছে না।\nInternet সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  void searchSurah(String query) {
    final text = query.trim().toLowerCase();

    if (text.isEmpty) {
      setState(() {
        filteredSurahs = surahs;
      });
      return;
    }

    setState(() {
      filteredSurahs = surahs.where((surah) {
        return surah.name.toLowerCase().contains(text) ||
            surah.englishName.toLowerCase().contains(text) ||
            surah.number.toString() == text;
      }).toList();
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
          : error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        onChanged: searchSurah,
                        decoration: InputDecoration(
                          hintText: 'সূরা খুঁজুন...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredSurahs.length,
                        itemBuilder: (context, index) {
                          final surah = filteredSurahs[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  '${surah.number}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                surah.name,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${surah.englishName} • ${surah.numberOfAyahs} আয়াত',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SurahPage(
                                      surah: surah,
                                      allSurahs: surahs,
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

class SurahPage extends StatefulWidget {
  final Surah surah;
  final List<Surah> allSurahs;

  const SurahPage({
    super.key,
    required this.surah,
    required this.allSurahs,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<Ayah> ayahs = [];

  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadSurah();
  }

  Future<void> loadSurah() async {
    try {
      final url =
          'https://api.alquran.cloud/v1/surah/${widget.surah.number}/editions/quran-uthmani,bn.bengali';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed');
      }

      final json = jsonDecode(response.body);

      final List editions = json['data'];

      final arabicData = editions[0]['ayahs'];
      final bengaliData = editions[1]['ayahs'];

      final List<Ayah> result = [];

      for (int i = 0; i < arabicData.length; i++) {
        result.add(
          Ayah(
            number: arabicData[i]['numberInSurah'],
            arabic: arabicData[i]['text'],
            bengali: bengaliData[i]['text'],
          ),
        );
      }

      setState(() {
        ayahs = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error =
            'এই সূরার তথ্য লোড করা যাচ্ছে না।\nInternet সংযোগ পরীক্ষা করুন।';
      });
    }
  }

  int get currentIndex {
    return widget.allSurahs.indexWhere(
      (s) => s.number == widget.surah.number,
    );
  }

  void openSurah(int index) {
    if (index < 0 || index >= widget.allSurahs.length) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SurahPage(
          surah: widget.allSurahs[index],
          allSurahs: widget.allSurahs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.name),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green.shade50,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.surah.name,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.surah.englishName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.surah.numberOfAyahs} আয়াত • ${widget.surah.revelationType}',
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        itemCount: ayahs.length,
                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircleAvatar(
                                      radius: 16,
                                      child: Text(
                                        '${ayah.number}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    ayah.arabic,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      height: 2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const Divider(height: 30),

                                  Text(
                                    ayah.bengali,
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
                        },
                      ),
                    ),

                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          12,
                          6,
                          12,
                          10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: currentIndex > 0
                                    ? () => openSurah(currentIndex - 1)
                                    : null,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('আগের সূরা'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed:
                                    currentIndex <
                                            widget.allSurahs.length - 1
                                        ? () => openSurah(currentIndex + 1)
                                        : null,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('পরের সূরা'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String translation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.translation,
    required this.numberOfAyahs,
    required this.revelationType,
  });
}

class Ayah {
  final int number;
  final String arabic;
  final String bengali;

  Ayah({
    required this.number,
    required this.arabic,
    required this.bengali,
  });
} 
