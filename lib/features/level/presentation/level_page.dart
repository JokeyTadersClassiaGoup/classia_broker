import 'dart:async';

import 'package:classia_broker/core/utils/collection_name.dart';
import 'package:classia_broker/features/level/presentation/upcoming_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/entity/jockey.dart';
import '../domain/entity/prediction.dart';

class LevelPage extends StatefulWidget {
  static const routeName = '/level-page';
  // final String accessToken;
  const LevelPage({
    super.key,
    // required this.accessToken,
  });

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  // late Timer timer;

  var isInit = true;
  var available = false;
  List<Prediction>? pastPerformance;
  ValueNotifier<bool> isTableLoading = ValueNotifier(false);
  ValueNotifier<double> average = ValueNotifier(0.0);

  Jokey? jokey;

  Prediction? prediction;
  var date;
  Future<void> isUserAvailable() async {
    isTableLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      false;
    }
    final userId = user!.uid;
    print('uid $userId');
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(brokersCollectionName)
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        var upcoming = await FirebaseFirestore.instance
            .collection(brokersCollectionName)
            .doc(userId)
            .collection(upcomingPredictionCollectionName)
            .get();
        pastPerformance =
            upcoming.docs.map((doc) => Prediction.fromMap(doc.data())).toList();

        for (var i in upcoming.docs) {
          prediction = Prediction.fromMap(i.data());

          date = DateFormat('MM/dd/yyyy').format(prediction!.dateTime);
        }
        isTableLoading.value = false;
        setState(() {});
        // FirebaseFirestore.instance
        //     .collection('Active-Jokies')
        //     .doc(user.uid)
        //     .get();
      } else {
        isTableLoading.value = false;
        available = false;
        print('no');
      }
    } catch (e) {
      isTableLoading.value = false;
      print('err $e');
    }
  }

  var isBlocked = false;

  void checkBlock() {
    final now = DateTime.now();
    final closeTime = DateTime(now.year, now.month, now.day, 10, 38);

    if (now.isBefore(closeTime)) {
      isBlocked = true;
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      // checkBlock();
      await isUserAvailable();
    }
    isInit = false;
  }

  var style = const TextStyle(fontSize: 18, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Level'),
        actions: [
          IconButton(
              onPressed: () async {
                await isUserAvailable();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: isTableLoading,
          builder: (context, val, child) {
            return isTableLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prediction == null
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  'No Upcoming, post your upcoming at 3 : 30 pm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Your upcoming',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              ListTile(
                                title: Text(
                                  prediction!.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                trailing: Text(
                                    '${prediction!.predictionValue} %',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                subtitle: Text(
                                  date,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                                indent: 10,
                                endIndent: 10,
                              ),
                              const Text(
                                'Past performance',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              DataTable(
                                showBottomBorder: true,
                                headingTextStyle: const TextStyle(
                                    color: Colors.amber, fontSize: 16),
                                dataTextStyle:
                                    const TextStyle(color: Colors.white),
                                columns: <DataColumn>[
                                  DataColumn(
                                      headingRowAlignment:
                                          MainAxisAlignment.center,
                                      label: Text('Date')),
                                  DataColumn(
                                      // headingRowAlignment: MainAxisAlignment.spaceEvenly,
                                      label: Container(
                                          // width: 100.w,
                                          alignment: Alignment.center,
                                          child: const Text('Prediction'))),
                                  DataColumn(
                                    label: Container(
                                      // color: Colors.white24,
                                      alignment: Alignment.centerLeft,
                                      child: const Text('Achived'),
                                    ),
                                  )
                                ],
                                rows: List.generate(pastPerformance!.length,
                                    (index) {
                                  final pred = pastPerformance![index];
                                  final date =
                                      DateFormat.yMd().format(pred.dateTime);
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(date)),
                                      DataCell(Center(
                                          child: Text(pred.predictionValue
                                              .toString()))),
                                      DataCell(Align(
                                          alignment: Alignment.center,
                                          child: Text(pred.achived.toString())))
                                    ],
                                  );
                                }),
                              )
                            ],
                          ),
                  );
          }),
      floatingActionButton: isBlocked
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () =>
                  context.pushNamed(UploadPredictionPage.routeName),
              // onPressed: () {
              //   Workmanager().registerOneOffTask(
              //     'test',
              //     'printWthTime',
              //     initialDelay: const Duration(seconds: 7),
              //   );
              // },
              child: const Icon(
                CupertinoIcons.add,
                color: AppColors.goldColor,
              ),
            ),
    );
  }
}
