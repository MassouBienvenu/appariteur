import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MissionNew extends StatefulWidget {
  const MissionNew({Key? key});

  @override
  State<MissionNew> createState() => _MissionNewState();
}

class _MissionNewState extends State<MissionNew> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer une mission'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Client
              // Date de Prestation
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Sélectionnez')),
                          DropdownMenuItem(value: 'SFS', child: Text('SFS')),
                          DropdownMenuItem(value: 'GEDH', child: Text('GEDH')),
                          // Ajoutez d'autres éléments DropdownMenuItem au besoin
                        ],
                        decoration: InputDecoration(
                          labelText: 'Client',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white, // Couleur de fond
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          // Gérez la sélection du client ici
                        },
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _dateController,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          labelText: 'Date de Prestation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      // Lieu de Prestation
                      const SizedBox(height: 10.0),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Lieu de Prestation',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lieu de Prestation
              // Matinée / Soirée
              Row(
                children: [
                  Radio(
                    value: 'Indisponible en Matinée',
                    groupValue: 'matin_soir',
                    onChanged: (value) {
                      // Gérez le choix Matinée ici
                    },
                  ),
                  const Text('Indisponible en Matinée'),
                  Radio(
                    value: 'Insiponible en Soirée',
                    groupValue: 'matin_soir',
                    onChanged: (value) {
                      // Gérez le choix Soirée ici
                    },
                  ),
                  const Text('Indisponible en Soirée'),
                ],
              ),
              const SizedBox(height: 10.0),
              // Salle
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Salle',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      // Durée
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Durée',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      // Heure de Début
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'H. Début',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      // Heure de Fin
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'H. Fin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
              ),
              // Mission
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.blue, // Couleur du texte
                          fontSize: 15, // Taille du texte
                          fontWeight: FontWeight.bold, // Style de police
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mission',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Soumettez le formulaire ici
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}