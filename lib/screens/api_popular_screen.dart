import 'package:flutter/material.dart';
import 'package:moviles/models/popular_model.dart';
import 'package:moviles/network/api_popular.dart';

class ApiPopularScreen extends StatefulWidget {
  const ApiPopularScreen({super.key});

  @override
  State<ApiPopularScreen> createState() => _ApiPopularScreenState();
}

class _ApiPopularScreenState extends State<ApiPopularScreen> {
  ApiPopular? apiPopular;
  late Future<List<PopularModel>?> futurePopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    futurePopular = apiPopular!.getAllPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Películas populares")),
      body: FutureBuilder(
        future: futurePopular,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return popularItem(snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Algo ha salido mal: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: Text("No se pudieron cargar las películas"),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget popularItem(PopularModel pelicula) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: pelicula.posterPath.isNotEmpty
                ? FadeInImage(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: const AssetImage("assets/loading1.gif"),
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${pelicula.posterPath}',
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.movie, size: 50));
                    },
                  )
                : const Center(child: Icon(Icons.movie, size: 50)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              pelicula.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
