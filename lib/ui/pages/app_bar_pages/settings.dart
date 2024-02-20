import 'package:flutter/material.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.mainPage,
      appBar: AppBar(
        backgroundColor: Palette.mainPage,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Palette.mainPageTitle,
            fontSize: Font.createAccountFontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(
              "Account",
              const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            subCategories([
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Notifications",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Privacy and data",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Delete my account",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AuthService().signOut(context),
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
            header(
              "Language",
              const Icon(
                Icons.language,
                color: Colors.white,
              ),
            ),
            subCategories([
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Select Language",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
            header(
              "Security and Support",
              const Icon(
                Icons.security,
                color: Colors.white,
              ),
            ),
            subCategories([
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See Terms of Service",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See Privacy and Policy",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Contact us",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget header(String title, Icon icon) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      decoration: BoxDecoration(
        color: Palette.lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: Font.reportsFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget subCategories(List<Widget> children) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.only(left: 20, top: 10),
      margin: EdgeInsets.only(left: 15),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Palette.mainLightGreen,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
