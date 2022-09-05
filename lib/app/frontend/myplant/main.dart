import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/frontend/myplant/widgets/calendar.dart';
import 'package:minima/app/frontend/myplant/widgets/plant.dart';
import 'package:minima/app/frontend/myplant/widgets/todo.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/widgets/retry.dart';

class MyPlantPage extends StatefulWidget {
  const MyPlantPage({super.key});

  @override
  State createState() => _MyPlantPageState();
}

class _MyPlantPageState extends State<MyPlantPage> {
  dynamic myPlants;
  late Future<void> initialized;

  Future<void> initialize() async {
    try {
      myPlants = await MyPlant.instance.getCachedMyPlants();

      if (myPlants is List<MyPlantData>) {
        // await CDN.instance.preloadImages([
        //   for (var plant in myPlants as List<MyPlantData>) plant.image,
        // ]);
      }
    } catch (e) {
      myPlants = BackendError.fromException(e);
    }
  }

  void retry() {
    setState(() {
      myPlants = null;
      initialized = initialize();
    });
  }

  void refresh() {
    MyPlant.instance.clearCache();
    retry();
  }

  @override
  void initState() {
    super.initState();
    initialized = initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (myPlants == null ||
                myPlants is BackendError ||
                snapshot.hasError) {
              return RetryButton(
                text: '피드를 가져올 수 없습니다.',
                error: myPlants ?? BackendError.unknown(),
                onPressed: refresh,
              );
            } else {
              final myPlants = this.myPlants as List<MyPlantData>;

              return ListView(
                children: [
                  const Padding(
                      padding: EdgeInsets.fromLTRB(0, 38, 0, 16),
                      child: Text('나의 정원',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  WidthCalendar(myPlants: myPlants),
                  const SizedBox(height: 14),
                  ToDoView(myPlants: myPlants, onRefresh: refresh),
                  const SizedBox(height: 14),
                  MyPlantView(
                    myPlants: myPlants,
                    onRefresh: refresh,
                  )
                ],
              );
            }
          }

          return ListView(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 38, 0, 16),
                  child: Text('나의 정원',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              Skeleton(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: const [
                            SkeletonBox(
                              height: 26,
                              width: double.infinity,
                            ),
                            SizedBox(height: 14),
                            SkeletonBox(
                              height: 52,
                              width: double.infinity,
                            )
                          ],
                        )),
                    const MyPlantViewSkeleton()
                  ],
                ),
              )
            ],
          );
        });
  }
}
