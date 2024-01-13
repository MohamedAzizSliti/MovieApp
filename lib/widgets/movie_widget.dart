import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/Models/movie_modal.dart';
import 'package:movie_app/constants/colors.dart';
import 'package:movie_app/screens/details_screen.dart';
import 'package:movie_app/utils/text.dart'; // Import your Movie class here

class MovieWidget extends StatefulWidget {
  final Movie movie;
  final int index; // Add the index property
  final PageController controller;
  MovieWidget(
      {required this.movie, required this.index, required this.controller});

  @override
  State<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        double value = 0.0;
        if (widget.controller.position.haveDimensions) {
          value = widget.index.toDouble() - (widget.controller.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
          print("value $value index ${widget.index}");
        }
        return Transform.rotate(
          angle: pi * value,
          child: buildCarouselCard(widget.movie),
        );
      },
    );
  }

  Widget buildCarouselCard(Movie movie) {
    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsScreen(movie: movie),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: movie
                  .posterPath!, // Assuming posterPath is present in your Movie class
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_createRoute());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: NetworkImage('https://image.tmdb.org/t/p/w500' +
                          movie.posterPath!),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: modified_text(
                text: movie.title!,
                size: 16,
              ),
            ),
            modified_text(text: '⭐ 10/' + movie.voteAverage!.toString()),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.movie.overview ?? "",
                style: GoogleFonts.roboto(
                  color: textColor, // Set your preferred color
                  fontSize: 14, // Set your preferred font size
                ),
                maxLines: 2, // Set the maximum number of lines
                overflow:
                    TextOverflow.ellipsis, // Add ellipsis (...) for overflow
              ),
            ),
          ],
        ),
      ],
    );
  }
}
