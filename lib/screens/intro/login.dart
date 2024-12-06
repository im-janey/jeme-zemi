import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home/app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User user = userCredential.user!;

      await _checkAndCreateUserDocument(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppPage()), // Ensure AppPage is your home page
      );
    }
  } catch (e) {
    print("Google Sign-In Error: $e");
  }
}

Future<void> signInAsGuest(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    User user = userCredential.user!;

    await _checkAndCreateUserDocument(user);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AppPage()), // Ensure AppPage is your home page
    );
  } catch (e) {
    print("Guest Sign-In Error: $e");
  }
}

Future<void> _checkAndCreateUserDocument(User user) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userDoc = await firestore.collection('users').doc(user.uid).get();

  if (!userDoc.exists) {
    String name = user.displayName ?? 'Anonymous';
    String email = user.email ?? 'No email provided';
    String statusMessage = 'I promise to take the test honestly before GOD.';

    if (user.isAnonymous) {
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'status_message': statusMessage,
        'cart': [],
      });
    } else {
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'status_message': statusMessage,
        'cart': [],
      });
    }
  } else {
    if (!userDoc.data()!.containsKey('cart')) {
      await firestore.collection('users').doc(user.uid).update({
        'cart': [],
      });
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 160.0),
            Column(
              children: <Widget>[
                Image.asset('assets/logo.png'),
                const SizedBox(height: 35.0),
                const Text('Jeme Zemi',
                  style: TextStyle(
                    fontSize: 30.0,  // Adjust the size as needed
                    fontWeight: FontWeight.bold,  // Optional, to make the text bold
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                icon: const Icon(Icons.login),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => signInAsGuest(context),
                icon: const Icon(Icons.person),
                label: const Text(
                  "Sign in as Guest",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
