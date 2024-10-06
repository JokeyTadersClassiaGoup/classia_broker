import 'package:equal_space/equal_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common/entity/unique_id.dart';
import '../domain/entity/prediction.dart';

// class UploadPredictionPage extends StatelessWidget {
//   static const routeName = '/upcoming-page';

//   const UploadPredictionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => UpcomingPageCubit(
//           postPrediction: PostPrediction(
//               jokeyRepository:
//                   RepositoryProvider.of<JokeyRepository>(context))),
//       child: const UpcomingPage(),
//     );
//   }
// }

class UploadPredictionPage extends StatefulWidget {
  static const routeName = '/upcoming-page';

  const UploadPredictionPage({super.key});

  @override
  State<UploadPredictionPage> createState() => _UploadPredictionPageState();
}

class _UploadPredictionPageState extends State<UploadPredictionPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final TextEditingController predictionTextController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    predictionTextController.dispose();
    titleController.dispose();
    noteController.dispose();
    isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<UpcomingPageCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SpacedColumn(
          space: 10.0,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white70),
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'Title',
                // hintText: '80.0%',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white70),
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'Note (optional)',
                // hintText: '',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
            TextField(
              controller: predictionTextController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.white70),
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'Prediction value',
                hintText: '80.0%',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, val, child) {
                return isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final auth = FirebaseAuth.instance;
                            Prediction prediction = Prediction(
                              predictionValue:
                                  double.parse(predictionTextController.text),
                              dateTime: DateTime.now(),
                              predictionId: PredictionId().value,
                              jokeyUid: auth.currentUser!.uid,
                              achived: 10.0,
                              title: titleController.text,
                              note: 'o',
                            );
                            isLoading.value = true;
                            // await cubit.uploadPrediction(prediction);
                            // Workmanager().registerOneOffTask(
                            //   'testtask',
                            //   'printWithTime',
                            //   // initialDelay: Duration(seconds: 30),
                            // );
                            context.pop();
                            isLoading.value = false;
                          },
                          child: const Text('Post'),
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
