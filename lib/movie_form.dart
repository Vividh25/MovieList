import 'package:flutter/material.dart';
import 'package:flutter_application_1/Boxes.dart';
import 'package:flutter_application_1/list_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  runApp(const MovieForm());
}

class MovieForm extends StatefulWidget {
  const MovieForm({Key? key}) : super(key: key);

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();
  final movieNameController = TextEditingController();
  final directorNameController = TextEditingController();
  final posterController = TextEditingController();
  bool isEnabled = false;

  @override
  void dispose() {
    movieNameController.dispose();
    directorNameController.dispose();
    posterController.dispose();
    super.dispose();
  }

  void checkEnabled() {
    if (movieNameController.text.isNotEmpty &&
        directorNameController.text.isNotEmpty &&
        posterController.text.isNotEmpty) {
      setState(() {
        isEnabled = true;
      });
    } else {
      setState(() {
        isEnabled = false;
      });
    }
  }

  void handleSubmit() async {
    final movie = MovieModel()
      ..movieName = movieNameController.text
      ..directorName = directorNameController.text
      ..imgUrl = posterController.text;
    final box = Boxes.getMovies();
    box.add(movie);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (val) => {checkEnabled()},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the movie';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Movie name'),
                controller: movieNameController,
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextFormField(
                onChanged: (val) => {checkEnabled()},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the director';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Director Name'),
                controller: directorNameController,
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextFormField(
                onChanged: (val) => {checkEnabled()},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the URL of the movie poster';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Poster'),
                controller: posterController,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () => {
                              handleSubmit(),
                              if (_formKey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Adding your movie...'))),
                                }
                            }
                        : null,
                    child: const Text('Submit'),
                  ))
            ],
          )),
    ));
  }
}
