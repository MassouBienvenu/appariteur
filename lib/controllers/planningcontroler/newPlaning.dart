import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaningNew extends StatefulWidget {
  const PlaningNew({Key? key});

  @override
  State<PlaningNew> createState() => _PlaningNewState();
}

class _PlaningNewState extends State<PlaningNew> {
  final List<DateTime> _selectedDates = [];
  final TextEditingController _heuresController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null) {
      setState(() {
        _selectedDates.add(picked);
      });
    }
  }

  Future<void> _selectHeures(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ))!;

    setState(() {
      _heuresController.text = picked.format(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer vos Disponibilité'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dates
              Column(
                children: _selectedDates.map((date) {
                  return ListTile(
                    title: Text(DateFormat('dd/MM/yyyy').format(date)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _selectedDates.remove(date);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Ajouter une date'),
              ),
              // Heures
              TextFormField(
                controller: _heuresController,
                onTap: () => _selectHeures(context),
                decoration: InputDecoration(
                  labelText: 'Heures',
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
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectHeures(context),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Submit the form here
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
