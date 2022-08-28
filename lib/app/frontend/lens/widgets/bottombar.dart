import 'package:flutter/material.dart';

class BottomBarView extends StatefulWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final VoidCallback onChange;

  const BottomBarView({
    super.key,
    required this.onGallery,
    required this.onCamera,
    required this.onChange,
  });
  @override
  State createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                onPressed: widget.onGallery,
                color: const Color(0x2D909090),
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.photo_camera_back,
                  color: Color(0x6D000000),
                  size: 30,
                ),
              ),
              Material(
                  //Wrap with Material
                  shape: const CircleBorder(),
                  color: const Color(0xFF8B8B8B),
                  child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: MaterialButton(
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        onPressed: widget.onCamera,
                        color: Colors.white.withAlpha(230),
                        padding: const EdgeInsets.all(20),
                        shape: const CircleBorder(),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                        ),
                      ))),
              MaterialButton(
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                onPressed: widget.onChange,
                color: const Color(0x2D909090),
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.sync,
                  color: Color(0x6D000000),
                  size: 30,
                ),
              ),
            ],
          ),
        ));
  }
}
