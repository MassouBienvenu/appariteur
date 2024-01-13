import 'package:appariteur/views/widgets/addonglobal/topbar.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../data/apihelper.dart';

class EditProfilePage extends StatefulWidget {
  final UserData userData;

  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController telController;
  late TextEditingController sexeController;
  late TextEditingController imageController;
  late TextEditingController adresseController;
  late TextEditingController datenaisController;
  late TextEditingController lieunaisController;
  late TextEditingController rueController;
  late TextEditingController codepostalController;
  late TextEditingController villeController;
  late TextEditingController paysController;
  late TextEditingController niveauController;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData.name);
    emailController = TextEditingController(text: widget.userData.email);
     telController = TextEditingController(text: widget.userData.tel);
    sexeController = TextEditingController(text: widget.userData.sexe);
    imageController = TextEditingController(text: widget.userData.image);
    adresseController = TextEditingController(text: widget.userData.adresse);
    datenaisController = TextEditingController(text: widget.userData.datenais);
    lieunaisController = TextEditingController(text: widget.userData.lieunais);
    rueController = TextEditingController(text: widget.userData.rue);
    codepostalController = TextEditingController(text: widget.userData.codepostal);
    villeController = TextEditingController(text: widget.userData.ville);
    paysController = TextEditingController(text: widget.userData.pays);
    niveauController = TextEditingController(text: widget.userData.niveau);


  }

  void updateProfile() async {
    UserData updatedUserData = widget.userData.copyWith(
      name: nameController.text,
      email: emailController.text,
tel: telController.text,
      sexe: sexeController.text,
      image: imageController.text,
      adresse: adresseController.text,
      datenais: datenaisController.text,
      lieunais: lieunaisController.text,
      rue: rueController.text,
      codepostal: codepostalController.text,
      ville: villeController.text,
      pays: paysController.text,
      niveau: niveauController.text,
    );

    bool? success = await AuthApi.updateProfile(updatedUserData);
    if (success == true) {
      Navigator.pop(context);
    } else {
 print("Erreur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarS(
        title: Text("Modifier le Profil"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: telController,
                decoration: InputDecoration(labelText: 'Téléphone'),
              ),
              TextFormField(
                controller: sexeController,
                decoration: InputDecoration(labelText: 'Sexe'),
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image'),
              ),
              TextFormField(
                controller: adresseController,
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
              TextFormField(
                controller: datenaisController,
                decoration: InputDecoration(labelText: 'Date de naissance'),
              ),
              TextFormField(
                controller: lieunaisController,
                decoration: InputDecoration(labelText: 'Lieu de naissance'),
              ),
              TextFormField(
                controller: rueController,
                decoration: InputDecoration(labelText: 'Rue'),
              ),
              TextFormField(
                controller: codepostalController,
                decoration: InputDecoration(labelText: 'Code postal'),
              ),
              TextFormField(
                controller: villeController,
                decoration: InputDecoration(labelText: 'Ville'),
              ),
              TextFormField(
                controller: paysController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
              TextFormField(
                controller: niveauController,
                decoration: InputDecoration(labelText: 'Niveau'),
              ),

              ElevatedButton(
                onPressed: updateProfile,
                child: Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
