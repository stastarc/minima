import 'package:flutter/material.dart';
import 'package:minima/app/backend/market/market.dart';
import 'package:minima/app/frontend/market/widgets/search/product_view.dart';
import 'package:minima/shared/error.dart';
import 'package:minima/shared/skeletons/skeleton.dart';
import 'package:minima/shared/widgets/retry.dart';
import 'package:minima/shared/widgets/textfield.dart';

const int _SEARCH_DELAY = 1000;

class SearchPage extends StatefulWidget {
  final String? query;
  final bool noRecommended;

  const SearchPage({
    super.key,
    this.query,
    this.noRecommended = false,
  });

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      search = await Market.instance.search(query);
      lastSearchQuery = query;
    } catch (e) {
      search = BackendError.fromException(e);
    }
    _isInSearch = false;
    setState(() {});
  }

  void trySearch() async {
    if (_searchController.text.trim().length <= 1) return;
    if (_isInSearch || _searchController.text.trim() == lastSearchQuery) return;
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

  @override
  void initState() {
    super.initState();
    if (widget.query != null) {
      _searchController.text = widget.query!;
      trySearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 48,
                      height: 48,
                      child: TextButton(
                          onPressed: onBack,
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 24, color: Color(0xFF3D3D3D)))),
                  Expanded(
                      child: PrimaryTextField(
                    controller: _searchController,
                    padding: const EdgeInsets.all(8),
                    hint: '검색어를 입력해주세요.',
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
              ),
              const SizedBox(height: 14),
              const Divider(
                color: Colors.black26,
                height: 1,
              ),
              if (searchFuture != null)
                Expanded(
                    child: FutureBuilder(
                        future: searchFuture,
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (search == null || search is BackendError) {
                              return RetryButton(
                                text: '검색 내용을 가져올 수 없습니다.',
                                error: search ?? BackendError.unknown(),
                                onPressed: trySearch,
                              );
                            }

                            return ProductView(
                                search: search,
                                noRecommended: widget.noRecommended);
                          }

                          return const Skeleton(child: ProductViewSkeleton());
                        })))
            ],
          )),
    );
  }
}
