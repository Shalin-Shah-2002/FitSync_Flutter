import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Youtube_Videos.dart';
import 'package:fitnessapp/Services/API/Youtube_Video_api.dart';
import 'package:fitnessapp/Services/API/AI_Exersice_Description.dart';
import 'package:fitnessapp/Services/API/Gemini_API_Exersice_Recommandation.dart';

class YouTubeTabPage extends StatefulWidget {
  final String searchVideos;
  const YouTubeTabPage({required this.searchVideos, Key? key}) : super(key: key);

  @override
  _YouTubeTabPageState createState() => _YouTubeTabPageState();
}

class _YouTubeTabPageState extends State<YouTubeTabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Stream<List<Youtube_Videos>> videoStream;
  final youtubeApi = Youtube_VideoApi();
  final aiExerciseDescription = AiExerciseDescription();
  final geminiApi = GeminiExerciseRecommandation();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Fetch YouTube videos and assign the stream
    youtubeApi.fetchVideos(widget.searchVideos);
    videoStream = youtubeApi.youtubeVideos; // Assign the broadcast stream

    // Fetch AI-based exercise recommendations
    aiExerciseDescription.getExerciseDescriptionApi(widget.searchVideos);
    geminiApi.getExerciseRecommandationApi(widget.searchVideos);
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
            Tab(text: 'Exercise Details'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildYouTubeVideosTab(),
          _buildExerciseDetailsTab(),
        ],
      ),
    );
  }

  /// **YouTube Videos Tab**
  Widget _buildYouTubeVideosTab() {
    return StreamBuilder<List<Youtube_Videos>>(
      stream: videoStream, // Use stored broadcast stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
                  video.thumbnail ?? '',
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
                title: Text(
                  video.title ?? 'No Title',
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
    );
  }

  /// **Exercise Details Tab**
  Widget _buildExerciseDetailsTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: geminiApi.getExerciseRecommandationApi(widget.searchVideos),
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
          beginnerReps: data['Recommended Reps']['Beginners'] ?? 'N/A',
          intermediateReps: data['Recommended Reps']['Intermediate'] ?? 'N/A',
          professionalReps: data['Recommended Reps']['Professional'] ?? 'N/A',
        );
      },
    );
  }
}

/// **Exercise Details UI**
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
            _buildTitleCard(context, exerciseName),
            const SizedBox(height: 20),
            _buildDescriptionCard(description),
            const SizedBox(height: 20),
            _buildRepsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(String description) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildRepsCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recommended Repetitions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildRepLevel(context, 'Beginner', beginnerReps, Colors.green),
            const SizedBox(height: 12),
            _buildRepLevel(context, 'Intermediate', intermediateReps, Colors.blue),
            const SizedBox(height: 12),
            _buildRepLevel(context, 'Professional', professionalReps, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildRepLevel(BuildContext context, String level, String reps, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(level, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
        Text(reps, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
