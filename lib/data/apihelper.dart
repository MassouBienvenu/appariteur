// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contrat.dart';
import '../models/disponibilites.dart';
import '../models/fichepaie.dart';
import '../models/missionuser.dart';
import '../models/planning.dart';
import '../models/user.dart';
import '../models/userdoc.dart';
import '../models/userinfo.dart';


class AuthApi {
  static UserData? _loggedUserData;
  static String? tokenVar;

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<UserData?> login(String email, String password) async {
    try {
      const url = 'https://appariteur.com/api/users/login.php';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailUser': email, 'passwordUser': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final userData = data['data'];
          tokenVar = data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Enregistrer le token, userId et appariteurId en vérifiant leur non-nullité
          if (tokenVar != null) {
            prefs.setString('token', tokenVar!);
          }
          if (userData['user_id'] != null) {
            prefs.setString('userId', userData['user_id']);
          }
          if (userData['appariteur_id'] != null) {
            prefs.setString('appariteurId', userData['appariteur_id']);
          }

          // Gérer les autres champs
          userData.forEach((key, value) {
            if (value != null && key != 'user_id' && key != 'appariteur_id' && key != 'token') {
              prefs.setString(key, value.toString());
            }
          });

          // Création de l'objet UserData avec des vérifications pour les champs nullables
          return UserData(
            userId: userData['user_id'],
            appariteurId: userData['appariteur_id'],
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            tel: userData['tel'] ?? '',
            sexe: userData['sexe'] ?? '',
            image: userData['image'] ?? '',
            adresse: userData['adresse'] ?? '',
            datenais: userData['datenais'] ?? '',
            lieunais: userData['lieunais'] ?? '',
            rue: userData['rue'] ?? '',
            codepostal: userData['codepostal'] ?? '',
            ville: userData['ville'] ?? '',
            pays: userData['pays'] ?? '',
            niveau: userData['niveau'] ?? '',
            user: userData['user'] ?? '',
            token: prefs.getString('token'),
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API : $e');
    }
    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<UserData?> getLocalUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) return null; // Si l'utilisateur n'est pas connecté

    return UserData(
      userId: userId,
      appariteurId: prefs.getString('appariteurId') ?? '',
      name: prefs.getString('name') ?? '',
      email: prefs.getString('email') ?? '',
      tel: prefs.getString('tel') ?? '',
      sexe: prefs.getString('sexe') ?? '',
      image: prefs.getString('image') ?? '',
      adresse: prefs.getString('adresse') ?? '',
      datenais: prefs.getString('datenais') ?? '',
      lieunais: prefs.getString('lieunais') ?? '',
      rue: prefs.getString('rue') ?? '',
      codepostal: prefs.getString('codepostal') ?? '',
      ville: prefs.getString('ville') ?? '',
      pays: prefs.getString('pays') ?? '',
      niveau: prefs.getString('niveau') ?? '', 
      user:prefs.getString('user') ?? '',
      
    );
  }
  static Future<UserData?> getOnlineUserData() async {

    final token = await getToken();
    if (token == null) return null;

    const url = 'https://appariteur.com/api/users/profile.php';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final userData = data['data'];
          // Mettre à jour les SharedPreferences ici
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userData.forEach((key, value) {
            if (value != null) {
              prefs.setString(key, value.toString());
            }
          });
          return UserData.fromJson(userData);
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des données de l\'utilisateur : $e');
    }
    return null;
  }

  static Future<bool?> updateProfile(UserData userData) async {
    final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return null;
    }
    const url = 'https://appariteur.com/api/users/profile.php';
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Assuming tokenVar is your authToken
        },
        body: jsonEncode({
          'userId': userData.userId,
          'appariteurId': userData.appariteurId,
          'name': userData.name,
          'email': userData.email,
          'tel': userData.tel,
          'sexe': userData.sexe,
          'image': userData.image,
          'adresse': userData.adresse,
          'datenais': userData.datenais,
          'lieunais': userData.lieunais,
          'rue': userData.rue,
          'codepostal': userData.codepostal,
          'ville': userData.ville,
          'pays': userData.pays,
          'niveau': userData.niveau,
          'user': userData.user,

        }),
      );

      if (response.statusCode == 200) {
        // Check for success response and act accordingly
        var responseData = json.decode(response.body);
        if (responseData['success']) {
          // Handle successful profile update
          print('Profile updated successfully!');
          return true;
        }
      }
      // Handle error or unsuccessful update
      print('Failed to update profile: ${response.body}');
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
  static UserData? getLoggedUserData() {
    return _loggedUserData;
  }
  static Future<UserInfo?> InfoUser() async {
    final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return null;
    }
    const url = 'https://appariteur.com/api/users/infos_g.php';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> userData = responseData['data'];

      final String? heureWeek = userData['heure_week'];
      final String? heureMonth = userData['heure_month'];
      final String? heureYear = userData['heure_year'];



      final String effeMis = userData['effe_mis'];

      final UserInfo userInfo = UserInfo(
        heureWeek: heureWeek,
        heureMonth: heureMonth,
        heureYear: heureYear,
        effeMis: effeMis,

      );
      print(userInfo);
      return userInfo;
      // Retourne les informations utilisateur
    } catch (e) {
      print('Erreur de décodage JSON : $e');
      return null; // Retourne null en cas d'erreur de décodage JSON
    }
  }



  static Future<List<UserDoc>?> getUserDocuments() async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }
      final response = await http.get(
        Uri.parse('https://appariteur.com/api/users/document.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> documentsData = jsonDecode(response.body)['data'];

        final List<UserDoc> documentsList =
        documentsData.map((data) => UserDoc.fromJson(data)).toList();

        return documentsList;
      }
    } catch (e) {
      print('Erreur lors de la récupération des documents : $e');
    }

    return null;
  }


  static Future<MissionEffUserResult?> getMissionsEffectuees(String dateStart, String dateEnd) async {
    const endpoint = 'https://appariteur.com/api/users/missioneffectuee.php';

    try { final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return null;
    }

      // Construct the query parameters
      final queryParameters = {
        'date_start': dateStart,
        'date_end': dateEnd,
      };

      final uri = Uri.parse(endpoint).replace(queryParameters: queryParameters);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result']['success'] == true) {
          List<Mission> missions = [];
          for (var missionData in data['result']['data']) {
            missions.add(Mission.fromJson(missionData)); // Assuming you have a Mission.fromJson() constructor
          }
          String totalHours = data['result']['total_heure'];
          return MissionEffUserResult(missions: missions, totalHours: totalHours);
        } else {
          // Handle the case where success is not true
          print("API returned success false");
        }
      } else {
        // Handle HTTP error
        print("Failed to load missions. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors in the API call
      print('Error fetching mission data: $e');
    }

    return null; // Return null in case of error or no data
  }
  static Future<List<FichePaie>?> getFichesPaie() async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }
      const url = 'https://appariteur.com/api/users/fichepaie.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var fichesPaieData = json.decode(utf8.decode(response.bodyBytes));

        if (fichesPaieData['success'] == true) {
          final List<dynamic> fichesPaieInfo = fichesPaieData['data'];

          if (fichesPaieInfo.isEmpty) {
            // Aucune fiche de paie à afficher
            return null;
          }

          final List<FichePaie> fichesPaieList = fichesPaieInfo.map((ficheData) {
            return FichePaie(
              id: ficheData['id'],
              mois: ficheData['mois'],
              annee: ficheData['annee'],
              fichier: ficheData['fichier'],
              dateCreate: ficheData['Datecreate'],
            );
          }).toList();

          print(fichesPaieList); // Vous pouvez imprimer les fichesPaieList ici si nécessaire
          return fichesPaieList;
        }
      } else {
        print('Erreur HTTP lors de la récupération des fiches de paie. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les fiches de paie : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<List<Planning>?> getPlanningData() async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }

      const url = 'https://appariteur.com/api/users/planning.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> planningData = jsonDecode(response.body);

        if (planningData.isNotEmpty) {
          final List<Planning> eventsList = planningData.map((eventData) {
            return Planning.fromJson(eventData);
          }).toList();
          print(eventsList);
          return eventsList;
        } else {
          print('Planning data is empty');
          return <Planning>[];
        }
      } else {
        print('Failed to fetch planning data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching planning data: $e');
    }

    return null;
  }
  static Future<List<Contrat>?> getContrats() async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }

      const url = 'https://appariteur.com/api/users/contrat.php';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var contratsData = json.decode(utf8.decode(response.bodyBytes));

        if (contratsData['success'] == true) {
          final List<dynamic> contratsInfo = contratsData['data'];

          if (contratsInfo.isEmpty) {
            // Aucun contrat à afficher
            return null;
          }

          final List<Contrat> contratsList = contratsInfo.map((contratData) {
            return Contrat(
              idContratApp: contratData['Id_contrat_app'],
              appariteurId: contratData['appariteur_id'],
              typeContrat: contratData['TypeContrat'],
              dateEmbauche: contratData['DateEmbauche'],
              dateFinContrat: contratData['DateFinContrat'],
              dateEdition: contratData['DateEdition'],
              disponibilite: contratData['Disponibilite'],
              nbrHeure: contratData['nbr_heure'],
              montantHeure: contratData['montant_heure'],
              nameFichier: contratData['name_fichier'],
            );
          }).toList();

          print(contratsList); // Vous pouvez imprimer les contratsList ici si nécessaire
          return contratsList;
        }
      } else {
        print('Erreur HTTP lors de la récupération des contrats. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la connexion à l\'API pour les contrats : $e');
    }

    return null; // Gérer les erreurs comme vous le souhaitez
  }

  static Future<void> sendDisponibilites(List<Map<String, dynamic>> disponibilites) async {
    try {
      final token = await getToken();
      if (token == null) {
        print('Error: Token is null');
        return null;
      }
      const url = 'https://appariteur.com/api/users/disponibilites.php';
      final Map<String, dynamic> requestBody = {'updates': disponibilites};
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      // Traitement de la réponse
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('Disponibilités ajoutées avec succès');
        } else {
          print('Erreur lors de l\'ajout des disponibilités');
        }
      } else {
        print('Failed to add disponibilites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending disponibilites: $e');
    }
  }
  static Future<bool> cancelMission(String missionId) async {
    final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return false;
    }

    final url = 'https://appariteur.com/api/mission/cancel.php?mission_id=$missionId';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        print('Mission cancelled successfully');
        return true;
      } else {
        print('Server responded with error: ${responseData['message']}');
        return false;
      }
    } else {
      print('HTTP Error while cancelling mission. Status Code: ${response.statusCode}');
      return false;
    }
  }
  static Future<List<Disponibilite>?> getDisponibilites() async {
    final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return null;
    }
    const url = 'https://appariteur.com/api/users/disponibilites.php';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var disponibilitesData = json.decode(utf8.decode(response.bodyBytes));
        if (disponibilitesData['success'] == true) {
          final List<dynamic> disponibilitesInfo = disponibilitesData['result'];

          if (disponibilitesInfo.isEmpty) {
            return null;
          }

          final List<Disponibilite> disponibilitesList = disponibilitesInfo.map((disponibiliteData) {
            return Disponibilite.fromJson(disponibiliteData);
          }).toList();

          print(disponibilitesList); // For debug
          return disponibilitesList;
        }
      } else {
        print('HTTP Error while fetching disponibilites. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to the API for disponibilites: $e');
    }

    return null; // Handle errors as you wish
  }


  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      _loggedUserData = null;
      tokenVar = null;
      prefs.clear(); // Efface toutes les préférences partagées si nécessaire
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
    }
  }
  static Future<bool> deleteUserDocument(String docId) async {
    final token = await getToken();
    if (token == null) {
      print('Error: Token is null');
      return false;
    }

    final response = await http.delete(
      Uri.parse('https://appariteur.com/api/users/document.php?doc_id=$docId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        print('Document deleted successfully');
        return true;
      } else {
        print('Server responded with error: ${responseData['message']}');
        return false;
      }
    } else {
      print('HTTP Error while deleting document. Status Code: ${response.statusCode}');
      return false;
    }
  }

}


