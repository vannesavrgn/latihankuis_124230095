import 'package:flutter/material.dart';
import 'package:latihan_kuis_prakmobile/models/movie_data.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final int index;
  const DetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final movie = movieList[index];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "${movie.title} (${movie.year})",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0f2027),
                Color(0xFF203A43),
                Color(0xFF2c5364)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0f2027),
              Color(0xFF203A43),
              Color(0xFF2c5364)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster full + klik → fullscreen
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullImagePage(
                        imageUrl: movie.imgUrl,
                        title: movie.title,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: "poster_${movie.title}",
                  child: Image.network(
                    movie.imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 400,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 400,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 80, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Informasi detail film
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul + Tahun
                    Text(
                      "${movie.title} (${movie.year})",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Genre
                    Text(
                      "Genre: ${movie.genre}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    // Sutradara
                    Text(
                      "Sutradara: ${movie.director}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    // Casts
                    Text(
                      "Casts: ${movie.casts.join(", ")}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "${movie.rating}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sinopsis
                    Text(
                      movie.synopsis,
                      style: const TextStyle(
                          color: Colors.white70, height: 1.4),
                    ),

                    const SizedBox(height: 20),

                    // Tombol buka URL
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 3, 201, 236),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _launchURL(movie.movieUrl),
                        child: const Text("Lihat Detail di Wikipedia"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman untuk gambar fullscreen
class FullImagePage extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullImagePage({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0f2027),
                Color(0xFF203A43),
                Color(0xFF2c5364)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0f2027),
              Color(0xFF203A43),
              Color(0xFF2c5364)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Hero(
            tag: "poster_$title",
            child: InteractiveViewer(
              panEnabled: true, // bisa digeser
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchURL(String urlString) async {
  final url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $urlString';
  }
}
