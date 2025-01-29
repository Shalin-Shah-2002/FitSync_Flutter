import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Exersice_Model.dart';
import 'package:fitnessapp/Services/API/Exersice_Api.dart';
import 'package:provider/provider.dart';

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

class _ExerciseSearchListState extends State<ExerciseSearchList> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
@override
  void initState() {
    super.initState();
    widget.query.isNotEmpty ? _searchController.text = widget.query : null;
    // if (widget.query.isNotEmpty) {
    //   final ExerciseProvider = Provider.of<ExersiceService>(context);
    //   ExerciseProvider.getExersicesApi(widget.query);
    // }
    print("Widget initialized");
  }
  @override
  Widget build(BuildContext context) {
    final ExerciseProvider = Provider.of<ExersiceService>(context);
    return Scaffold(
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
            const SizedBox(height: 50),
            // Enhanced Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.selectedColor.withOpacity(_isSearchFocused ? 0.15 : 0.1),
                            widget.unselectedColor.withOpacity(_isSearchFocused ? 0.15 : 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isSearchFocused 
                              ? widget.selectedColor.withOpacity(0.5)
                              : widget.selectedColor.withOpacity(0.3),
                          width: _isSearchFocused ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.selectedColor.withOpacity(0.1),
                            blurRadius: _isSearchFocused ? 12 : 4,
                            offset: const Offset(0, 4),
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
                            prefixIcon: Icon(
                              Icons.search,
                              color: widget.selectedColor.withOpacity(_isSearchFocused ? 0.8 : 0.5),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: widget.selectedColor.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      ExerciseProvider.getExersicesApi('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Enhanced Search Button
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.selectedColor, widget.unselectedColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: widget.selectedColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            ExerciseProvider.getExersicesApi(query);
                          }
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: const Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Enhanced Exercise List
            Expanded(
              child: ExerciseProvider.exersices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 80,
                            color: widget.selectedColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No exercises found',
                            style: TextStyle(
                              color: widget.selectedColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching for different exercises',
                            style: TextStyle(
                              color: widget.selectedColor.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: ExerciseProvider.exersices.length,
                      itemBuilder: (context, index) {
                        final exercise = ExerciseProvider.exersices[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.selectedColor.withOpacity(0.1),
                                widget.unselectedColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.selectedColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                // Handle exercise selection
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            widget.selectedColor.withOpacity(0.2),
                                            widget.unselectedColor.withOpacity(0.2),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.fitness_center,
                                        color: widget.selectedColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercise.name ?? '',
                                            style: TextStyle(
                                              color: widget.selectedColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            exercise.type ?? '',
                                            style: TextStyle(
                                              color: widget.selectedColor.withOpacity(0.6),
                                              fontSize: 14,
                                            ),
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
                                        borderRadius: BorderRadius.circular(20),
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}