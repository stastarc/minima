import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/models/myplant/plant.dart';
import 'package:minima/app/models/myplant/schedule.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/widgets/retry.dart';

class MyPlantRegisterView extends StatefulWidget {
  final String name, plantName;
  final int plantId;
  final Map<String, DateTime> schedules;
  final File image;
  final VoidCallback onDone;

  const MyPlantRegisterView({
    super.key,
    required this.name,
    required this.plantName,
    required this.plantId,
    required this.schedules,
    required this.image,
    required this.onDone,
  });

  @override
  State createState() => _MyPlantRegisterViewState();
}

class _MyPlantRegisterViewState extends State<MyPlantRegisterView> {
  dynamic result;
  late Future<void> initialized;

  Future<void> initialize() async {
    try {
      result = await MyPlant.instance.registerMyPlant(
          widget.name, widget.image.path, widget.plantId, widget.schedules);
      await Future.delayed(const Duration(seconds: 2));
      widget.onDone();
    } catch (e) {
      result = BackendError.fromException(e);
    }
  }

  void retry() {
    setState(() {
      result = null;
      initialized = initialize();
    });
  }

  @override
  void initState() {
    super.initState();
    initialized = initialize();
  }

  String getEmoji(String schedule) {
    switch (schedule) {
      case 'water':
        return '💧';
      case 'fertilize':
        return '🌱';
      case 'prune':
        return '✂️';
      default:
        return '🌱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (result is BackendError ||
          snapshot.hasError ||
          (result == null &&
              snapshot.connectionState == ConnectionState.done)) {
        return RetryButton(
          text: '식물을 등록할 수 없습니다.',
          error: result ?? BackendError.unknown(),
          onPressed: retry,
        );
      }

      final res = result == null ? null : result as MyPlantRegisterData;
      final succ = res != null;
      var schi = 0;

      return Column(
        children: [
          const SizedBox(height: 32),
          SizedBox(
              width: 180,
              height: 180,
              child: succ
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(widget.image, fit: BoxFit.cover),
                    )
                  : Center(
                      child: LoadingAnimationWidget.bouncingBall(
                          color: const Color(0xFF52DA98), size: 72),
                    )),
          const SizedBox(height: 32),
          Text(
              succ
                  ? '${widget.name}을(를) 등록했어요!'
                  : '${widget.name}을(를) 등록하고\n스케줄을 만들고 있어요.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          Text(widget.plantName.trim(),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 32),
          const Spacer(),
          if (succ && res.schedule != null) ...[
            const Text('스케줄',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var e in res.schedule!.cycle.entries)
                          if (e.value != null && schi++ < 3)
                            Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(getEmoji(e.key),
                                        style: const TextStyle(
                                            fontSize: 42,
                                            fontFamily: 'SegoeUIEmoji')),
                                    const SizedBox(height: 8),
                                    AutoSizeText(
                                        ScheduleToDoItme
                                                .localizedNames[e.key] ??
                                            '알수없음',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text('${e.value!.inDays}일',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500))
                                  ]),
                            )
                      ],
                    )))
          ],
          const Spacer(),
        ],
      );
    });
  }
}
