import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(PoliticalDelegateApp());
}

class Event {
  final int id;
  final String title;
  final String date;
  final String description;
  final String photoPath;
  final String audioPath;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.photoPath,
    required this.audioPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'photoPath': photoPath,
      'audioPath': audioPath,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      description: map['description'],
      photoPath: map['photoPath'],
      audioPath: map['audioPath'],
    );
  }
}

class DatabaseHelper {
  static const String tableName = 'events';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDate = 'date';
  static const String colDescription = 'description';
  static const String colPhotoPath = 'photoPath';
  static const String colAudioPath = 'audioPath';

  late final Future<void> Function() _initIsar;
  late final Future<List<Event>> Function() _getAllEvents;
  late final Future<int> Function(Event) _insertEvent;
  late final Future<int> Function(Event) _deleteEvent;

  DatabaseHelper({
    required Future<void> Function() initIsar,
    required Future<List<Event>> Function() getAllEvents,
    required Future<int> Function(Event) insertEvent,
    required Future<int> Function(Event) deleteEvent,
  }) {
    _initIsar = initIsar;
    _getAllEvents = getAllEvents;
    _insertEvent = insertEvent;
    _deleteEvent = deleteEvent;
  }

  Future<void> init() async {
    await _initIsar();
  }

  Future<List<Event>> getAllEvents() async {
    return _getAllEvents();
  }

  Future<int> insertEvent(Event event) async {
    return _insertEvent(event);
  }

  Future<int> deleteEvent(Event event) async {
    return _deleteEvent(event);
  }
}

class PoliticalDelegateApp extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper(
    initIsar: () async {
      // Initialization logic for Isar or any other database
    },
    getAllEvents: () async {
      // Logic to get all events from database
      return [];
    },
    insertEvent: (Event event) async {
      // Logic to insert event into database
      return 1; // Dummy return value
    },
    deleteEvent: (Event event) async {
      // Logic to delete event from database
      return 1; // Dummy return value
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Political Delegate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: classContainer(dbHelper: dbHelper),
    );
  }
}

class classContainer extends StatelessWidget {
  final DatabaseHelper dbHelper;

  classContainer({required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.blue,
          backgroundColor: Color.fromARGB(255, 102, 0, 255),
          title: const Center(
            child: Text(
              "Partidos Politicos",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 224, 198, 0),
            tabs: [
              const Tab(
                icon: Icon(color: Colors.white, FontAwesomeIcons.house),
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: Icon(color: Colors.amber[100], FontAwesomeIcons.calendarPlus),
                child: Text(
                  'Eventos',
                  style: TextStyle(color: Colors.amber[100]),
                ),
              ),
              Tab(
                icon: Icon(color: Colors.amber[300], FontAwesomeIcons.addressCard),
                child: Text(
                  'Acerca de',
                  style: TextStyle(color: Colors.amber[300]),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(),
            AgregarEvento(dbHelper: dbHelper),
            const Acerca_de(),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Image.network(
                'https://m.n.com.do/wp-content/uploads/2023/10/WhatsApp-Image-2023-10-26-at-10.33.57-PM.jpeg',
              ),
              const Divider(),
              Container(
                width: 360,
                child: const Center(
                  child: Text(
                    'Los partidos políticos de la República Dominicana son los aproximadamente 25 partidos y organizaciones políticas que presentan candidatos en cada proceso electoral en la República Dominicana. De estos, apenas unos pocos se reparten la mayoría de la simpatía del electorado y alrededor de ellos gravita la vida política nacional. De las otras agrupaciones, buena parte acude en alianza o respaldando a los candidatos de alguno de los partidos mayoritarios, en particular en las elecciones presidenciales, o son iniciativas independientes, aisladas y/o recientes de ciudadanos que pretenden crear un nuevo espacio para la expresión de la sociedad civil, pero sin gran arrastre o apoyo del público.',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}

class AgregarEvento extends StatefulWidget {
  final DatabaseHelper dbHelper;

  AgregarEvento({required this.dbHelper});

  @override
  _AgregarEventoState createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final titulocontroler = TextEditingController();
  final fechacontroler = TextEditingController();
  final descripcioncontroler = TextEditingController();
  final urlaudiocontroler = TextEditingController();

  File? image;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
      setState(() {
        image = File(pickedFile.path);
      });
    } on PlatformException catch (e) {
      print('Fallo al obtener la imagen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: 0, // Update itemCount with actual data count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Event Title'),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: Container(
                  width: 600,
                  height: 800,
                  child: AlertDialog(
                    content: Column(
                      children: [
                        const Text(
                          "Registro",
                          style: TextStyle(color: Colors.black, fontSize: 45),
                        ),
                        const Divider(),
                        TextField(
                          controller: titulocontroler,
                          decoration: const InputDecoration(hintText: 'Titulo'),
                        ),
                        TextField(
                          controller: fechacontroler,
                          decoration: const InputDecoration(hintText: 'Fecha'),
                        ),
                        TextField(
                          controller: descripcioncontroler,
                          decoration:
                              const InputDecoration(hintText: 'Descripcion'),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Inserta la imagen: ",
                              style: TextStyle(color: Colors.grey[700], fontSize: 17),
                            ),
                            IconButton(
                              onPressed: () {
                                pickImage(ImageSource.camera);
                              },
                              icon: Icon(FontAwesomeIcons.camera, color: Colors.blue[900]),
                            ),
                            IconButton(
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                              },
                              icon: Icon(FontAwesomeIcons.image, color: Colors.amber[900]),
                            ),
                          ],
                        ),
                        Divider(color: Colors.black),
                        TextField(
                          controller: urlaudiocontroler,
                          decoration: const InputDecoration(hintText: 'Audio'),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        ButtonBar(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Save data to database
                                Navigator.of(context).pop();
                              },
                              child: const Text('Guardar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Acerca_de extends StatelessWidget {
  const Acerca_de({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            const Divider(color: Colors.transparent),
            const Divider(color: Colors.transparent),
            Image.asset(
              "images/InWork.jpg",
              width: 200,
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const Text(
                    "Eliezer Vargas Gomez",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                    "809-854-3342",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                    "2022-0738",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Divider(color: Colors.transparent),
                  const Divider(color: Colors.transparent),
                  Center(
                    child: Container(
                      width: 350,
                      child: Text(
                        'La democracia no se limita a ser un mero sistema político; representa un compromiso inquebrantable con la equidad, la justicia y la participación activa de los ciudadanos. Es la manifestación del poder del pueblo para influir en su destino colectivo.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}