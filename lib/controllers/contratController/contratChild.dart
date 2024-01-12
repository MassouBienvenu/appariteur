import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/apihelper.dart';
import '../../models/contrat.dart';


class ContratChild extends StatefulWidget {
  @override
  _ContratChildState createState() => _ContratChildState();
}

class _ContratChildState extends State<ContratChild> {
  List<Contrat>? contrats;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final loadedContrats = await AuthApi.getContrats();

    setState(() {
      contrats = loadedContrats;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : contrats == null || contrats!.isEmpty
          ? Center(child: Text("Pas de contrats"))
          : AnimationLimiter(
        child: ListView.builder(
          itemCount: contrats!.length,
          padding: EdgeInsets.all(_w / 30),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemBuilder: (BuildContext c, int i) {
            final contrat = contrats![i];
            return AnimationConfiguration.staggeredList(
              position: i,
              delay: const Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                horizontalOffset: 30,
                verticalOffset: 300.0,
                child: ContratItem(width: _w, contrat: contrat),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContratItem extends StatelessWidget {
  final double width;
  final Contrat contrat;

  ContratItem({required this.width, required this.contrat});

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
      print("Permission de stockage refusée");
    }
  }

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PDFScreen(url: 'https://appariteur.com/admins/documents/${contrat.nameFichier}'),
              ),
            );
          },
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
                      child: Text(contrat.typeContrat, style: Theme.of(context).textTheme.headline6),
                    ),
                    Icon(Icons.check_circle, color: Colors.green)
                  ],
                ),
                SizedBox(height: 10),
                Text('Date de début: ${contrat.dateEmbauche}', style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 5),
                Text('Date de fin: ${contrat.dateFinContrat}', style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 5),
                Text('Montant par heure: ${contrat.montantHeure}', style: Theme.of(context).textTheme.subtitle2),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => downloadFile(
                        'https://appariteur.com/admins/documents/${contrat.nameFichier}',
                        '${contrat.nameFichier}.pdf'),
                    icon: Icon(Icons.download, color: Colors.white),
                    label: Text('Télécharger'),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Theme.of(context).primaryColor,
                    ),
                  ),
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
        title: const Text('Document'),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
