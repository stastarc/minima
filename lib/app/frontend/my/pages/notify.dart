import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minima/app/backend/notify/notify.dart';
import 'package:minima/app/frontend/my/widgets/card_item.dart';
import 'package:minima/app/models/notify/settings.dart';
import 'package:minima/shared/number_format.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/switch.dart';

class NotifyPage extends StatefulWidget {
  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  late Future<void> _initialized;
  NotifySettings? _settings;

  Future<void> _initialize() async {
    _settings = await Notify.instance.get();
  }

  void onUpdate() async {
    await Notify.instance.save();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initialized = _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        title: '알림',
        child: FutureBuilder(
          future: _initialized,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                _settings != null) {
              final settings = _settings!;
              return Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      CardItem(
                        title: '앱 알림',
                        icon: const Icon(
                          Icons.alarm,
                          size: 32,
                        ),
                        child: PrimarySwitch(
                          value: settings.enabled,
                          onChanged: (value) {
                            settings.enabled = value;
                            onUpdate();
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      CardItem(
                          title: '알림 시간',
                          icon: const Icon(
                            Icons.access_time,
                            size: 32,
                          ),
                          child: Text(timeFormat(settings.time),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87)),
                          onTap: () {})
                    ],
                  ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
