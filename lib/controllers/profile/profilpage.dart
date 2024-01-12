import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/apihelper.dart';
import '../../models/user.dart';
import 'package:appariteur/controllers/profile/profileimgedit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? userData;
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController lieuxPlaceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStoredUserData();
  }

  Future<void> getStoredUserData() async {
    var fetchedUserData = await AuthApi.getOnlineUserData();
    if (fetchedUserData != null) {
      print("Données récupérées : ${fetchedUserData.toJson()}");
      setState(() {
        userData = fetchedUserData;
        nameController.text = fetchedUserData.name ?? '';
        emailController.text = fetchedUserData.email ?? '';
        genderController.text = fetchedUserData.sexe ?? '';
        phoneNumberController.text = fetchedUserData.tel ?? '';
        birthDateController.text = fetchedUserData.datenais ?? '';
        lieuxPlaceController.text = fetchedUserData.lieunais ?? '';
        addressController.text = fetchedUserData.rue ?? '';
        postalCodeController.text = fetchedUserData.codepostal ?? '';
        countryController.text = fetchedUserData.pays ?? '';
      });
    } else {
      print("Aucune donnée utilisateur récupérée");
    }
  }

  void updateProfile() async {
    if (isEditing) {
      UserData updatedUserData = UserData(
        userId: userData!.userId,
        appariteurId: userData!.appariteurId,
        name: nameController.text,
        email: emailController.text,
        tel: phoneNumberController.text,
        sexe: genderController.text,
        image: userData!.image,
        adresse: addressController.text,
        datenais: birthDateController.text,
        lieunais: lieuxPlaceController.text,
        rue: addressController.text,
        codepostal: postalCodeController.text,
        ville: countryController.text,
        pays: countryController.text,
        niveau: userData!.niveau,
        user: userData!.user,
        token: userData!.token,
      );

      bool? success = await AuthApi.updateProfile(updatedUserData);
      if (success == true) {
        showToast('Profil mis à jour avec succès');
        await saveUpdatedDataToSharedPreferences(updatedUserData);
        await getStoredUserData(); // Rafraîchir l'affichage des données
      } else {
        showToast('Échec de la mise à jour du profil');
      }

      setState(() {
        isEditing = false;
      });
    }
  }

  Future<void> saveUpdatedDataToSharedPreferences(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userData.userId ?? '');
    await prefs.setString('appariteurId', userData.appariteurId ?? '');
    await prefs.setString('name', userData.name ?? '');
    await prefs.setString('email', userData.email ?? '');
    await prefs.setString('tel', userData.tel ?? '');
    await prefs.setString('sexe', userData.sexe ?? '');
    await prefs.setString('image', userData.image ?? '');
    await prefs.setString('adresse', userData.adresse ?? '');
    await prefs.setString('datenais', userData.datenais ?? '');
    await prefs.setString('lieunais', userData.lieunais ?? '');
    await prefs.setString('rue', userData.rue ?? '');
    await prefs.setString('codepostal', userData.codepostal ?? '');
    await prefs.setString('ville', userData.ville ?? '');
    await prefs.setString('pays', userData.pays ?? '');
    await prefs.setString('niveau', userData.niveau ?? '');
    await prefs.setString('user', userData.user ?? '');
    // Le token, s'il est null, ne devrait pas être mis à jour dans SharedPreferences
  }


  void showToast(String message) {
     final snackBar = SnackBar(content: Text(message));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Center(
          child: Text(
            "Mon compte",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
// Implémenter l'action ici
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10),
              const ProfileImgEditing(),
              const SizedBox(height: 10),
              buildProfileCard(),
              const SizedBox(height: 20),
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Card buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            buildTextField(nameController, "Nom", isEditing),
            buildTextField(emailController, "Email", isEditing),
            buildTextField(genderController, "Sexe", isEditing),
            buildTextField(phoneNumberController, "Téléphone", isEditing),
            buildTextField(birthDateController, "Date de naissance", isEditing),
            buildTextField(lieuxPlaceController, "Lieu de naissance", isEditing),
            buildTextField(addressController, "Adresse", isEditing),
            buildTextField(postalCodeController, "Code postal", isEditing),
            buildTextField(countryController, "Pays", isEditing),
          ],
        ),
      ),
    );
  }

  Row buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
          child: Text(isEditing ? 'Enregistrer' : 'Modifier'),
        ),
      ],
    );
  }

  TextFormField buildTextField(TextEditingController controller, String label, bool isEditable) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: !isEditable,
    );
  }
}

