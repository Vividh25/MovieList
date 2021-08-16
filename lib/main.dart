import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Boxes.dart';
import 'package:flutter_application_1/authentication_service.dart';
import 'package:flutter_application_1/list_model.dart';
import 'package:flutter_application_1/sign_in.dart';
import 'package:provider/provider.dart';
import 'movie_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_dialog.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieModelAdapter());
  await Hive.openBox<MovieModel>('movies');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => AuthenticationService(),
        child: MaterialApp(
          title: "Cinephile",
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: const Scaffold(
            body: AuthenticationWrapper(),
          ),
        ),
      );
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const MovieList();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something Went Wrong!'));
            } else {
              return const SignIn();
            }
          },
        ),
      );
}

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Cinephile';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => FirebaseAuth.instance.signOut(),
        ),
        centerTitle: true,
        title:
            const Text(appTitle, style: TextStyle(fontWeight: FontWeight.w100)),
      ),
      body: ValueListenableBuilder<Box<MovieModel>>(
        valueListenable: Boxes.getMovies().listenable(),
        builder: (context, box, _) {
          final movies = box.values.toList().cast<MovieModel>();

          return buildContent(movies);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MovieForm())),
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
