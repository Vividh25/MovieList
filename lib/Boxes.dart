// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'list_model.dart';

class Boxes {
  static Box<MovieModel> getMovies() => Hive.box<MovieModel>('movies');
}
