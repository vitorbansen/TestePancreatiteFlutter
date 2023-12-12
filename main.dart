import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Patient {
  String name = '';
  int age = 0;
  int leucocytes = 0;
  double glucose = 0.0;
  double ast = 0.0;
  double ldh = 0.0;
  bool gallstones = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Paciente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientRegistrationScreen(),
    );
  }
}

class PatientRegistrationScreen extends StatefulWidget {
  @override
  _PatientRegistrationScreenState createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  late Patient _patient;
  int _score = 0;
  String _mortality = '';
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _patient = Patient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Paciente:'),
            TextField(
              onChanged: (value) {
                _patient.name = value;
              },
            ),
            Text('Idade (anos):'),
            TextField(
              onChanged: (value) {
                _patient.age = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
            ),
            Text('Leucócitos (células/mm³):'),
            TextField(
              onChanged: (value) {
                _patient.leucocytes = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
            ),
            Text('Glicemia (mmol/L):'),
            TextField(
              onChanged: (value) {
                _patient.glucose = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
            ),
            Text('AST/TGO sérico (UI/L):'),
            TextField(
              onChanged: (value) {
                _patient.ast = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
            ),
            Text('LDH sérico (UI/L):'),
            TextField(
              onChanged: (value) {
                _patient.ldh = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
            ),
            Text('Litíase biliar:'),
            Switch(
              value: _patient.gallstones,
              onChanged: (value) {
                setState(() {
                  _patient.gallstones = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _calculateScore();
                _showResults = true;
              },
              child: Text('Calcular Pontuação'),
            ),
            if (_showResults)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text('Pontuação do Paciente: $_score'),
                  Text('Mortalidade: $_mortality'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _calculateScore() {
    _score = 0;

    if (!_patient.gallstones) {
      // Pancreatite sem litíase biliar
      if (_patient.age > 55) _score++;
      if (_patient.leucocytes > 16000) _score++;
      if (_patient.glucose > 11.0) _score++;
      if (_patient.ast > 250.0) _score++;
      if (_patient.ldh > 350.0) _score++;
    } else {
      // Pancreatite com litíase biliar
      if (_patient.age > 70) _score++;
      if (_patient.leucocytes > 18000) _score++;
      if (_patient.glucose > 12.2) _score++;
      if (_patient.ast > 250.0) _score++;
      if (_patient.ldh > 400.0) _score++;
    }

    if (_score >= 0 && _score <= 2) {
      _mortality = 'Pancreatite Não Grave - Mortalidade: 2%';
    } else if (_score >= 3 && _score <= 4) {
      _mortality = 'Pancreatite Moderadamente Grave - Mortalidade: 15%';
    } else if (_score >= 5 && _score <= 6) {
      _mortality = 'Pancreatite Grave - Mortalidade: 40%';
    } else if (_score >= 7 && _score <= 8) {
      _mortality = 'Pancreatite Muito Grave - Mortalidade: 100%';
    }

    setState(() {});
  }
}
