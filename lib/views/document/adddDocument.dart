import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appariteur/data/apihelper.dart';

class DocumentUploadPage extends StatefulWidget {
  @override
  _DocumentUploadPageState createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  int? _selectedDocType;
  final Map<int, String> _docTypes = {
    1: 'Pièce d\'identité',
    2: 'Titre de séjour',
    3: 'Relevé d\'identité bancaire (RIB)',
    4: 'Attestation Sécurité sociale',
    5: 'Contrat',
    15: 'Autre'
  };

  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile != null && _selectedDocType != null) {
      final success = await AuthApi.uploadDocument(_selectedFile, _selectedDocType.toString());
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document enregisté avec succès')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Echec de l\'enregistrement du document')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sélectionnez un fichier et un type de document!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Importer un Document'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(_w / 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Type de document',
                style: TextStyle(fontSize: _w / 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              SizedBox(height: _w / 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: _w / 30, vertical: _w / 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_w / 60),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedDocType,
                    hint: Text('Selectionner un type de document'),
                    isExpanded: true,
                    items: _docTypes.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDocType = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: _w / 20),
              InkWell(
                onTap: _pickFile,
                child: DottedBorder(
                  color: Colors.blue,
                  radius: Radius.circular(_w / 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(_w / 60)),
                    child: Container(
                      height: _w * 0.5,
                      color: Colors.grey[200],
                      child: _selectedFile != null
                          ? Image.file(_selectedFile!, fit: BoxFit.cover)
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, color: Colors.blue, size: _w / 10),
                          Text('Appuyer pour sélectionner un fichier', style: TextStyle(color: Colors.blue, fontSize: _w / 25)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: _w / 20),
              ElevatedButton(
                onPressed: _uploadFile,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: _w / 30),
                  child: Text('Importer un Document', style: TextStyle(fontSize: _w / 20)),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_w / 60),
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

class DottedBorder extends StatelessWidget {
  final Color color;
  final Radius radius;
  final Widget child;

  const DottedBorder({
    Key? key,
    required this.color,
    required this.radius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(color: color),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth = 4.0;
  final double dashSpace = 4.0;

  DottedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    var path = Path();
    double x = 0, y = 0;
    while (x < size.width) {
      path.moveTo(x, 0);
      path.lineTo(x + dashWidth, 0);
      x += dashWidth + dashSpace;
    }

    while (y < size.height) {
      path.moveTo(size.width, y);
      path.lineTo(size.width, y + dashWidth);
      y += dashWidth + dashSpace;
    }

    x = size.width;
    while (x > 0) {
      path.moveTo(x, size.height);
      path.lineTo(x - dashWidth, size.height);
      x -= dashWidth + dashSpace;
    }

    y = size.height;
    while (y > 0) {
      path.moveTo(0, y);
      path.lineTo(0, y - dashWidth);
      y -= dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) => false;
}