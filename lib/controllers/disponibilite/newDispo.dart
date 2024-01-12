import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/apihelper.dart';

class MyForm extends StatefulWidget {
  final List<DateTime> selectedDates; // Add this line

  MyForm({Key? key, required this.selectedDates}) : super(key: key); // Add this constructor

  @override
  _MyFormState createState() => _MyFormState();
}
class _MyFormState extends State<MyForm> {
  final List<Map<String, dynamic>> disponibilites = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTimeMorningBegin = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay selectedTimeMorningEnd = const TimeOfDay(hour: 13, minute: 0);
  TimeOfDay selectedTimeEveningBegin = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay selectedTimeEveningEnd = const TimeOfDay(hour: 17, minute: 0);

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(
      BuildContext context, bool isMorning, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
      isMorning ? selectedTimeMorningBegin : selectedTimeEveningBegin,
    );

    if (pickedTime != null) {
      setState(() {
        if (isMorning) {
          if (isStartTime) {
            selectedTimeMorningBegin = pickedTime;
          } else {
            selectedTimeMorningEnd = pickedTime;
          }
        } else {
          if (isStartTime) {
            selectedTimeEveningBegin = pickedTime;
          } else {
            selectedTimeEveningEnd = pickedTime;
          }
        }
      });
    }
  }

  void _submitForm() async {
    // Formatage de la date
    final String formattedDate =
    DateFormat('yyyy-MM-dd').format(selectedDate);

    // Formatage des heures
    final String formattedMorningBegin =
    _formatTime(selectedTimeMorningBegin);
    final String formattedMorningEnd =
    _formatTime(selectedTimeMorningEnd);
    final String formattedEveningBegin =
    _formatTime(selectedTimeEveningBegin);
    final String formattedEveningEnd =
    _formatTime(selectedTimeEveningEnd);

    // Création de la structure de données
    Map<String, dynamic> disponibilite = {
      "date": formattedDate,
      "heure_debutMatin": formattedMorningBegin,
      "heure_finMatin": formattedMorningEnd,
      "heure_debutSoir": formattedEveningBegin,
      "heure_finSoir": formattedEveningEnd,
    };

    // Ajout à la liste
    setState(() {
      disponibilites.add(disponibilite);
    });


    await AuthApi.sendDisponibilites(disponibilites);
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return DateFormat('HH:mm:ss').format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire de disponibilité'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Sélectionner la date'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context, true, true),
              child: const Text('Heure début (matin)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context, true, false),
              child: const Text('Heure fin (matin)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context, false, true),
              child: const Text('Heure début (soir)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectTime(context, false, false),
              child: const Text('Heure fin (soir)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Soumettre'),
            ),
            const SizedBox(height: 20),
            Text(
              'Dernières mises à jour : ${disponibilites.toString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Sélection actuelle : \n'
                  'Date : ${DateFormat('dd-MM-yyyy').format(selectedDate)}\n'
                  'Heure début (matin) : ${_formatTime(selectedTimeMorningBegin)}\n'
                  'Heure fin (matin) : ${_formatTime(selectedTimeMorningEnd)}\n'
                  'Heure début (soir) : ${_formatTime(selectedTimeEveningBegin)}\n'
                  'Heure fin (soir) : ${_formatTime(selectedTimeEveningEnd)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}