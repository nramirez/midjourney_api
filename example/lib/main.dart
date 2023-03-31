import 'package:flutter/material.dart';
import 'package:midjourney_api/midjourney_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

/// Homepage with a pageview and a bottom navigation bar
/// one section for top images and one for recent images
/// the images are fetched from the midjourney API
/// and displayed in a gridview
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MidJourney'),
      ),
      body: PageView(
        controller: controller,
        children: const [
          TopImages(),
          RecentImages(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Recent',
          ),
        ],
        onTap: (index) {
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

class TopImages extends StatelessWidget {
  const TopImages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MidJourneyApi().fetchTop(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final images = snapshot.data as List<String>;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(child: Image.network(images[index]));
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RecentImages extends StatelessWidget {
  const RecentImages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MidJourneyApi().fetchRecent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final images = snapshot.data as List<String>;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Card(child: Image.network(images[index]));
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
