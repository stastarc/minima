import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/backend/myplant/myplant.dart';
import 'package:minima/app/models/myplant/info.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/skeletons/skeleton_box.dart';
import 'package:minima/shared/skeletons/skeleton_text.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:minima/shared/widgets/textfield.dart';

const int _SEARCH_DELAY = 1000;

class SearchView extends StatefulWidget {
  final void Function(PlantInfoData) onSelected;

  const SearchView({super.key, required this.onSelected});

  @override
  State createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  String? lastSearchQuery;
  DateTime? lastChanged;
  dynamic search;
  bool _isInSearch = false;
  Future<void>? searchFuture;

  Future<void> onSearch() async {
    try {
      _isInSearch = true;
      final query = _searchController.text.trim();
      search = await MyPlant.instance.searchPlants(query);
      lastSearchQuery = query;
    } catch (e) {
      search = BackendError.fromException(e);
    }
    _isInSearch = false;
    setState(() {});
  }

  void trySearch() async {
    if (lastSearchQuery != '__FEEDS__') {
      if (_searchController.text.trim().length <= 1) return;
      if (_isInSearch || _searchController.text.trim() == lastSearchQuery)
        return;
    }
    searchFuture = onSearch();
    setState(() {});
  }

  void onBack() {
    Navigator.pop(context);
  }

  void onQueryChanged(String text) {
    lastChanged = DateTime.now();
    Future.delayed(const Duration(milliseconds: _SEARCH_DELAY + 1), () {
      if (DateTime.now().difference(lastChanged!).inMilliseconds >=
          _SEARCH_DELAY) {
        trySearch();
      }
    });
  }

  void onTab(PlantInfoData plant) {
    widget.onSelected(plant);
  }

  @override
  void initState() {
    super.initState();
    lastSearchQuery = '__FEEDS__';
    trySearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    child: PrimaryTextField(
                  controller: _searchController,
                  padding: const EdgeInsets.all(8),
                  hint: '식물 이름을 입력해주세요.',
                  keyboardType: TextInputType.text,
                  onSubmitted: (text) {
                    _searchController.text = text;
                    trySearch();
                  },
                  onChanged: onQueryChanged,
                  suffix: GestureDetector(
                    child: const Icon(
                      Icons.close_outlined,
                      color: Color(0xFF3D3D3D),
                      size: 20,
                    ),
                    onTap: () => setState(() => _searchController.text = ''),
                  ),
                )),
                SizedBox(
                    width: 48,
                    height: 48,
                    child: TextButton(
                        onPressed: trySearch,
                        child: const Icon(Icons.search,
                            size: 28, color: Color(0xFF3D3D3D)))),
              ],
            )),
        if (searchFuture != null)
          FutureBuilder(
              future: searchFuture,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (search == null || search is BackendError) {
                    return RetryButton(
                      text: '검색 내용을 가져올 수 없습니다.',
                      error: search ?? BackendError.unknown(),
                      onPressed: trySearch,
                    );
                  }

                  return Expanded(
                      child: ListView(
                    children: [
                      for (final plant in search as List<PlantInfoData>)
                        buildPlantItem(plant)
                    ],
                  ));
                }

                return Expanded(
                    child: Skeleton(
                        child: ListView(
                  children: [
                    for (int i = 0; i < 3; i++) buildPlantItemSkeleton()
                  ],
                )));
              }))
      ],
    );
  }

  Widget buildPlantItem(PlantInfoData plant) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
            onTap: () => onTab(plant),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF9C9C9C), width: 1)),
              child: Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CDN.image(
                      id: plant.image,
                      width: 108,
                      height: 82,
                      fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Text(plant.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF3D3D3D), size: 16),
                const SizedBox(width: 4),
              ]),
            )));
  }

  Widget buildPlantItemSkeleton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            const SkeletonBox(
              width: 108,
              height: 82,
            ),
            const SizedBox(width: 16),
            SkeletonText(wordLengths: const [12, 8], fontSize: 15),
          ]),
        ));
  }
}
