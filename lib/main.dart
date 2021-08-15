import 'package:flutter/material.dart';
import 'movie_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'list_model.dart';

var movies;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  await Hive.openBox<Movie>('movies');

  runApp(MyApp());
}

// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox<Movie>('movies');
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Movie list';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MovieList(),
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  bool showForm = false;
  // bool submitForm = MovieForm().submitForm;
  // final _movies = <Movie>[];
  @override
  Widget build(BuildContext context) {
    Hive.box('movies').put(0, Movie("something", "someguy", "someimg"));
    return Column(
      children: [
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MovieForm()));
          },
          child: const Icon(Icons.add),
        ),
        // debugPrint($MovieForm().movies);

        // ListView.builder(
        //     padding: const EdgeInsets.all(16.0),
        //     itemBuilder: (context, i) {
        //       if (i.isOdd) {
        //         return const Divider();
        //       }
        //       final index = 1 ~/ 2;
        //       return _buildRow(MovieForm().movies[index]);
        //     })
        Text(Hive.box('movies').get(0).movieName)
      ],
    );
  }
}

// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);

//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }

// class _RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _biggerFont = const TextStyle(fontSize: 18.0);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Startup Name Generator')),
//       body: _buildSuggestions(),
//     );
//   }

//   Widget _buildSuggestions() {
//     return ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: (context, i) {
//           if (i.isOdd) {
//             return const Divider();
//           }
//           final index = i ~/ 2;
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10));
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }

//   Widget _buildRow(WordPair pair) {
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//     );
//   }
// }
