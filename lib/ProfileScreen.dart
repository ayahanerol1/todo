import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _userProfile;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final String cacheKey = "profile_settings";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? objStr = prefs.getString(cacheKey);

    if (objStr == null) {
      _userProfile = UserProfile(fullName: "", age: -1, email: "");
    } else {
      var map = jsonDecode(objStr);
      _userProfile = UserProfile.fromJson(map);
    }

    updateControllers();
  }
   void updateControllers(){
    _ageController.text = _userProfile.age.toString();
    _emailController.text = _userProfile.email;
    _fullNameController.text = _userProfile.fullName;
   }
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> map = _userProfile.toJson();

    String json = jsonEncode(map);

    prefs.setString(cacheKey, json);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 162, 255),
      appBar: AppBar(
        title: const Text('Ana Menü'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Kişisel Bilgileriniz",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _fullNameController,
              onChanged: (value) {
                  _userProfile.fullName = value;
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelText: "Ad Soyad",
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _ageController,
              onChanged: (value) {
                _userProfile.age = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelText: "Yaş",
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              onChanged: (value) {
                _userProfile.email = value;
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelText: "E-Posta",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _saveProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil kaydedildi!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                print(_userProfile.toJson());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Kaydet",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
