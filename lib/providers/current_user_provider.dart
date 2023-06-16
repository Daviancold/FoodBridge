import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUser = Provider((ref) {
  return FirebaseAuth.instance.currentUser!;
});
