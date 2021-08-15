import 'package:flutter/material.dart';
import 'list_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // await Hive.initFlutter();
  // await Hive.openBox<Movie>('movies');
  runApp(MovieForm());
}

class MovieForm extends StatefulWidget {
  final movies = <Movie>[];
  // bool submitForm = false;

  MovieForm({Key? key}) : super(key: key);

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();
  final movieNameController = TextEditingController();
  final directorNameController = TextEditingController();
  final posterController = TextEditingController();
  final moviesState = <Movie>[];

  @override
  void dispose() {
    movieNameController.dispose();
    directorNameController.dispose();
    posterController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    // debugPrint('name: $movieNameController.text');

    Movie newMovie = Movie(movieNameController.text,
        directorNameController.text, posterController.text);
    // debugPrint('New movie: $newMovie');
    // widget.movies.add(newMovie);
    // print('movie array: $widget.movies[0]');
    int i = 0;
    Hive.box('movies').put(i++, newMovie);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the movie';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Movie name'),
                  controller: movieNameController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the director';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Director Name'),
                  controller: directorNameController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the URL of the movie poster';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(hintText: 'Poster'),
                  controller: posterController,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        handleSubmit();
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Adding your movie...')));
                        }
                      },
                      child: const Text('Submit'),
                    ))
              ],
            )));
  }
}
