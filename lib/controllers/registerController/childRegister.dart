import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/apihelper.dart';
import '../../helper/routes/routes.dart';
import '../../models/user.dart';
import '../../views/notif/notifScreen.dart';
import '../../views/widgets/InputDecoration.dart';
import '../../views/widgets/addonglobal/bottombar.dart';
import '../../views/widgets/images.dart';
import '../loginController/childlogin.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var sexeController = TextEditingController();
  var birthdateController = TextEditingController();
  var birthplaceController = TextEditingController();
  var streetController = TextEditingController();
  var postalCodeController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode sexeFocusNode = FocusNode();
  FocusNode birthdateFocusNode = FocusNode();
  FocusNode birthplaceFocusNode = FocusNode();
  FocusNode streetFocusNode = FocusNode();
  FocusNode postalCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  bool isLoading = false;

  String selectedGender = "Masculin"; // Valeur par défaut pour le champ de sexe

  Future<void> _signUp() async {
    var name = nameController.text.trim();
    var email = emailController.text.trim();
    var password = passwordController.text.trim();
    var phone = phoneController.text.trim();
    var sexe = selectedGender;
    var birthdate = birthdateController.text.trim();
    var birthplace = birthplaceController.text.trim();
    var street = streetController.text.trim();
    var postalCode = postalCodeController.text.trim();
    var city = cityController.text.trim();
    var country = "France";

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        sexe.isEmpty ||
        birthdate.isEmpty ||
        birthplace.isEmpty ||
        street.isEmpty ||
        postalCode.isEmpty ||
        city.isEmpty ||
        country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var userData = UserData(
        name: name,
        email: email,
        password: password,
        tel: phone,
        sexe: sexe,
        datenais: birthdate,
        lieunais: birthplace,
        rue: street,
        codepostal: postalCode,
        ville: city,
        pays: country,
      );
      bool? success = await AuthApi.signUp(userData);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inscription réussie!')),
        );

        await Future.delayed(Duration(seconds: 2));
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: _w,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg appariteur app.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 100),
              Text("S'inscrire", style: boldTextStyle(size: 24, color: black)),
              SingleChildScrollView(
                child: Container(
                  width: 1200, // Largeur fixe pour le contenu scrollable
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            margin: EdgeInsets.only(top: 55.0),
                            decoration: boxDecorationWithShadow(
                              borderRadius: BorderRadius.circular(30),
                              backgroundColor: context.cardColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 80),
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer vos noms et prénoms',
                                    context: context,
                                    prefixIcon: Icons.person_outline,
                                  ),
                                  textFieldType: TextFieldType.NAME,
                                  keyboardType: TextInputType.text,
                                  controller: nameController,
                                  focus: nameFocusNode,
                                  nextFocus: emailFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre adresse mail',
                                    context: context,
                                    prefixIcon: Icons.mail_outline,
                                  ),
                                  textFieldType: TextFieldType.EMAIL,
                                  keyboardType: TextInputType.text,
                                  controller: emailController,
                                  focus: emailFocusNode,
                                  nextFocus: phoneFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre numéro de téléphone',
                                    context: context,
                                    prefixIcon: Icons.phone_outlined,
                                  ),
                                  textFieldType: TextFieldType.NUMBER,
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
                                  focus: phoneFocusNode,
                                  nextFocus: sexeFocusNode,
                                ),
                                16.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sexe',
                                      style: primaryTextStyle(),
                                    ).paddingOnly(right: 16),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 'Masculin',
                                          groupValue: selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedGender = value.toString();
                                            });
                                          },
                                        ),
                                        Text('Masculin', style: primaryTextStyle()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 'Féminin',
                                          groupValue: selectedGender,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedGender = value.toString();
                                            });
                                          },
                                        ),
                                        Text('Féminin', style: primaryTextStyle()),
                                      ],
                                    ),
                                  ],
                                ),
                                16.height,
                                // Ajoutez ici les autres champs de texte pour les informations requises
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre mot de passe',
                                    context: context,
                                    prefixIcon: Icons.lock_clock_outlined,
                                  ),
                                  textFieldType: TextFieldType.PASSWORD,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  focus: passwordFocusNode,
                                  nextFocus: passwordFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Confirmation de votre mot de passe',
                                    context: context,
                                    prefixIcon: Icons.lock_clock_outlined,
                                  ),
                                  textFieldType: TextFieldType.PASSWORD,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  focus: passwordFocusNode,
                                  nextFocus: passwordFocusNode,
                                ),
                                16.height,
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );

                                    if (selectedDate != null && selectedDate != DateTime.now()) {
                                      String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                      birthdateController.text = formattedDate;
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: AppTextField(
                                      decoration: coInputDecoration(
                                        hint: 'Choisir la date de naissance',
                                        context: context,
                                        prefixIcon: Icons.calendar_today,
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: birthdateController,
                                      focus: birthdateFocusNode,
                                      nextFocus: birthplaceFocusNode, textFieldType: TextFieldType.OTHER,
                                    ),
                                  ),
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre lieu de naissance',
                                    context: context,
                                    prefixIcon: Icons.place_outlined,
                                  ),
                                  textFieldType: TextFieldType.NAME,
                                  keyboardType: TextInputType.text,
                                  controller: birthplaceController,
                                  focus: birthplaceFocusNode,
                                  nextFocus: streetFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre rue',
                                    context: context,
                                    prefixIcon: Icons.streetview_outlined
                                  ),
                                  textFieldType: TextFieldType.NAME,
                                  keyboardType: TextInputType.text,
                                  controller: streetController,
                                  focus: streetFocusNode,
                                  nextFocus: cityFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre ville de résidence',
                                    context: context,
                                    prefixIcon: Icons.location_city_outlined,
                                  ),
                                  textFieldType: TextFieldType.NAME,
                                  keyboardType: TextInputType.text,
                                  controller: cityController,
                                  focus: cityFocusNode,
                                  nextFocus: countryFocusNode,
                                ),
                                16.height,
                                AppTextField(
                                  decoration: coInputDecoration(
                                    hint: 'Entrer votre pays de résidence',
                                    context: context,
                                    prefixIcon: Icons.location_searching_outlined,
                                  ),
                                  textFieldType: TextFieldType.NAME,
                                  keyboardType: TextInputType.text,
                                  controller: countryController,
                                  focus: countryFocusNode,
                                ),
                                16.height,
                                30.height,
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : AppButton(
                                  text: "S'inscrire",
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  width: _w,
                                  onTap: _signUp,
                                ).paddingOnly(
                                  left: _w * 0.1,
                                  right: _w * 0.1,
                                ),
                                30.height,
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: 100,
                            decoration: boxDecorationRoundedWithShadow(30, backgroundColor: context.cardColor),
                            child: Image.asset(
                              Images.logo,
                              height: 50,
                              width: 80,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
