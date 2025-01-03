import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  // Function to handle rating change
  void _onRatingChanged(int index) {
    setState(() {
      _rating = index + 1.0;
    });
  }

  // Function to save feedback to Firestore
  Future<void> _submitFeedback() async {
    if (_rating > 0 && _feedbackController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'rating': _rating,
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully!')),
        );
        _feedbackController.clear();
        setState(() {
          _rating = 0;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit feedback')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide rating and feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ganga.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How would you rate your experience?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < _rating ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () {
                      _onRatingChanged(index);
                    },
                  );
                }),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Leave your feedback here...',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black45,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
