import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Youtube_Videos.dart';
import 'package:fitnessapp/Services/API/Youtube_Video_api.dart';

class YouTubeTabPage extends StatefulWidget {
  final String search_videos;
  const YouTubeTabPage({required this.search_videos, Key? key})
      : super(key: key);

  @override
  _YouTubeTabPageState createState() => _YouTubeTabPageState();
}

class _YouTubeTabPageState extends State<YouTubeTabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Stream<List<Youtube_Videos>> videoStream;
  final youtubeApi = Youtube_VideoApi();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Call API and assign the stream
    youtubeApi.fetchVideos(widget.search_videos);
    videoStream = youtubeApi.youtubeVideos; // Assign the broadcast stream
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Tabs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'YouTube Videos'),
            Tab(text: 'Second Tab'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First Tab - YouTube Videos
          StreamBuilder<List<Youtube_Videos>>(
            stream: videoStream, // Use stored broadcast stream
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error: ${snapshot.error} \n StackTrace: ${snapshot.stackTrace}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No videos found."));
              }

              final videos = snapshot.data!;
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        video.thumbnail!,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(
                        video.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        video.url ?? 'No URL',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        print('Selected video ID: ${video.videoId}');
                      },
                    ),
                  );
                },
              );
            },
          ),

          // Second Tab - Placeholder
          const Center(
            child: Text('Second Tab Content'),
          ),
        ],
      ),
    );
  }
}
