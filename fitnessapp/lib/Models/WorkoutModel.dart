class Workoutmodel {
  String? title;
  String? description;
  List<Exercises>? exercises;
  int? duration;
  String? difficulty;
  String? sId;
  String? createdAt;

  Workoutmodel(
      {this.title,
      this.description,
      this.exercises,
      this.duration,
      this.difficulty,
      this.sId,
      this.createdAt});

  Workoutmodel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['exercises'] != null) {
      exercises = <Exercises>[];
      json['exercises'].forEach((v) {
        exercises!.add(Exercises.fromJson(v));
      });
    }
    duration = json['duration'];
    difficulty = json['difficulty'];
    sId = json['_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (exercises != null) {
      data['exercises'] = exercises!.map((v) => v.toJson()).toList();
    }
    data['duration'] = duration;
    data['difficulty'] = difficulty;
    // data['_id'] = this.sId;
    data['createdAt'] = createdAt;
    return data;
  }
}

class Exercises {
  String? name;
  int? sets;
  int? reps;
  int? duration;
  String? sId;

  Exercises({this.name, this.sets, this.reps, this.duration, this.sId});

  Exercises.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sets = json['sets'];
    reps = json['reps'];
    duration = json['duration'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['sets'] = sets;
    data['reps'] = reps;
    data['duration'] = duration;
    // data['_id'] = this.sId;
    return data;
  }
}
