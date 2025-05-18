import 'package:flutter/material.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/screens/lesson_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = course["title"] ?? "Course Title";
    final IconData icon = course["icon"] ?? Icons.info_outline;
    final Color color = course["color"] ?? Colors.blue;
    final String description = course["description"] ?? "No description available.";
    final String tag = course["tag"] ?? kFreeCourseTag;
    final List lessons = course["lessons"] ?? [];

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryBlue, kSecondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // ---------- Course Name Card ----------
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Icon in the center top
                      Hero(
                        tag: title,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: color.withOpacity(0.1),
                          child: Icon(
                            icon,
                            color: color,
                            size: 26,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Premium or Free tag below the icon
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tag == "free" ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag == "free" ? "FREE" : "PREMIUM",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Course Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Star rating row (optional)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star_half, color: Colors.amber, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ---------- Detailed Course Overview Card ----------
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detailed Course Overview",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Full description
                      Text(
                        description +
                            "\n\n"
                            "This course offers an in-depth exploration of the subject matter, "
                            "including structured lessons, engaging activities, and interactive "
                            "practice sessions to solidify your learning. Whether you're starting "
                            "from scratch or building upon existing knowledge, this program aims "
                            "to boost your confidence, improve your skills, and help you achieve "
                            "mastery over key concepts.\n\n"
                            "By the end of this course, you will:\n"
                            "• Grasp critical fundamentals and advanced techniques\n"
                            "• Gain real-world insights and practical strategies\n"
                            "• Collaborate with mentors and peers in a supportive environment\n"
                            "• Be prepared to apply these skills in daily life or professional settings\n",
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // "Start Now" / "Unlock Premium" button at bottom
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          onPressed: () {
                            // Navigate to lessons page if lessons available
                            if (lessons.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LessonPage(
                                    courseTitle: title,
                                    courseIcon: icon,
                                    courseColor: color,
                                    lessons: List<Map<String, dynamic>>.from(lessons),
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                          ).copyWith(
                            side: MaterialStateProperty.all(BorderSide.none),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF43A047), // Darker green
                                  Color(0xFF2E7D32), // Lighter green
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Text(
                                tag == kPaidCourseTag ? "Unlock Premium" : "Start Now",
                                style: const TextStyle(
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 3,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
