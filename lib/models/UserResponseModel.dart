class UserResponseModel {
  final String name;
  final String motivation;
  final String englishLevel;
  final String learningStyle;
  final String difficultyArea;
  final String dailyTime;
  final String learningTimeline;

  UserResponseModel({
    required this.name,
    required this.motivation,
    required this.englishLevel,
    required this.learningStyle,
    required this.difficultyArea,
    required this.dailyTime,
    required this.learningTimeline,
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
    };
  }
}
