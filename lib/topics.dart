import 'package:flutter/material.dart';

class Topic2 extends StatelessWidget {
  const Topic2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitter-like Dialog Box'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => TopicSelectionDialog(),
            );
          },
          child: Text('Select Topics'),
        ),
      ),
    );
  }
}

class TopicSelectionDialog extends StatefulWidget {
  @override
  _TopicSelectionDialogState createState() => _TopicSelectionDialogState();
}

class _TopicSelectionDialogState extends State<TopicSelectionDialog> {
  // List of topics
  final List<String> topics = [
    'Technology',
    'Science',
    'Health',
    'Sports',
    'Entertainment',
    'Business',
    'Politics',
    'Education',
    'Environment',
    "Current Affairs",
    "Economy",
    "Geopolitics"
  ];

  // List to store selected topics
  List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: 800), // Set max height for the dialog
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Topics of Interest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedTopics.contains(topics[index]);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTopics.remove(topics[index]);
                        } else {
                          selectedTopics.add(topics[index]);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green
                            : Colors.white, // Conditional background color
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(
                            10), // Optional: to add rounded corners
                      ),
                      padding: const EdgeInsets.all(
                          16.0), // Optional: Add padding inside the container
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.check : Icons.add,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          SizedBox(width: 10), // Space between icon and text
                          Text(
                            topics[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors
                                      .black, // Change text color when selected
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Close the dialog and return the selected topics
                Navigator.of(context).pop(selectedTopics);
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
