import 'package:flutter/material.dart';

class DayDetailsPage extends StatelessWidget {
  final Map<String, String> dayPlan;
  final String destination;

  const DayDetailsPage({
    Key? key,
    required this.dayPlan,
    required this.destination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final rawContent = dayPlan['content'] ?? '';

    // Clean and normalize the content
    List<String> tempLines =
        rawContent
            .split('\n')
            .map((line) => line.trim())
            .map((line) {
              // Match variations like ### **Morning:** and normalize to Morning:
              final match = RegExp(
                r'^(#+\s*)?\*\*(Morning|Afternoon|Evening|Night|Dinner|Lunch)[^\w]?\*\*:?$',
              ).firstMatch(line);
              if (match != null) {
                return '${match.group(2)}:';
              }
              return line;
            })
            .where((line) => line.isNotEmpty)
            .toList();

    // Check if this is Day 1 by title
    final isDay1 = (dayPlan['title'] ?? '').toLowerCase().contains('day 1');

    if (isDay1) {
      final firstTimeSegmentIndex = tempLines.indexWhere(
        (line) => line.endsWith(':'),
      );
      if (firstTimeSegmentIndex != -1) {
        tempLines = tempLines.sublist(firstTimeSegmentIndex);
      } else {
        tempLines.insert(0, 'Morning:');
      }
    } else {
      if (tempLines.isEmpty || !tempLines.first.endsWith(':')) {
        tempLines.insert(0, 'Morning:');
      }
    }

    final lines = tempLines;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dayPlan['title'] ?? 'Day Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF93A5CF), Color(0xFFE4EFE9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Destination image
            Stack(
              children: [
                Image.network(
                  "https://source.unsplash.com/800x400/?$destination",
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: screenHeight * 0.25,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text(
                            'Image not available',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                dayPlan['title'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Plan details
            Expanded(
              child:
                  lines.isNotEmpty
                      ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: lines.length,
                        itemBuilder: (context, index) {
                          final line = lines[index];
                          final isTimeSegment = line.endsWith(':');

                          if (isTimeSegment) {
                            final headingText = line.substring(
                              0,
                              line.length - 1,
                            );
                            return Container(
                              margin: const EdgeInsets.only(top: 16, bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.3),
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.black54,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    headingText.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                bottom: 6,
                              ),
                              child: Text.rich(_buildFormattedTextSpan(line)),
                            );
                          }
                        },
                      )
                      : const Center(
                        child: Text(
                          'No activities found for this day.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan _buildFormattedTextSpan(String line) {
    final boldItalicPattern = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*)');
    final spans = <TextSpan>[];

    // Step 1: Check for a header line
    bool isHeader = false;
    if (line.trim().startsWith('###')) {
      isHeader = true;
      line = line.replaceFirst('###', '').trim(); // remove the header marker
    }

    int currentIndex = 0;
    for (final match in boldItalicPattern.allMatches(line)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: line.substring(currentIndex, match.start),
            style: TextStyle(
              fontSize: isHeader ? 18 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Georgia',
              color: Colors.black87,
            ),
          ),
        );
      }

      final matchedText = match.group(0)!;
      TextStyle matchedStyle = TextStyle(
        fontSize: isHeader ? 18 : 16,
        fontFamily: 'Georgia',
        color: Colors.black87,
      );

      if (matchedText.startsWith('**') && matchedText.endsWith('**')) {
        matchedStyle = matchedStyle.copyWith(fontWeight: FontWeight.bold);
        spans.add(
          TextSpan(
            text: matchedText.substring(2, matchedText.length - 2),
            style: matchedStyle,
          ),
        );
      } else if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
        matchedStyle = matchedStyle.copyWith(fontStyle: FontStyle.italic);
        spans.add(
          TextSpan(
            text: matchedText.substring(1, matchedText.length - 1),
            style: matchedStyle,
          ),
        );
      }

      currentIndex = match.end;
    }

    // Add any trailing text
    if (currentIndex < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(currentIndex),
          style: TextStyle(
            fontSize: isHeader ? 18 : 16,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Georgia',
            color: Colors.black87,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
