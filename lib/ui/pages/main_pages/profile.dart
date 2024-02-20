import 'package:flutter/material.dart';
import 'package:watch_out/backend/firebase/personal_infos.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/models/user.dart';
import 'package:watch_out/ui/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PersonalInfos().getCurrentPersonalInfos(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return profileWidget(snapshot.data!);
          } else {
            return Scaffold(
              backgroundColor: Palette.mainPage,
              body: const Center(
                child: Text("Something went wrong. Please try again"),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Palette.mainPage,
            body: const Center(
              child: Text("Something went wrong. Please try again"),
            ),
          );
        } else {
          return Container(
            color: Palette.mainPage,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Palette.lightGreen,
            ),
          );
        }
      },
    );
  }

  Widget profileWidget(Map<String, dynamic> data) {
    User user = User.fromMap(data);
    return Scaffold(
      backgroundColor: Palette.mainPage,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 20,
              bottom: 10,
            ),
            width: MediaQuery.of(context).size.width - 30,
            height: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_profile.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 50,
                  child: user.profilePhotoUrl == ""
                      ? const Icon(Icons.person)
                      : Image.network(user.profilePhotoUrl),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Palette.mainPage,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "About",
              style: TextStyle(
                color: Palette.darkGreen,
                fontSize: Font.reportsFontSize,
              ),
            ),
          ),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.only(left: 20, top: 10),
            margin: const EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Palette.mainLightGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileInfo("Email Adress", user.email),
                profileInfo("Phone Number", user.phone),
                profileInfo("Gender", user.gender),
                profileInfo("Emergency Contacts", "")
              ],
            ),
          ),
          CustomButton(
            onPressed: () {},
            text: "Edit Profile",
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.only(top: 10),
            height: 10,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget profileInfo(String field, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
