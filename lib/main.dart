import 'package:flutter/material.dart';
import 'package:flutter_application_1/Boxes.dart';
import 'package:flutter_application_1/list_model.dart';
import 'movie_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// TypeAdapter<dynamic> testAdapter = MovieAdapter() as TypeAdapter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('movies');
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
    const appTitle = 'Cinephile';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
        // backgroundColor: Colors.indigo,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(appTitle,
              style: TextStyle(fontWeight: FontWeight.w100)),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<MovieModel>>(
        valueListenable: Boxes.getMovies().listenable(),
        builder: (context, box, _) {
          final movies = box.values.toList().cast<MovieModel>();

          return buildContent(movies);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MovieForm())),
      ),
    );

    // return Column(
    //   children: [
    //     FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //             context, MaterialPageRoute(builder: (context) => MovieForm()));
    //       },
    //       child: const Icon(Icons.add),
    //     ),
    //     // debugPrint($MovieForm().movies);

    //     // ListView.builder(
    //     //     padding: const EdgeInsets.all(16.0),
    //     //     itemBuilder: (context, i) {
    //     //       if (i.isOdd) {
    //     //         return const Divider();
    //     //       }
    //     //       final index = 1 ~/ 2;
    //     //       return _buildRow(MovieForm().movies[index]);
    //     //     })
    //     Text(Hive.box('movies').get(0).movieName)
    //   ],
    // );
  }

  Widget buildContent(List<MovieModel> movies) {
    deleteMovie(MovieModel movie) {
      movie.delete();
    }

    if (movies.isEmpty) {
      return const Center(
        child: Text(
          "No movies added",
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
              color: Colors.amber,
              child: ListTile(
                  title: Text(movie.movieName),
                  leading: Image.network(movie.imgUrl),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteMovie(movie);
                    },
                  ),
                  subtitle: Text(movie.directorName)));
          // return ListTile(
          //     title: Text(movie.movieName),
          //     leading: Image.network(movie.imgUrl),
          //     trailing: IconButton(
          //       icon: const Icon(Icons.delete),
          //       onPressed: () {
          //         deleteMovie(movie);
          //       },
          //     ),
          //     subtitle: Text(movie.directorName));
        },
      );
    }
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
