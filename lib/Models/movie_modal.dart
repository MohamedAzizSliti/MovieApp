class Movie {
  final int? id;
  final String? title;
  final String? overview;
  final String? releaseDate;
  final double? voteAverage;
  final String? posterPath;
  final String? bannerurl;

  Movie({
    this.id,
    this.title,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.posterPath,
    this.bannerurl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? "",
      overview: json['overview'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      posterPath: json['poster_path'],
      bannerurl: json['backdrop_path'],
    );
  }

  // You can add additional methods or properties as needed

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title ?? "",
      'overview': overview,
      'release_date': releaseDate,
      'vote_average': voteAverage ?? 0,
      'poster_path': posterPath,
      'backdrop_path': bannerurl,
    };
  }
}
