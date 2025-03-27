import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class CoursesDashboardPage extends StatelessWidget {
  const CoursesDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses Dashboard',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 4,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Soft banner
                      Container(
                        width: double.infinity,
                        color: Colors.blue.shade50,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          localizations?.locale.languageCode == 'hi'
                              ? 'क्या आप पर्सनल सुझाव चाहते हैं? प्रश्नावली फिर से शुरू करें।'
                              : 'Not sure where to start? Resume questionnaire →',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Placeholder text
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          localizations?.locale.languageCode == 'hi'
                              ? 'आपके सुझाए गए कोर्स और उपलब्ध कोर्स यहाँ दिखेंगे।'
                              : 'Your recommended and available courses will appear here.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      const Spacer(),

                      // Browse All Courses button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/coursesList');
                          },
                          icon: const Icon(Icons.grid_view_rounded, color: Colors.white),
                          label: Text(
                            localizations?.locale.languageCode == 'hi'
                                ? 'सभी कोर्स ब्राउज़ करें'
                                : 'Browse All Courses',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
