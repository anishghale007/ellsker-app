import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final String photoUrl;
  final String username;
  final String instagram;
  final String location;
  final String age;

  const EditProfileScreen({
    Key? key,
    required this.photoUrl,
    required this.username,
    required this.instagram,
    required this.location,
    required this.age,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _instagramController;
  late TextEditingController _locationController;
  final _form = GlobalKey<FormState>();
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _ageController = TextEditingController(text: widget.age);
    _instagramController = TextEditingController(text: widget.instagram);
    _locationController = TextEditingController(text: widget.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _instagramController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileEditSuccess) {
                        Navigator.of(context).pop();
                      } else if (state is ProfileError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage.toString()),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ProfileHeader(
                        buttonText: "Save",
                        onPress: () {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            if (pickedImage != null) {
                              context.read<ProfileBloc>().add(
                                    EditProfileEvent(
                                      userProfileEntity: UserProfileEntity(
                                        username: _nameController.text.trim(),
                                        email: currentUserEmail!,
                                        age: _ageController.text.trim(),
                                        instagram:
                                            _instagramController.text.trim(),
                                        location:
                                            _locationController.text.trim(),
                                        image: pickedImage,
                                      ),
                                    ),
                                  );
                            } else {
                              context.read<ProfileBloc>().add(
                                    EditProfileEvent(
                                      userProfileEntity: UserProfileEntity(
                                        username: _nameController.text.trim(),
                                        email: currentUserEmail!,
                                        age: _ageController.text.trim(),
                                        instagram:
                                            _instagramController.text.trim(),
                                        location:
                                            _locationController.text.trim(),
                                      ),
                                    ),
                                  );
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff666A83),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: pickedImage == null
                            ? NetworkImage(widget.photoUrl)
                            : Image.file(File(pickedImage!.path)).image,
                        radius: 80,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        ColorUtil.kMessageAlertColor,
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  CustomTextField(
                    heading: "Name",
                    hintText: "Name",
                    textInputType: TextInputType.name,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomTextField(
                          heading: "Age",
                          hintText: "00",
                          textInputType: TextInputType.number,
                          controller: _ageController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Age is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        flex: 5,
                        child: CustomTextField(
                          heading: "Instagram",
                          hintText: "@instagram",
                          textInputType: TextInputType.emailAddress,
                          controller: _instagramController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Instagram is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    heading: "Location",
                    hintText: "Location",
                    textInputType: TextInputType.text,
                    controller: _locationController,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Location is required";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
