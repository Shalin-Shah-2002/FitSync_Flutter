class ExersiceModel {
  String? name;
  String? type;
  String? muscle;
  String? equipment;
  String? difficulty;
  String? instructions;

  ExersiceModel(
      {this.name,
      this.type,
      this.muscle,
      this.equipment,
      this.difficulty,
      this.instructions});

  ExersiceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    muscle = json['muscle'];
    equipment = json['equipment'];
    difficulty = json['difficulty'];
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['muscle'] = muscle;
    data['equipment'] = equipment;
    data['difficulty'] = difficulty;
    data['instructions'] = instructions;
    return data;
  }
}
