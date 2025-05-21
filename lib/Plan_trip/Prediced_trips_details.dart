import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'day_details_page.dart';
import 'box.dart'; // Your RoundedBox widget

class NextPage extends StatefulWidget {
  final List<String> interests;
  final String? tripType;
  final String? destination;
  final String? startDate;
  final String? endDate;

  const NextPage({
    required this.interests,
    required this.tripType,
    required this.destination,
    required this.startDate,
    required this.endDate,
    Key? key,
  }) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  bool loading = true;
  List<Map<String, String>> dayPlans = [];

  @override
  void initState() {
    super.initState();
    fetchTripPlanFromPerplexity();
  }

  Future<void> fetchTripPlanFromPerplexity() async {
    final interestsString = widget.interests.join(', ');
    final prompt = '''
Create a detailed itinerary for a ${widget.tripType} trip to ${widget.destination} from ${widget.startDate} to ${widget.endDate}. The traveler is interested in: $interestsString.

Provide a day-by-day plan that includes:
- Morning, Afternoon, and Evening sections for each day.
- Specific activity names, short descriptions, and relevant local tips.
- Dining recommendations for each day.
- Format the response clearly with day titles like 'Day 1: [Date] – [Title]'.
- Use headings like '**Morning:**', '**Afternoon:**', '**Evening:**' for each section.
- Ensure each item starts with a bullet point.
- Keep the tone practical, age-inclusive, and enjoyable for a group.

Return the itinerary in clean Markdown format."
''';

    final uri = Uri.parse("https://api.perplexity.ai/chat/completions");
    final headers = {
      "Authorization":
          "Bearer ", // Replace with your API key
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "model": "sonar",
      "search_context_size": "high",
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful and concise travel planner.",
        },
        {"role": "user", "content": prompt},
      ],
      "temperature": 0.7,
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final content = json['choices'][0]['message']['content'];
        setState(() {
          dayPlans = parseDays(content);
          print(dayPlans);
          loading = false;
        });
      } else {
        setState(() {
          dayPlans = [
            {
              "title": "Error",
              "content":
                  "Failed to fetch trip plan. Error: ${response.statusCode}",
            },
          ];
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        dayPlans = [
          {"title": "Error", "content": "Error: $e"},
        ];
        loading = false;
      });
    }
  }

  List<Map<String, String>> parseDays(String content) {
    final lines = content.split('\n');
    List<Map<String, String>> days = [];
    String currentTitle = "";
    StringBuffer buffer = StringBuffer();

    final dayRegex = RegExp(
      r'^\s*#{0,3}\s*Day\s*\d+[:\-]?',
      caseSensitive: false,
    );

    for (var line in lines) {
      if (dayRegex.hasMatch(line.trim())) {
        // Save previous day if any
        if (currentTitle.isNotEmpty) {
          days.add({
            "title": currentTitle,
            "content": buffer.toString().trim(),
          });
          buffer.clear();
        }
        // Remove markdown hashes and whitespace from title
        currentTitle = line.trim().replaceAll(RegExp(r'^#{1,3}\s*'), '');
      } else {
        buffer.writeln(line);
      }
    }

    // Add the last day if exists
    if (currentTitle.isNotEmpty) {
      days.add({"title": currentTitle, "content": buffer.toString().trim()});
    }

    // If no days detected, fallback to whole content
    if (days.isEmpty) {
      days.add({"title": "Trip Plan", "content": content});
    }

    print("Parsed days:");
    for (var day in days) {
      print("Title: ${day['title']}");
      print("Content length: ${day['content']?.length}");
    }

    return days;
  }

  int calculateTripDays() {
    if (widget.startDate == null || widget.endDate == null) return 0;
    try {
      final start = DateTime.parse(widget.startDate!);
      final end = DateTime.parse(widget.endDate!);
      return end.difference(start).inDays + 1;
    } catch (e) {
      return 0;
    }
  }

  void copyToClipboard() {
    final fullText = dayPlans
        .map((d) => "${d['title']}\n${d['content']}")
        .join("\n\n");
    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Trip plan copied to clipboard")));
  }

  void shareTripPlan() {
    final fullText = dayPlans
        .map((d) => "${d['title']}\n${d['content']}")
        .join("\n\n");
    Share.share(fullText, subject: "Your Trip Plan");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Itinerary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: loading ? null : copyToClipboard,
            tooltip: "Copy Trip Plan",
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: loading ? null : shareTripPlan,
            tooltip: "Share Trip Plan",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF93A5CF), Color(0xFFE4EFE9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    // Top Image with Destination Name
                    Stack(
                      children: [
                        Image.network(
                          "https://source.unsplash.com/800x400/?${widget.destination}",
                          height: screenHeight * 0.25,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: screenHeight * 0.25,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('Image not available'),
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
                              widget.destination ?? "",
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

                    // Duration Text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${calculateTripDays()} day${calculateTripDays() > 1 ? 's' : ''} itinerary',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Day-wise Itinerary List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: calculateTripDays(),
                        itemBuilder: (context, index) {
                          final String expectedTitle = "Day ${index + 1}";
                          final matchedDay = dayPlans.firstWhere(
                            (day) {
                              final title = day['title']?.toLowerCase() ?? '';
                              final regex = RegExp(
                                r'day\s*' + (index + 1).toString(),
                                caseSensitive: false,
                              );
                              return regex.hasMatch(title);
                            },
                            orElse:
                                () => {
                                  "title": "Day ${index + 1}",
                                  "content":
                                      "Details not available for this day.",
                                },
                          );

                          // Extract only "Day X" from title to avoid overflow
                          final dayDateMatch =
                              RegExp(r'Day\s*\d+', caseSensitive: false)
                                  .firstMatch(matchedDay['title'] ?? '')
                                  ?.group(0) ??
                              expectedTitle;

                          return Column(
                            children: [
                              RoundedBox(
                                title: dayDateMatch,
                                icon: Icons.calendar_today,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DayDetailsPage(
                                            dayPlan: matchedDay,
                                            destination:
                                                widget.destination ?? '',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
