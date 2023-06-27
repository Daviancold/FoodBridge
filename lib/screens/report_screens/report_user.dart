import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportUser extends StatefulWidget {
  const ReportUser({
    super.key,
    required this.userName,
    required this.userId,
  });

  final String userName;
  final String userId;
  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  final _formKey = GlobalKey<FormState>();
  List<String> selectedReasons = [];
  var _description;
  bool _isSaving = false;

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (selectedReasons.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one reason.')),
        );
      } else {
        setState(() {
          _isSaving = true;
        });
        _formKey.currentState!.save();
        // Perform report submission logic here
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userId = user.email;

          // Create a new document in the 'report users' collection with the user's ID as the document title
          final reportRef = FirebaseFirestore.instance
              .collection('report users')
              .doc(widget.userId);

          // Generate a unique report ID
          final reportId = reportRef.collection('reports').doc().id;

          // Create a new report document in the 'reports' subcollection
          final reportData = {
            'reportedBy': user.email,
            'userReportedUserName': widget.userName,
            'userReportedUserEmail': widget.userId,
            'reportId': reportId,
            'reasons': selectedReasons,
            'description': _description,
            // Add any other fields you want to include in the report
          };
          await reportRef.collection('reports').doc(reportId).set(reportData);
          setState(() {
            _isSaving = false;
          });
          Navigator.pop(context);
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully.')),
          );
          print('Form is valid and at least one checkbox is selected');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report ${widget.userName}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reason for Report',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Inappropriate content'),
                value: selectedReasons.contains('inappropriate_content'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedReasons.add('inappropriate_content');
                    } else {
                      selectedReasons.remove('inappropriate_content');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Harassment'),
                value: selectedReasons.contains('harassment'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedReasons.add('harassment');
                    } else {
                      selectedReasons.remove('harassment');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Spam'),
                value: selectedReasons.contains('spam'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedReasons.add('spam');
                    } else {
                      selectedReasons.remove('spam');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Abuse platform'),
                value: selectedReasons.contains('Abuse platform'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedReasons.add('Abuse platform');
                    } else {
                      selectedReasons.remove('Abuse platform');
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                maxLength: 200,
                validator: (value) {
                  if (value == null ||
                      value.trim().length <= 1 ||
                      value.trim().length > 200) {
                    return 'Must be between 1 and 200 characters long';
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _isSaving ? null : _submitForm,
                    icon: _isSaving
                        ? const SizedBox(
                            height: 8,
                            width: 8,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.upload),
                    label: _isSaving
                        ? const Text('Submitting')
                        : const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}