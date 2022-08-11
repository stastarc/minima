import 'dart:convert';

import 'package:minima/app/models/market/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketCheckout {
  static MarketCheckout? _instance;
  static MarketCheckout get instance => _instance ??= MarketCheckout();

  late Future<void> initialize;
  late SharedPreferences storage;
  CheckoutCache? cache;
  bool initialized = false;

  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    initialized = true;
  }

  MarketCheckout() {
    initialize = init();
  }

  Future<void> wfi() async {
    if (initialized) return;
    await initialize;
  }

  Future<CheckoutCache> get() async {
    if (cache != null) return cache!;
    await wfi();
    final checkout = storage.getString('checkout.cache');
    cache = checkout == null
        ? CheckoutCache.empty()
        : CheckoutCache.fromJson(json.decode(checkout));
    return cache!;
  }

  Future<void> save() async {
    await wfi();
    cache ??= CheckoutCache.empty();
    await storage.setString('checkout.cache', json.encode((cache!).toJson()));
  }

  Future<void> update(bool Function(CheckoutCache) func) async {
    await wfi();
    final cache = await get();
    if (func(cache)) await save();
  }
}
