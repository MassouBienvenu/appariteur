import 'package:appariteur/controllers/profile/profileimgedit.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../data/apihelper.dart';
import 'editprofile.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    getStoredUserData();
  }

  Future<void> getStoredUserData() async {
    var fetchedUserData = await AuthApi.getOnlineUserData();
    if (fetchedUserData != null) {
      setState(() {
        userData = fetchedUserData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Mon compte")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ProfileImgEditing(),
              SizedBox(height: 10),
              buildProfileCard(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(userData: userData!),
                    ),
                  );
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Nom: ${userData?.name ?? ''}"),
            Text("Email: ${userData?.email ?? ''}"),
Text("Téléphone: ${userData?.tel ?? ''}"),
            Text("Sexe: ${userData?.sexe ?? ''}"),
            Text("Adresse: ${userData?.adresse ?? ''}"),
            Text("Date de naissance: ${userData?.datenais ?? ''}"),
            Text("Lieu de naissance: ${userData?.lieunais ?? ''}"),
            Text("Rue: ${userData?.rue ?? ''}"),
            Text("Code postal: ${userData?.codepostal ?? ''}"),
            Text("Ville: ${userData?.ville ?? ''}"),
            Text("Pays: ${userData?.pays ?? ''}"),
            Text("Niveau: ${userData?.niveau ?? ''}"),
            Text("User: ${userData?.user ?? ''}"),

          ],
        ),
      ),
    );
  }
}
