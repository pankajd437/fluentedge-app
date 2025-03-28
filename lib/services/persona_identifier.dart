class PersonaIdentifier {
  /// Returns a persona string based on user inputs
  static String getPersona({
    required String motivation,
    required String englishLevel,
    required String learningStyle,
    required String difficultyArea,
    required int age,
    required String gender,
  }) {
    // If the user is under 18
    if (age < 18) {
      return "Young Beginner Explorer";
    }

    // Match based on motivation
    if (motivation == "Career growth") {
      return "Career-Oriented Professional";
    }

    if (motivation == "Personal growth" && englishLevel == "Beginner") {
      return "Adult Fluency Seeker";
    }

    // Learning Style Focus
    if (learningStyle == "Visual" && difficultyArea == "Grammar") {
      return "Grammar-Focused Learner";
    }

    if (learningStyle == "Listening" && difficultyArea == "Pronunciation") {
      return "Adult Fluency Seeker";
    }

    // Specific personas based on gender and interest
    if (gender == "Female" && motivation == "Daily life") {
      return "Home Learner (Homemaker)";
    }

    if (motivation == "Spiritual exploration") {
      return "Spiritual Explorer";
    }

    if (motivation == "Medical or Teaching") {
      return "Medical or Teaching Professional";
    }

    if (englishLevel == "Advanced" && difficultyArea == "Fluency") {
      return "Advanced Fluency Achiever";
    }

    // Default fallback
    return "Adult Fluency Seeker";
  }
}
