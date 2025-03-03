import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Exersice_Model.dart';
import 'package:fitnessapp/Services/API/Exersice_Api.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class ExerciseSearchList extends StatefulWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final String query;

  const ExerciseSearchList({
    Key? key,
    this.selectedColor = const Color(0xFF462749),
    this.unselectedColor = const Color(0xFF8332AC),
    this.query = '',
  }) : super(key: key);

  @override
  State<ExerciseSearchList> createState() => _ExerciseSearchListState();
}

class _ExerciseSearchListState extends State<ExerciseSearchList>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  late AnimationController _animationController;
  bool _isSearching = false;

  final List<String> _muscleIcons = [
    '💪',
    '🦵',
    '🫁',
    '🏋️',
    '🤸',
    '🧘',
    '🏃',
    '🚴'
  ];

  @override
  void initState() {
    super.initState();
    widget.query.isNotEmpty ? _searchController.text = widget.query : null;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    print("Widget initialized");
  }

  @override
  Widget build(BuildContext context) {
    final ExerciseProvider = Provider.of<ExersiceService>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Exercise Library',
          style: TextStyle(
            color: widget.selectedColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: widget.selectedColor,
            ),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.selectedColor.withOpacity(0.05),
              widget.unselectedColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Enhanced Search Bar with Animation
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.selectedColor
                                .withOpacity(_isSearchFocused ? 0.15 : 0.1),
                            widget.unselectedColor
                                .withOpacity(_isSearchFocused ? 0.15 : 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _isSearchFocused
                              ? widget.selectedColor.withOpacity(0.5)
                              : widget.selectedColor.withOpacity(0.3),
                          width: _isSearchFocused ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.selectedColor.withOpacity(0.15),
                            blurRadius: _isSearchFocused ? 15 : 5,
                            offset: const Offset(0, 4),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          setState(() => _isSearchFocused = hasFocus);
                        },
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: widget.selectedColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search exercises...',
                            hintStyle: TextStyle(
                              color: widget.selectedColor.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            prefixIcon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isSearching
                                  ? Container(
                                      key: const ValueKey('loading'),
                                      padding: const EdgeInsets.all(8),
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                widget.selectedColor),
                                      ),
                                    )
                                  : Icon(
                                      Icons.search,
                                      key: const ValueKey('search'),
                                      color: widget.selectedColor.withOpacity(
                                          _isSearchFocused ? 0.8 : 0.5),
                                    ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color:
                                          widget.selectedColor.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      ExerciseProvider.getExersicesApi('');
                                      setState(() {
                                        _isSearching = false;
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onSubmitted: (query) {
                            if (query.isNotEmpty) {
                              setState(() {
                                _isSearching = true;
                              });
                              ExerciseProvider.getExersicesApi(query).then((_) {
                                setState(() {
                                  _isSearching = false;
                                });
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Enhanced Search Button with Ripple Effect
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.selectedColor, widget.unselectedColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: widget.selectedColor.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            setState(() {
                              _isSearching = true;
                            });
                            ExerciseProvider.getExersicesApi(query).then((_) {
                              setState(() {
                                _isSearching = false;
                              });
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Popular Search Tags
            if (!_isSearchFocused && _searchController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Searches',
                      style: TextStyle(
                        color: widget.selectedColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSearchTag('Abs', widget.selectedColor,
                            widget.unselectedColor),
                        _buildSearchTag('Chest', widget.selectedColor,
                            widget.unselectedColor),
                        _buildSearchTag('Biceps', widget.selectedColor,
                            widget.unselectedColor),
                        _buildSearchTag('Legs', widget.selectedColor,
                            widget.unselectedColor),
                        _buildSearchTag('Cardio', widget.selectedColor,
                            widget.unselectedColor),
                        _buildSearchTag('Back', widget.selectedColor,
                            widget.unselectedColor),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Enhanced Exercise List with Animations
            Expanded(
              child: ExerciseProvider.exersices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Add a Lottie animation here
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: widget.selectedColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: widget.selectedColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No exercises found',
                            style: TextStyle(
                              color: widget.selectedColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Try searching for different exercises or check out our popular suggestions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.selectedColor.withOpacity(0.6),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.text = "push up";
                              });
                              ExerciseProvider.getExersicesApi("push up");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.selectedColor,
                             foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor:
                                  widget.selectedColor.withOpacity(0.5),
                            ),
                            child: const Text(
                              'Try Popular Exercises',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: ExerciseProvider.exersices.length,
                      itemBuilder: (context, index) {
                        final exercise = ExerciseProvider.exersices[index];
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.selectedColor.withOpacity(0.1),
                                  widget.unselectedColor.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.selectedColor.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.selectedColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  _showExerciseDetails(context, exercise);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: 'exercise-icon-${exercise.name}',
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                widget.selectedColor
                                                    .withOpacity(0.3),
                                                widget.unselectedColor
                                                    .withOpacity(0.3),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: widget.selectedColor
                                                    .withOpacity(0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              _getMuscleEmoji(
                                                  exercise.muscle ?? ''),
                                              style: const TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise.name ?? '',
                                              style: TextStyle(
                                                color: widget.selectedColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.category,
                                                  size: 14,
                                                  color: widget.selectedColor
                                                      .withOpacity(0.6),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  exercise.type ?? '',
                                                  style: TextStyle(
                                                    color: widget.selectedColor
                                                        .withOpacity(0.6),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                _buildDifficultyIndicator(
                                                    exercise.difficulty ??
                                                        'beginner',
                                                    widget.selectedColor),
                                                const SizedBox(width: 8),
                                                _buildEquipmentTag(
                                                    exercise.equipment ??
                                                        'none',
                                                    widget.unselectedColor),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              widget.selectedColor,
                                              widget.unselectedColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: widget.selectedColor
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          exercise.muscle ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
    );
  }

  // Helper widget for search tags
  Widget _buildSearchTag(String tag, Color backgroundColorColor, Color secondaryColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = tag;
          _isSearching = true;
        });
        Provider.of<ExersiceService>(context, listen: false)
            .getExersicesApi(tag)
            .then((_) {
          setState(() {
            _isSearching = false;
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColorColor.withOpacity(0.2),
              secondaryColor.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: backgroundColorColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: backgroundColorColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Helper widget for difficulty indicator
  Widget _buildDifficultyIndicator(String difficulty, Color color) {
    int difficultyLevel = 1;
    if (difficulty.toLowerCase() == "intermediate") {
      difficultyLevel = 2;
    } else if (difficulty.toLowerCase() == "expert") {
      difficultyLevel = 3;
    }

    return Row(
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < difficultyLevel ? color : color.withOpacity(0.2),
          ),
        );
      }),
    );
  }

  // Helper widget for equipment tag
  Widget _buildEquipmentTag(String equipment, Color color) {
    IconData icon;
    if (equipment.toLowerCase().contains("barbell") ||
        equipment.toLowerCase().contains("dumbbell")) {
      icon = Icons.fitness_center;
    } else if (equipment.toLowerCase().contains("machine")) {
      icon = Icons.precision_manufacturing;
    } else if (equipment.toLowerCase().contains("band")) {
      icon = Icons.linear_scale;
    } else {
      icon = Icons.accessibility_new;
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color.withOpacity(0.7),
        ),
        const SizedBox(width: 4),
        Text(
          equipment,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Method to get emoji based on muscle
  String _getMuscleEmoji(String muscle) {
    muscle = muscle.toLowerCase();
    if (muscle.contains('chest')) return '🫁';
    if (muscle.contains('biceps') || muscle.contains('arm')) return '💪';
    if (muscle.contains('leg') ||
        muscle.contains('quad') ||
        muscle.contains('hamstring')) return '🦵';
    if (muscle.contains('abs') || muscle.contains('core')) return '🏋️';
    if (muscle.contains('back') || muscle.contains('lat')) return '🤸';
    if (muscle.contains('shoulder')) return '🧘';
    if (muscle.contains('cardio')) return '🏃';
    if (muscle.contains('glute')) return '🚴';

    // Return a random emoji if no match
    return _muscleIcons[muscle.hashCode % _muscleIcons.length];
  }

  // Method to show filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.selectedColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Filter Exercises',
              style: TextStyle(
                color: widget.selectedColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Filter content would go here
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection('Muscle Group', [
                        'All',
                        'Chest',
                        'Back',
                        'Arms',
                        'Shoulders',
                        'Legs',
                        'Abs',
                        'Cardio'
                      ]),
                      const SizedBox(height: 20),
                      _buildFilterSection('Equipment', [
                        'All',
                        'Bodyweight',
                        'Dumbbells',
                        'Barbell',
                        'Machines',
                        'Cables',
                        'Kettlebells'
                      ]),
                      const SizedBox(height: 20),
                      _buildFilterSection('Difficulty',
                          ['All', 'Beginner', 'Intermediate', 'Advanced']),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.selectedColor,
                        side: BorderSide(color: widget.selectedColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.selectedColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build filter sections
  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: widget.selectedColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) => _buildFilterChip(option)).toList(),
        ),
      ],
    );
  }

  // Helper method to build filter chips
  Widget _buildFilterChip(String label) {
    final bool isSelected = label == 'All';
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Would handle selection logic here
      },
      backgroundColor: Colors.grey.withOpacity(0.1),
      selectedColor: widget.selectedColor.withOpacity(0.2),
      checkmarkColor: widget.selectedColor,
      labelStyle: TextStyle(
        color: isSelected ? widget.selectedColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? widget.selectedColor : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }

  // Method to show exercise details
  void _showExerciseDetails(BuildContext context, ExersiceModel exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.selectedColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Hero(
                    tag: 'exercise-icon-${exercise.name}',
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.selectedColor.withOpacity(0.3),
                            widget.unselectedColor.withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _getMuscleEmoji(exercise.muscle ?? ''),
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name ?? '',
                          style: TextStyle(
                            color: widget.selectedColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.selectedColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                exercise.muscle ?? '',
                                style: TextStyle(
                                  color: widget.selectedColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.unselectedColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                exercise.type ?? '',
                                style: TextStyle(
                                  color: widget.unselectedColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise Details
                      _buildDetailSection('Equipment',
                          exercise.equipment ?? 'None', Icons.fitness_center),
                      _buildDetailSection('Difficulty',
                          exercise.difficulty ?? 'Beginner', Icons.equalizer),
                      _buildDetailSection(
                          'Type', exercise.type ?? '', Icons.category),

                      const SizedBox(height: 20),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          color: widget.selectedColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.selectedColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.selectedColor.withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          exercise.instructions ?? 'No instructions available.',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Muscle Activation Diagram (Placeholder)
                      Text(
                        'Muscle Activation',
                        style: TextStyle(
                          color: widget.selectedColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.selectedColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.selectedColor.withOpacity(0.1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Muscle diagram would go here',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Similar Exercises
                      Text(
                        'Similar Exercises',
                        style: TextStyle(
                          color: widget.selectedColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: widget.selectedColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: widget.selectedColor.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _muscleIcons[index % _muscleIcons.length],
                                    style: const TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Similar Exercise ${index + 1}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: widget.selectedColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.favorite_border),
                      label: Text('Save'),
                      onPressed: () {
                        // Save exercise to favorites
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.selectedColor,
                        side: BorderSide(color: widget.selectedColor),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add to Workout'),
                      onPressed: () {
                        // Add to workout logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.selectedColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail sections
  Widget _buildDetailSection(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.selectedColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: widget.selectedColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
