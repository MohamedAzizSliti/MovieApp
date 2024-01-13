import 'package:flutter/material.dart';
import 'package:movie_app/Models/movie_modal.dart';
import 'package:movie_app/Models/video_model.dart';
import 'package:movie_app/constants/colors.dart';
import 'package:movie_app/constants/key.dart';
import 'package:movie_app/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final TMDB tmdb;
  late List<Video> videos = [];
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    tmdb = TMDB(ApiKeys(apikey, token));
    _youtubeController = YoutubePlayerController(initialVideoId: '');

    // Fetch movie videos when the screen is initialized
    _loadMovieVideos(widget.movie.id!);
  }

  Future<void> _loadMovieVideos(int movieId) async {
    try {
      // Fetch movie videos using tmdb_api
      final List<Video> fetchedVideos = await getMovieVideos(movieId);
      print(fetchedVideos);
      setState(() {
        // Update state with the fetched videos
        videos = fetchedVideos;

        // Set the initial video ID for the YoutubePlayerController
        if (videos.isNotEmpty) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videos.first.key,
            flags: YoutubePlayerFlags(
              autoPlay: false,
            ),
          );
        }
      });
    } catch (e) {
      // Handle errors
      print('Error loading movie videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500' +
                            widget.movie.bannerurl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: modified_text(
                      text: '⭐ Average Rating - ' +
                          widget.movie.voteAverage!.toString(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(10),
              child: modified_text(
                text: widget.movie.title ?? 'Not Loaded',
                size: 24,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: modified_text(
                text: 'Releasing On - ' + widget.movie.releaseDate!,
                size: 14,
              ),
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Container(
                  height: 200,
                  width: 100,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500' +
                        widget.movie.posterPath!,
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: modified_text(
                      text: widget.movie.overview ?? "",
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            if (videos.isNotEmpty)
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _youtubeController,
                  liveUIColor: Colors.amber,
                ),
                builder: (context, player) {
                  return player;
                },
              ),
          ],
        ),
      ),
    );
  }
}

// Add this function to fetch movie videos
Future<List<Video>> getMovieVideos(int movieId) async {
  final TMDB tmdb = TMDB(ApiKeys(apikey, token));

  try {
    final Map videosResult = await tmdb.v3.movies.getVideos(movieId);

    final List<Video> videos = (videosResult['results'] as List)
        .map((videoData) => Video.fromJson(videoData))
        .toList();

    return videos;
  } catch (e) {
    print('Error loading movie videos: $e');
    return [];
  }
}
