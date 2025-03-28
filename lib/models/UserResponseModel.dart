class UserResponseModel {
  final String name;
  final String motivation;
  final String englishLevel;
  final String learningStyle;
  final String difficultyArea;
  final String dailyTime;
  final String learningTimeline;
  final int age;  // Added age field
  final String gender;  // Added gender field

  UserResponseModel({
    required this.name,
    required this.motivation,
    required this.englishLevel,
    required this.learningStyle,
    required this.difficultyArea,
    required this.dailyTime,
    required this.learningTimeline,
    required this.age,  // Add age to the constructor
    required this.gender,  // Add gender to the constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'motivation': motivation,
      'english_level': englishLevel,
      'learning_style': learningStyle,
      'difficulty_area': difficultyArea,
      'daily_time': dailyTime,
      'learning_timeline': learningTimeline,
      'age': age,  // Include age in the JSON map
      'gender': gender,  // Include gender in the JSON map
    };
  }
}
