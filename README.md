
# Unofficial Dart API for the MidJourney API.

## Features

Get top and recent images from Midjouney showcase
https://www.midjourney.com/showcase/recent/ 

## Getting started

```dart
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
```

Same thing for top images


## Example

![https://user-images.githubusercontent.com/1899538/229245416-4d49d8c9-7be8-45a9-a180-204ab7272105.png](https://user-images.githubusercontent.com/1899538/229245416-4d49d8c9-7be8-45a9-a180-204ab7272105.png)

![https://user-images.githubusercontent.com/1899538/229245793-7b66dfc0-d436-41ea-af82-b3f1fcb159e6.png](https://user-images.githubusercontent.com/1899538/229245793-7b66dfc0-d436-41ea-af82-b3f1fcb159e6.png)
