import 'package:flutter/material.dart';
import 'package:flutter_application_1/list_model.dart';

Future<void> displayEditDialog(BuildContext context, MovieModel movie) async {
  final movieNameController = TextEditingController(text: movie.movieName);
  final directorNameController =
      TextEditingController(text: movie.directorName);
  final posterController = TextEditingController(text: movie.imgUrl);

  editMovie(MovieModel movie) {
    debugPrint('when clicked on done $movie.movieName');
    movie.movieName = movieNameController.text;
    movie.directorName = directorNameController.text;
    movie.imgUrl = posterController.text;
    movie.save();
    Navigator.pop(context);
  }

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(35, 35, 35, 150),
          title: const Text('Edit Movie'),
          content: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the movie';
                  }
                  return null;
                },
                controller: movieNameController,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the director';
                  }
                  return null;
                },
                controller: directorNameController,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the url of the movie poster';
                  }
                  return null;
                },
                controller: posterController,
              ),
              const Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                  child: const Text('Done'),
                  onPressed: () {
                    editMovie(movie);
                  })
            ],
          ),
        );
      });
}
