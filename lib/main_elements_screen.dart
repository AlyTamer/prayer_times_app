import 'package:flutter/material.dart';
import 'package:prayer_times_app/widgets/prayer_time_list_widget.dart';

import 'funcs/all_functions.dart';

class MainElements extends StatefulWidget {
  const MainElements({super.key});

  @override
  State<MainElements> createState() => _MainElementsState();
}

class _MainElementsState extends State<MainElements> {
  late Future<Map<String, dynamic>> prayerTimes;

  @override
  void initState() {
    super.initState();
    prayerTimes = fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prayerTimes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        final data = snapshot.data!;
        final raw = data['timings'] as Map<String, dynamic>;
        final timings = raw.map((k, v) => MapEntry(k, v as String));
        final current = getCurrentPrayer(timings);
        final prayerOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
        final idx = prayerOrder.indexOf(current);
        final nextName = prayerOrder[(idx + 1) % prayerOrder.length];
        final nextTime = formatTime(timings[nextName]!);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 270,
                width: double.infinity,
                child: Card(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                Text(
                                  "$current Prayer",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Next prayer: ',
                                        style: TextStyle(
                                        ),
                                      ),
                                      TextSpan(
                                        text: nextName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          color:Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  nextTime,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            iconForPrayer(current),
                            size: 100,
                            color: Colors.white,  // or pick a color per‐prayer if you like
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding( padding: EdgeInsets.all(16),
            child:  Text(
              "Prayer Times",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),),
            SizedBox(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color.fromARGB(255, 16, 104, 73),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      color: ThemeData.dark().cardColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          PTimeWidget(
                            isCurrPrayer: current == 'Fajr',
                            currPrayer: "Fajr",
                            prayerTime: formatTime(data['timings']['Fajr']),
                          ),
                          Divider(),
                          PTimeWidget(
                            isCurrPrayer: current == 'Dhuhr',
                            currPrayer: "Dhuhr",
                            prayerTime: formatTime(data['timings']['Dhuhr']),
                          ),
                          Divider(),
                          PTimeWidget(
                            isCurrPrayer: current == 'Asr',
                            currPrayer: "Asr",
                            prayerTime: formatTime(data['timings']['Asr']),
                          ),
                          Divider(),
                          PTimeWidget(
                            isCurrPrayer: current == 'Maghrib',
                            currPrayer: "Maghrib",
                            prayerTime: formatTime(data['timings']['Maghrib']),
                          ),
                          Divider(),
                          PTimeWidget(
                            isCurrPrayer: current == 'Isha',
                            currPrayer: "Ishaa",
                            prayerTime: formatTime(data['timings']['Isha']),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
