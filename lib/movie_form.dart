import 'package:flutter/material.dart';
import 'package:flutter_application_1/Boxes.dart';
import 'package:flutter_application_1/list_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // await Hive.initFlutter();
  // await Hive.openBox<Movie>('movies');
  runApp(MovieForm());
}

class MovieForm extends StatefulWidget {
  // final movies = <Movie>[];
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
  // final List<MovieModel> movies = [];
  // final moviesState = <Movie>[];

  @override
  void dispose() {
    // Hive.close();
    movieNameController.dispose();
    directorNameController.dispose();
    posterController.dispose();
    super.dispose();
  }

  // addItem(MovieModel movie) async {
  //   var movies = await Hive.openBox<MovieModel>('movies');
  //   movies.add(movie);
  //   notifyListners();
  // }

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
        body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Padding(padding: EdgeInsets.fromLTRB(3, 3, 3, 3)),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the movie';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      // focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      border: UnderlineInputBorder(),
                      hintText: 'Movie name'),
                  controller: movieNameController,
                ),
                const Padding(padding: EdgeInsets.fromLTRB(3, 3, 3, 3)),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the director';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      // focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      border: UnderlineInputBorder(),
                      hintText: 'Director Name'),
                  controller: directorNameController,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the URL of the movie poster';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      // focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                      border: UnderlineInputBorder(),
                      hintText: 'Poster'),
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
