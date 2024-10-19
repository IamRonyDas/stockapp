import 'package:flutter/material.dart';

class Topics extends StatelessWidget {
  const Topics({super.key});

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
  ];

  // List to store selected topics
  List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
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
                shrinkWrap: true,
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      color: selectedTopics.contains(topics[index])
                          ? Colors.green
                          : Colors.white, // Conditional background color
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(
                          10), // Optional: to add rounded corners
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        topics[index],
                        style: TextStyle(
                          color: selectedTopics.contains(topics[index])
                              ? Colors.white
                              : Colors.black, // Change text color when selected
                        ),
                      ),
                      value: selectedTopics.contains(topics[index]),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedTopics.add(topics[index]);
                          } else {
                            selectedTopics.remove(topics[index]);
                          }
                        });
                      },
                      activeColor: Colors
                          .white, // Ensure the checkbox matches the text color when selected
                      checkColor: Colors
                          .green, // Set the checkbox tick color when selected
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
