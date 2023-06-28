import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/widgets.dart';
import 'package:internship_practice/core/functions/app_dialogs.dart';
import 'package:internship_practice/core/utils/strings_manager.dart';
import 'package:internship_practice/features/profile/domain/entities/user_profile_entity.dart';
import 'package:internship_practice/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:internship_practice/features/profile/presentation/widgets/change_profile_picture_widget.dart';
import 'package:internship_practice/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:internship_practice/injection_container.dart';

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
  late ProfileBloc _profileBloc;
  final _form = GlobalKey<FormState>();
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
    _ageController = TextEditingController(text: widget.age);
    _instagramController = TextEditingController(text: widget.instagram);
    _locationController = TextEditingController(text: widget.location);
    _profileBloc = sl<ProfileBloc>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _instagramController.dispose();
    _locationController.dispose();
    _profileBloc.close();
    super.dispose();
  }

  Future<void> getImage({required bool isFromGallery}) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
        source:
            isFromGallery == true ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 60,
      );
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
          child: BlocProvider(
            create: (context) => _profileBloc,
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
                          context.router.pop();
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
                          buttonText: AppStrings.save,
                          onPress: () async {
                            bool result =
                                await InternetConnectionChecker().hasConnection;
                            if (result == false) {
                              // if there is no internet connection
                              AppDialogs.showAlertDialog(
                                context: context,
                                title: const Text("No Internet Connection"),
                                content: const Text(
                                    "Please check your device connection."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            } else {
                              _form.currentState!.save();
                              if (_form.currentState!.validate()) {
                                if (mounted) {
                                  if (pickedImage != null) {
                                    _editProfile(
                                      context,
                                      currentUserEmail: currentUserEmail!,
                                      image: pickedImage,
                                    );
                                  } else {
                                    _editProfile(
                                      context,
                                      currentUserEmail: currentUserEmail!,
                                    );
                                  }
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    ChangeProfilePictureWidget(
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: const Text("Choose an action"),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    getImage(isFromGallery: true);
                                  },
                                  child: const Chip(
                                    label: Text("Image"),
                                    avatar: Icon(Icons.photo_album),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    getImage(isFromGallery: false);
                                  },
                                  child: const Chip(
                                    label: Text("Camera"),
                                    avatar: Icon(Icons.camera_alt_outlined),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      backgroundImage: pickedImage == null
                          ? NetworkImage(widget.photoUrl)
                          : Image.file(File(pickedImage!.path)).image,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    CustomTextField(
                      heading: AppStrings.name,
                      hintText: AppStrings.name,
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
                            heading: AppStrings.age,
                            hintText: "00",
                            textInputType: TextInputType.number,
                            controller: _ageController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required";
                              }
                              if (value.length > 2) {
                                return "Incorrect Length";
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
                            heading: AppStrings.instagram,
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
                      heading: AppStrings.location,
                      hintText: AppStrings.location,
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
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editProfile(
    BuildContext context, {
    required String currentUserEmail,
    XFile? image,
  }) {
    context.read<ProfileBloc>().add(
          EditProfileEvent(
            userProfileEntity: UserProfileEntity(
              username: _nameController.text.trim(),
              email: currentUserEmail,
              age: _ageController.text.trim(),
              instagram: _instagramController.text.trim(),
              location: _locationController.text.trim(),
              image: image,
            ),
          ),
        );
  }
}
