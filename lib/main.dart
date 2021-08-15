import 'package:flutter/material.dart';
import 'package:flutter_application_1/Boxes.dart';
import 'package:flutter_application_1/list_model.dart';
import 'movie_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('movies');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Cinephile';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Scaffold(
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
          MovieModel movie = movies[index];
          String url = movie.imgUrl;
          return Container(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                  onTap: () => {displayEditDialog(context, movie)},
                  title: Text(movie.movieName),
                  leading: CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.contain)),
                    ),
                    imageUrl: url,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 80,
                      width: 80,
                      child: Icon(Icons.error),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteMovie(movie);
                    },
                  ),
                  subtitle: Text(movie.directorName)));
        },
      );
    }
  }
}
