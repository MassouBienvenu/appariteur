import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../data/apihelper.dart';
import '../../models/missionuser.dart';
class BodyM extends StatefulWidget {
  @override
  _BodyMState createState() => _BodyMState();
}

class _BodyMState extends State<BodyM> {
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  List<Mission>? _missions = [];
  String? _totalHours = '';

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isStart ? _startDate! : _endDate!,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: const Locale('fr', 'FR'));
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }
  void showToast(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future<void> _fetchMissions() async {
    if (_startDate != null && _endDate != null) {
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate!);
      MissionEffUserResult? result = await AuthApi.getMissionsEffectuees(formattedStartDate, formattedEndDate);
      if (result != null) {
        setState(() {
          _missions = result.missions;
          _totalHours = result.totalHours;
        });
      }
    } else {
     showToast("Chosissez une date de début et une date de fin.");
    }
  }

  @override


  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _pickDate(context, true),
                    child: Text('Date de début: ${DateFormat('yyyy-MM-dd', 'fr_FR').format(_startDate!)}'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _pickDate(context, false),
                    child: Text('Date de fin: ${DateFormat('yyyy-MM-dd', 'fr_FR').format(_endDate!)}'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _fetchMissions,
              child: Text('Chercher les missions', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 12),
            _totalHours != null && _totalHours!.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                'Heures Totales: $_totalHours',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            )
                : SizedBox(),
            _missions != null && _missions!.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _missions!.length,
              itemBuilder: (context, index) {
                final mission = _missions![index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.assignment, color: Theme.of(context).primaryColor),
                    title: Text(mission.date as String),
                    subtitle: Text(mission.etabli),
                    trailing: Text(mission.duree),
                  ),
                );
              },
            )
                : (_totalHours != null && _totalHours!.isNotEmpty)
                ? Center(
              child: Text(
                'Aucune mission à afficher',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.redAccent,
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

