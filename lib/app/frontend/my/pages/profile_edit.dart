import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minima/app/backend/cdn/cdn.dart';
import 'package:minima/app/frontend/my/widgets/profile_picture.dart';
import 'package:minima/app/models/auth/profile.dart';
import 'package:minima/shared/widgets/button.dart';
import 'package:minima/shared/widgets/open_image.dart';
import 'package:minima/shared/widgets/page.dart';
import 'package:minima/shared/widgets/textfield.dart';

class ProfileEditPage extends StatefulWidget {
  final ProfileData profile;

  const ProfileEditPage({super.key, required this.profile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  File? _image;

  void onPicture() {
    showOpenImageMenu(context, (image) {
      if (image == null) return;
      setState(() {
        _image = image;
      });
    });
  }

  void onDone() {}

  @override
  void initState() {
    _nameController.text = widget.profile.nickname;
    super.initState();
  }

  Widget buildProfilePicture() {
    return _image != null
        ? Image.file(
            _image!,
            fit: BoxFit.cover,
          )
        : widget.profile.picture == null
            ? SvgPicture.asset('assets/images/icons/profile.svg')
            : CDN.image(id: widget.profile.picture);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        title: '프로필',
        child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: onPicture,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                            width: 140,
                            height: 140,
                            child: ClipOval(
                              child: buildProfilePicture(),
                            )),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 22,
                              color: Color(0xFFCBCFD6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  controller: _nameController,
                  title: '닉네임',
                ),
                const Spacer(),
                PrimaryButton(
                    borderRadius: 14,
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    onPressed: onDone,
                    child: const Text(
                      '저장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ))
              ],
            )));
  }
}
