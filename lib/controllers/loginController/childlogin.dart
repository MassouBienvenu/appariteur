import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/apihelper.dart';
import '../../helper/routes/routes.dart';
import '../../views/notif/notifScreen.dart';
import '../../views/widgets/InputDecoration.dart';
import '../../views/widgets/addonglobal/bottombar.dart';
import '../../views/widgets/custom snack_bar.dart';
import '../../views/widgets/images.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  bool isLoading = false;
  void _showUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actuellement Indisponible'))
    );
  }
  void _launchURL() async {
    const url = 'https://www.appariteur.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> _login() async {
    var email = emailController.text.trim();
    var password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var userData = await AuthApi.login(email, password);
      if (userData != null) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyBottomNav())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Identifiants incorrects ou problème de connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la connexion: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration:  BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg appariteur app.jpg"), fit:
        BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              100.height,
              Text(
                  "Se connecter", style: boldTextStyle(size: 24, color: black)),
              Container(
                margin: EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      margin: EdgeInsets.only(top: 55.0),
                      decoration: boxDecorationWithShadow(
                          borderRadius: BorderRadius.circular(30),
                          backgroundColor: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                50.height,

                                // Email TextField
                                AppTextField(
                                  decoration: coInputDecoration(
                                      hint: 'Entrer votre email',
                                      context: context,
                                      prefixIcon: Icons.email_outlined),
                                  textFieldType: TextFieldType.EMAIL,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  focus: emailFocusNode,
                                  nextFocus: passWordFocusNode,
                                ),
                                16.height,

                                // Password TextField
                                AppTextField(
                                  decoration: coInputDecoration(
                                      context: context,
                                      hint: 'Entrer votre mot de passe',
                                      prefixIcon: Icons.lock_outline),
                                  suffixIconColor: Theme
                                      .of(context)
                                      .primaryColor,
                                  textFieldType: TextFieldType.PASSWORD,
                                  isPassword: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  focus: passWordFocusNode,
                                ),
                                30.height,

                                // Login Button
                                isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : AppButton(
                                  text: "Se connecter",
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  textColor: Colors.white,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  onTap: _login,
                                ).paddingOnly(
                                    left: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.1,
                                    right: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.1),
                                30.height,

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Vous n\'avez pas de compte?',
                                        style: primaryTextStyle(
                                            color: Colors.grey)),
                                    3.width,
                                    Flexible(
                                      child: Text('Inscrivez-vous ',
                                          textAlign: TextAlign.center,
                                          style: boldTextStyle(color: Colors.black)),


                                ).onTap(() {
                                  _showUnavailableMessage();
                                }).center(),
                                  ],
                                ).onTap(() {
                                  Get.toNamed(RouteHelper.getSignUpRoute());
                                }).center(),
                                20.height,

                              ]
                          ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      decoration: boxDecorationRoundedWithShadow(30,
                          backgroundColor: context.cardColor),
                      child: Image.asset(
                        Images.logo,
                        height: 50,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              16.height,
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextButton(
                    onPressed: _launchURL,
                    child: Text(
                      "Découvrir Appariteur",
                      style: GoogleFonts.merienda(
                        fontSize: 25, // Ajustez la taille selon vos préférences
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}