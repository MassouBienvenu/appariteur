import 'package:flutter/material.dart';

class DeleteQ extends StatefulWidget {
  const DeleteQ({super.key});

  @override
  State<DeleteQ> createState() => _DeleteQState();
}

class _DeleteQState extends State<DeleteQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white70,
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Suppression',
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'Vous êtes sûr de supprimer...',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 44),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
