class UserProfile {
  final String gender; // 'Male' or 'Female'
  final int weight; // in KG
  final int height; // in cm
  final int age; // in years

  UserProfile({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
  });

  double get dailyCalories {
    if (gender == 'Female') {
      return 655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
    } else {
      // Male
      return 666.47 + (13.75 * weight) + (5 * height) - (6.75 * age);
    }
  }
} 