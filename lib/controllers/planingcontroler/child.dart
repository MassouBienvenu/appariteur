import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/apihelper.dart';
import '../../models/planning.dart';


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _previouslySelectedDay;
  List<Planning>? _plannings;

  // User Info for displaying hours
  var heure_Year = "00:00:00";
  var heure_Month = "00:00:00";
  var heure_Week = "00:00:00";

  @override
  void initState() {
    super.initState();
    ShowUserInfo();
    _fetchPlannings();
  }

  void _fetchPlannings() async {
    _plannings = await AuthApi.getPlanningData();
    setState(() {});
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_previouslySelectedDay != null &&
        selectedDay.day == _previouslySelectedDay!.day &&
        selectedDay.month == _previouslySelectedDay!.month &&
        selectedDay.year == _previouslySelectedDay!.year) {
      _showMissionDetails(selectedDay);
    } else {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
    _previouslySelectedDay = selectedDay;
  }

  void _showMissionDetails(DateTime date) {
    final plannings = _getPlanningsForDay(date);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title:Center(child: Row(children:[
            SizedBox(width: 20),
              Icon(Icons.assignment, color: Color(0xFF2A4494)),
            SizedBox(width: 10),
            Text("Missions",textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A4494), // Adjust the color to fit your app theme
              ),
            ),
          ]
          ),
),

          content: Container(
            width: double.maxFinite, // To take full width of the dialog
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: plannings.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Color(0xFF2A4494)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                plannings[index].lieu,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.meeting_room_rounded, color:Color(0xFF2A4494)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text("No "+plannings[index].salle),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, color:Color(0xFF2A4494)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(plannings[index].heureDebut),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_off, color: Color(0xFF2A4494)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(plannings[index].heureFin),
                            ),
                          ],
                        ),
                        SizedBox(height: 8)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> ShowUserInfo() async {
    final userInfo = await AuthApi.InfoUser();
    if (userInfo != null) {
      setState(() {
        heure_Year = userInfo.heureYear ?? '00:00:00';
        heure_Month = userInfo.heureMonth ?? '00:00:00';
        heure_Week = userInfo.heureWeek ?? '00:00:00';
      });
    }
    // Handle failed connection or response
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [

          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr', 'FR'),
        ],
  debugShowCheckedModeBanner: false,
  home :Scaffold(

      backgroundColor: Colors.grey[200], // Light grey color for the background
      body: ListView(
        children: [
          const SizedBox(height: 30.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "Planning des missions du mois",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // White color for the calendar box
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TableCalendar(
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month', // Only allow the month view
              },
              locale: 'fr_FR',
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              calendarFormat: _calendarFormat,
              eventLoader: _getPlanningsForDay,
              onDaySelected: _onDaySelected,
            ),
          ),
          const SizedBox(height: 30.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              "Nombres d'heures de prestation",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),

          const SizedBox(height: 30.0),
          _buildHourContainer("Cette semaine", heure_Week),
          const SizedBox(height: 20.0),
          _buildHourContainer("Ce mois", heure_Month),
          const SizedBox(height: 20.0),
          _buildHourContainer("Cette année", heure_Year),
          const SizedBox(height: 30.0),
        ],
      ),
    ));
  }

  Widget _buildHourContainer(String title, String hours) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white, // White color for the hour box
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/mission.png",
            height: 50,
          ),
          Container(
            width: 140.0,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white, // White color for the inner hour box
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  hours,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Planning> _getPlanningsForDay(DateTime date) {
    final List<Planning> plannings = _plannings ?? [];
    return plannings.where((p) {
      final eventDate = DateTime.tryParse(p.datePres) ?? DateTime(0); // Handle potential parsing issues with a default date
      return eventDate.day == date.day &&
          eventDate.month == date.month &&
          eventDate.year == date.year;
    }).toList();
  }

  Widget _buildMissionDetails(List<Planning> plannings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: plannings.map((planning) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lieu: ${planning.lieu}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Salle: ${planning.salle}'),
              Text('Heure début: ${planning.heureDebut}'),
              Text('Heure fin: ${planning.heureFin}'),
              Text('Durée: ${planning.duree}'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
