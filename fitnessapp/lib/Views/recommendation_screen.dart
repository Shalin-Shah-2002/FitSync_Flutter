import 'package:fitnessapp/Services/API/Gemini-user-recommandation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecommendationScreen extends StatefulWidget {
  final int age;
  final double weight;
  final double height;
  final String gender;
  final String activityLevel;

  const RecommendationScreen({
    super.key,
    required this.activityLevel,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> with SingleTickerProviderStateMixin {
  final _geminiUserRecommandation = GeminiUserRecommendation();
  late Future<Map<String, dynamic>> _recommendationFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSaved = false;
  
  // Define the colors
  final Color selectedColor = Color(0xFF462749);
  final Color unselectedColor = Color(0xFF8332AC);
  final Color bgColor = Color(0xFF2A2A2A);
  final Color cardColor = Color(0xFF3D3D3D);
  final Color accentColor = Color(0xFFE4C1F9);
  
  @override
  void initState() {
    super.initState();
    _recommendationFuture = _geminiUserRecommandation.getRecommendationApi(
      widget.age.toString(),
      widget.gender,
      widget.weight.toString(),
      widget.height.toString(),
      widget.activityLevel,
    );
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds:
      800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
      
      // Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSaved ? 'Saved to your profile!' : 'Removed from saved items'),
          backgroundColor: _isSaved ? selectedColor : Colors.grey[800],
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Your Fitness Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? accentColor : Colors.white,
              size: 28,
            ),
            onPressed: _toggleSave,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [selectedColor, bgColor],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _recommendationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Creating your personalized plan...',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[300], size: 60),
                      SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    'No recommendations found.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              final data = snapshot.data!;
              return Stack(
                children: [
                  _buildRecommendationContent(data),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SaveButton(
                        isSaved: _isSaved,
                        onPressed: _toggleSave,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationContent(Map<String, dynamic> data) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 100.0),
          children: [
            // Summary Card
            _buildSummaryCard(data),
            SizedBox(height: 16),
            
            // Section Cards
            _buildAnimatedSectionCard('Results', data['Results'], Icons.analytics_outlined, 100),
            _buildAnimatedSectionCard('Exercise Recommendations', data['Exercise Recommendations'], Icons.fitness_center, 200),
            _buildAnimatedSectionCard('Nutrient Intake Recommendations', data['Nutrient Intake Recommendations (per day)'], Icons.restaurant_menu, 300),
            _buildDisclaimerCard(data['Disclaimer'], 400),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> data) {
    final userInputs = data['User Inputs'];
    if (userInputs == null) return SizedBox.shrink();
    
    return Card(
      elevation: 12,
      shadowColor: selectedColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
                    color: selectedColor,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: selectedColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${widget.age} years • ${widget.gender}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProfileStat(
                  '${widget.weight.toStringAsFixed(1)} kg',
                  'Weight',
                  Icons.monitor_weight_outlined,
                ),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildProfileStat(
                  '${widget.height.toStringAsFixed(1)} cm',
                  'Height',
                  Icons.height,
                ),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildProfileStat(
                  widget.activityLevel,
                  'Activity',
                  Icons.directions_run,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: unselectedColor),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSectionCard(String title, Map<String, dynamic>? sectionData, IconData icon, int delayMillis) {
    if (sectionData == null) return SizedBox.shrink();
    
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delayMillis)), 
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: snapshot.connectionState == ConnectionState.done 
                ? Offset.zero 
                : Offset(0, 0.1),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: selectedColor.withOpacity(0.2), width: 1),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: unselectedColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: accentColor, size: 24),
                        ),
                        SizedBox(width: 16),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[700], height: 30),
                    ...sectionData.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: unselectedColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.check, color: accentColor, size: 14),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${entry.value}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildDisclaimerCard(String? disclaimer, int delay) {
    if (disclaimer == null) return SizedBox.shrink();
    
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: delay)),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Card(
            color: unselectedColor.withOpacity(0.2),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: unselectedColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: accentColor, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      disclaimer,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

// Custom Save Button Widget
class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onPressed;
  final Color selectedColor;
  final Color unselectedColor;

  const SaveButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: selectedColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        splashColor: selectedColor.withOpacity(0.3),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: isSaved 
                ? [selectedColor, unselectedColor]
                : [unselectedColor.withOpacity(0.8), selectedColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: selectedColor.withOpacity(isSaved ? 0.4 : 0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSaved ? Icons.check_circle_outline : Icons.add_circle_outline,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                isSaved ? 'Saved to Profile' : 'Save this Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}