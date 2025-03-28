import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class CoursesDashboardPage extends StatelessWidget {
  const CoursesDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Your Personalized Course Hub',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white, // ✅ Title color changed to white
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
                      // ✅ Soft gradient banner with clickable InkWell
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/questionnaire');
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text(
                            localizations?.locale.languageCode == 'hi'
                                ? 'क्या आप पर्सनल सुझाव चाहते हैं? प्रश्नावली फिर से शुरू करें।'
                                : 'Not sure where to start? Resume questionnaire →',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          localizations?.locale.languageCode == 'hi'
                              ? 'आपके सुझाए गए कोर्स और उपलब्ध कोर्स यहाँ दिखेंगे।'
                              : 'Your recommended and available courses will appear here.',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: SizedBox(
                          width: double.infinity,
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
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
