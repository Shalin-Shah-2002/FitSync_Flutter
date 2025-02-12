import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Youtube_Videos.dart';
import 'package:fitnessapp/Services/API/Youtube_Video_api.dart';
import 'package:fitnessapp/Services/API/AI_Exersice_Description.dart';

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

  final AI_Exersice_Description = AiExerciseDescription();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Call API and assign the stream
    youtubeApi.fetchVideos(widget.search_videos);
    videoStream = youtubeApi.youtubeVideos; // Assign the broadcast stream
    AI_Exersice_Description.getExerciseDescriptionApi("pushups");
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
          FutureBuilder<Map<String, dynamic>>(
            future:
                AI_Exersice_Description.getExerciseDescriptionApi(widget.search_videos),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No exercise data available.'));
              }

              final data = snapshot.data!;
              return ExerciseDetailsTab(
                exerciseName: data['Exercise Name'] ?? 'Unknown Exercise',
                description: data['Description'] ?? 'No description available',
                beginnerReps: data['Beginner Reps'] ?? 'N/A',
                intermediateReps: data['Intermediate Reps'] ?? 'N/A',
                professionalReps: data['Professional Reps'] ?? 'N/A',
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailsTab extends StatelessWidget {
  final String exerciseName;
  final String description;
  final String beginnerReps;
  final String intermediateReps;
  final String professionalReps;

  const ExerciseDetailsTab({
    Key? key,
    required this.exerciseName,
    required this.description,
    required this.beginnerReps,
    required this.intermediateReps,
    required this.professionalReps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Title Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  exerciseName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Recommended Reps Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Repetitions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRepLevel(
                      context,
                      'Beginner',
                      beginnerReps,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildRepLevel(
                      context,
                      'Intermediate',
                      intermediateReps,
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildRepLevel(
                      context,
                      'Professional',
                      professionalReps,
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepLevel(
    BuildContext context,
    String level,
    String reps,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            level,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            reps,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
