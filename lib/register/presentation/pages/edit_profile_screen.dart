import 'package:flutter/material.dart';
import 'package:internship_practice/colors_utils.dart';
import 'package:internship_practice/common/widgets/custom_textField_widget.dart';
import 'package:internship_practice/common/widgets/profile_header_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                ProfileHeader(
                  buttonText: "Save",
                  onPress: () {
                    Navigator.of(context).pop();
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
                      backgroundImage: const AssetImage(
                        "assets/images/profile_picture.png",
                      ),
                      radius: 80,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
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
                                backgroundColor: ColorUtil.kMessageAlertColor,
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
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
                const CustomTextField(
                  heading: "Name",
                  hintText: "Name",
                  textInputType: TextInputType.name,
                ),
                Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        heading: "Age",
                        hintText: "00",
                        textInputType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        heading: "Instagram",
                        hintText: "@seuarroba",
                        textInputType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
                const CustomTextField(
                  heading: "Location",
                  hintText: "Location",
                  textInputType: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
