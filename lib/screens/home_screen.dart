import 'package:flutter/material.dart';
import 'package:movie_app/Models/movie_modal.dart';
import 'package:movie_app/Models/type_model.dart';
import 'package:movie_app/api/api_movie.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/movie_widget.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movie_app/constants/colors.dart';
import 'package:movie_app/constants/key.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TMDB tmdb;
  List<Movie> movies = []; // List to store movies
  final PageController _controller = PageController();
  late List<Movie> trendingresult;
  late List<Movie> topratedresult;
  late List<Movie> upcomingmovie;
  late List<TypeMovie> _listTypeMovie = [
    TypeMovie(id: 1, name: "Trending Movies", types: "trendingresult"),
    TypeMovie(id: 2, name: "Top Rated Movies", types: 'topratedresult'),
    TypeMovie(id: 3, name: "UpComing Movies", types: 'upcomingmovie'),
  ];
  late TypeMovie _selectedType = TypeMovie(id: 0, name: "", types: "");

  @override
  void initState() {
    super.initState();

    // Initialize TMDB with API key and token
    tmdb = TMDB(ApiKeys(apikey, token),
        logConfig: ConfigLogger(
          showLogs: true,
          showErrorLogs: true,
        ));

    _selectedType = _listTypeMovie.first;
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      late List<Movie> result;
      // Fetch movies based on the selected type
      switch (_selectedType.types) {
        case 'trendingresult':
          result = await Api().getTrendingMovies();
          break;
        case 'topratedresult':
          result = await Api().getTopRatedMovies();
          break;
        case 'upcomingmovie':
          result = await Api().getUpcomingMovies();
          break;
        default:
          result = await Api().getTrendingMovies();
      }

      setState(() {
        // Update state with the fetched movies
        movies = result;
      });
    } catch (e) {
      // Handle errors
      print('Error loading movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: modified_text(
          text: 'Movie Mobile App ',
          color: ColorPrimary,
          size: 28,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _listTypeMovie
                  .map((e) => Container(
                        width: 150,
                        height: 45,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(
                            color: _selectedType == e
                                ? BorderButtonactive
                                : BorderButton,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          child: Text(
                            e.name,
                            style: TextStyle(
                              color:
                                  _selectedType == e ? textColor : ColorTextDes,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedType = e;
                              _loadMovies();
                            });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
          movies.isNotEmpty
              ? AspectRatio(
                  aspectRatio: 0.65,
                  child: PageView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: _controller,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      Movie movie = movies[index];
                      if (movie.title != null &&
                          movie.id != null &&
                          movie.overview != null &&
                          movie.posterPath != null &&
                          movie.releaseDate != null) {
                        return MovieWidget(
                            movie: movie,
                            index: index,
                            controller: _controller);
                      }
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
