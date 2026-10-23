class PopularModel {
  String backdropPath;
  int id;
  String title;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  double voteAverage;
  int voteCount;

  PopularModel({
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
  });

  factory PopularModel.fromMap(Map<String, dynamic> mapa) {
    return PopularModel(
      backdropPath: mapa['backdrop_path'] ?? '',
      id: mapa['id'] ?? 0,
      title: mapa['title'] ?? '',
      originalLanguage: mapa['original_language'] ?? '',
      originalTitle: mapa['original_title'] ?? '',
      overview: mapa['overview'] ?? '',
      popularity: (mapa['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: mapa['poster_path'] ?? '',
      releaseDate:
          DateTime.tryParse(mapa['release_date'] ?? '') ?? DateTime(1900),
      voteAverage: (mapa['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: mapa['vote_count'] ?? 0,
    );
  }
}
