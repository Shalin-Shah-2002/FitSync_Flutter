import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Youtube_Videos.dart';
import 'package:fitnessapp/Services/API/Youtube_Video_api.dart';
import 'package:fitnessapp/Services/API/AI_Exersice_Description.dart';
import 'package:fitnessapp/Services/API/Gemini_API_Exersice_Recommandation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  
  // Define your colors
  final Color SelectedColor = Color(0xFF462749);
  final Color UnselectedColor = Color(0xFF8332AC);
  
  // For video player
  String? _currentVideoId;
  bool _isVideoPlaying = false;
  YoutubePlayerController? _youtubeController;

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
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializePlayer(String videoId) {
    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
    setState(() {
      _currentVideoId = videoId;
      _isVideoPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SelectedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.searchVideos,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.play_circle_fill),
              text: 'Videos',
            ),
            Tab(
              icon: Icon(Icons.fitness_center),
              text: 'Details',
            ),
          ],
        ),
      ),
      body: _isVideoPlaying 
        ? _buildVideoPlayer()
        : TabBarView(
            controller: _tabController,
            children: [
              _buildYouTubeVideosTab(),
              _buildExerciseDetailsTab(),
            ],
          ),
    );
  }
  
  Widget _buildVideoPlayer() {
    return SafeArea(
      child: Column(
        children: [
          YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: UnselectedColor,
            progressColors: ProgressBarColors(
              playedColor: UnselectedColor,
              handleColor: SelectedColor,
            ),
            onReady: () {
              _youtubeController!.addListener(() {});
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _youtubeController?.metadata.title ?? 'Loading title...',
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _isVideoPlaying = false;
                              _youtubeController?.pause();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _youtubeController?.metadata.author ?? 'Loading channel...',
                      style: TextStyle(
                        fontSize: 16,
                        color: UnselectedColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    FutureBuilder<Map<String, dynamic>>(
                      future: geminiApi.getExerciseRecommandationApi(widget.searchVideos),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(UnselectedColor),
                            ),
                          );
                        }
                        
                        final data = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Exercise Guide',
                              style: TextStyle(
                                fontSize: 18,
                                color: SelectedColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['Description'] ?? 'No description available',
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **YouTube Videos Tab**
  Widget _buildYouTubeVideosTab() {
    return StreamBuilder<List<Youtube_Videos>>(
      stream: videoStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(UnselectedColor),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: SelectedColor),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: SelectedColor),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60, color: SelectedColor.withOpacity(0.7)),
                const SizedBox(height: 16),
                Text(
                  "No videos found for '${widget.searchVideos}'",
                  style: TextStyle(color: SelectedColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final videos = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (video.videoId != null) {
                        _initializePlayer(video.videoId!);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  video.thumbnail ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: SelectedColor.withOpacity(0.2),
                                    child: Icon(Icons.error, color: SelectedColor),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 36,
                                      color: UnselectedColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title ?? 'No Title',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility, size: 14, color: SelectedColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(index + 1) * 7843} views',
                                      style: TextStyle(
                                        color: SelectedColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.access_time, size: 14, color: SelectedColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${3 + index * 2}:${(index * 17) % 60 < 10 ? '0' : ''}${(index * 17) % 60}',
                                      style: TextStyle(
                                        color: SelectedColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
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
            },
          ),
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
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(UnselectedColor),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: SelectedColor),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: SelectedColor),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 60, color: SelectedColor.withOpacity(0.7)),
                const SizedBox(height: 16),
                Text(
                  'No exercise data available.',
                  style: TextStyle(color: SelectedColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        return ExerciseDetailsTab(
          exerciseName: data['Exercise Name'] ?? 'Unknown Exercise',
          description: data['Description'] ?? 'No description available',
          beginnerReps: data['Recommended Reps']['Beginners'] ?? 'N/A',
          intermediateReps: data['Recommended Reps']['Intermediate'] ?? 'N/A',
          professionalReps: data['Recommended Reps']['Professional'] ?? 'N/A',
          selectedColor: SelectedColor,
          unselectedColor: UnselectedColor,
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
  final Color selectedColor;
  final Color unselectedColor;

  const ExerciseDetailsTab({
    Key? key,
    required this.exerciseName,
    required this.description,
    required this.beginnerReps,
    required this.intermediateReps,
    required this.professionalReps,
    required this.selectedColor,
    required this.unselectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleCard(context, exerciseName),
              const SizedBox(height: 16),
              _buildDescriptionCard(description),
              const SizedBox(height: 16),
              _buildRepsCard(context),
              const SizedBox(height: 16),
              _buildTipsCard(),
              const SizedBox(height: 16),
              _buildMuscleGroupCard(),
              const SizedBox(height: 16), // Bottom padding for scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context, String title) {
    return Card(
      elevation: 4,
      shadowColor: selectedColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              selectedColor,
              unselectedColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Complete Guide',
              style: TextStyle(
                fontSize: 14, 
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(String description) {
    return Card(
      elevation: 3,
      shadowColor: selectedColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: unselectedColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description, 
              style: const TextStyle(
                fontSize: 14, 
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepsCard(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: selectedColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat, color: unselectedColor, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Recommended Repetitions', 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: selectedColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRepLevel(context, 'Beginner', beginnerReps, Colors.green),
            const Divider(height: 24),
            _buildRepLevel(context, 'Intermediate', intermediateReps, Colors.blue),
            const Divider(height: 24),
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
        Row(
          children: [
            Icon(
              level == 'Beginner' ? Icons.person 
                  : level == 'Intermediate' ? Icons.people 
                  : Icons.whatshot,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              level, 
              style: TextStyle(
                fontSize: 15, 
                fontWeight: FontWeight.w600, 
                color: color,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            reps, 
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTipsCard() {
    final List<String> tips = [
      'Remember to breathe properly during the exercise',
      'Focus on maintaining proper form over lifting heavier weights',
      'Stay hydrated before, during, and after your workout',
      'Warm up properly before beginning the exercise'
    ];
    
    return Card(
      elevation: 3,
      shadowColor: selectedColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: unselectedColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Pro Tips',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, 
                    size: 16, 
                    color: unselectedColor.withOpacity(0.8)
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMuscleGroupCard() {
    return Card(
      elevation: 3,
      shadowColor: selectedColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.accessibility_new, color: unselectedColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Targeted Muscle Groups',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: selectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout based on available width
                final bool isWideEnough = constraints.maxWidth > 300;
                
                if (isWideEnough) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildMuscleItem('Primary', 'Quadriceps', 0.9)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildMuscleItem('Secondary', 'Hamstrings', 0.6)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildMuscleItem('Tertiary', 'Glutes', 0.4)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildMuscleItem('Stabilizers', 'Core', 0.3)),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Stack items vertically on narrow screens
                  return Column(
                    children: [
                      _buildMuscleItem('Primary', 'Quadriceps', 0.9),
                      const SizedBox(height: 12),
                      _buildMuscleItem('Secondary', 'Hamstrings', 0.6),
                      const SizedBox(height: 12),
                      _buildMuscleItem('Tertiary', 'Glutes', 0.4),
                      const SizedBox(height: 12),
                      _buildMuscleItem('Stabilizers', 'Core', 0.3),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMuscleItem(String type, String muscle, double intensity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: TextStyle(
            fontSize: 13,
            color: selectedColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          muscle,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: intensity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [selectedColor, unselectedColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}