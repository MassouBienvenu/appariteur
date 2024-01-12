import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/apihelper.dart';
import '../../models/fichepaie.dart';


class FichesPaieChild extends StatefulWidget {
  @override
  _FichesPaieChildState createState() => _FichesPaieChildState();
}

class _FichesPaieChildState extends State<FichesPaieChild> {
  List<FichePaie>? fichesPaie;

  @override
  void initState() {
    super.initState();
    loadFichesPaie();
  }

  Future<void> loadFichesPaie() async {
    final loadedFichesPaie = await AuthApi.getFichesPaie();
    setState(() {
      fichesPaie = loadedFichesPaie;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<FichePaie>?>(
        future: AuthApi.getFichesPaie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fiches'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Pas de fiches"));
          } else {
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.all(_w / 30),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext c, int i) {
                  final fiche = snapshot.data![i];
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      horizontalOffset: 30,
                      verticalOffset: 300.0,
                      child: ListItem(width: _w, fiche: fiche),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final FichePaie fiche;
  Future<void> downloadFile(String url, String fileName) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final baseDir = await getExternalStorageDirectory();
      final localPath = baseDir!.path + '/Download';


      final savedDir = Directory(localPath);
      if (!savedDir.existsSync()) {
        savedDir.createSync(recursive: true);
      }
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: localPath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      // Gérer le cas où l'utilisateur refuse la permission
      print("Permission de stockage refusée");
    }
  }



  ListItem({required this.width, required this.fiche});

  @override
  Widget build(BuildContext context) {
    return FlipAnimation(
      duration: const Duration(milliseconds: 3000),
      curve: Curves.fastLinearToSlowEaseIn,
      flipAxis: FlipAxis.y,
      child: Card(
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.only(bottom: width / 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(url: 'https://appariteur.com/admins/documents/${fiche.fichier}'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('${fiche.mois} ${fiche.annee}', style: Theme.of(context).textTheme.headline6),
                    ),
                    Icon(Icons.check_circle, color: Colors.green)
                  ],
                ),
                SizedBox(height: 10),
                Text('Créée le: ${fiche.dateCreate}', style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        downloadFile('https://appariteur.com/admins/documents/${fiche.fichier}', fiche.fichier);
                      },
                      icon: Icon(Icons.download, color: Theme.of(context).primaryColor),
                      label: Text('Télécharger', style: Theme.of(context).textTheme.bodyText1),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                    Row(
                      children: [
                        Text('Voir ', style: Theme.of(context).textTheme.bodyText1),
                        Icon(Icons.remove_red_eye, color: Theme.of(context).primaryColor),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String url;

  const PDFScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche de Paie'),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
