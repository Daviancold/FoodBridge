import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RateDonorScreen extends StatefulWidget {
  const RateDonorScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.listingId,
  }) : super(key: key);

  final String userId;
  final String userName;
  final String listingId;

  @override
  State<RateDonorScreen> createState() => _RateDonorScreenState();
}

class _RateDonorScreenState extends State<RateDonorScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _rating1 = 0;
  int _rating2 = 0;
  int _rating3 = 0;
  String _review = '';

  void _submitRating() {
    if (_formKey.currentState!.validate()) {
      if (_rating1 <= 0 || _rating2 <= 0 || _rating3 <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please rate all 3 categories.')),
        );
      } else {
        // Form fields are valid, perform submission
        // You can use the '_rating' and '_review' variables here
        double _avgRating = (_rating1 + _rating2 + _rating3) / 3;
        String userId = widget.userId;

        // Store the rating and review data in Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('reviews')
            .add({
          'avgRating': _avgRating,
          'friendlinessRating': _rating1,
          'easeOfDealRating': _rating2,
          'sincerityRating': _rating3,
          'review': _review,
          'reviewedBy': user!.email,
        });

        FirebaseFirestore.instance
            .collection('Listings')
            .doc(widget.listingId)
            .update({
          'isDonorReviewed': true
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate: ${widget.userName}',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Friendliness: '),
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating1 = i;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 20,
                        color: i <= _rating1 ? Colors.yellow : Colors.grey,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ease of deal: '),
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating2 = i;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 20,
                        color: i <= _rating2 ? Colors.yellow : Colors.grey,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sincerity: '),
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating3 = i;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 20,
                        color: i <= _rating3 ? Colors.yellow : Colors.grey,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _review = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Write your review',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitRating,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
