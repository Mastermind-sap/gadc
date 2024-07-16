import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGoogle() async {
  try {
    // Start the sign-in process
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // User cancelled the sign-in process
      return null;
    }

    // Obtain the authentication details
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with the credential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Return the signed-in user
    return userCredential.user;
  } catch (e) {
    // Handle any errors
    print("Error during Google sign-in: $e");
    return null;
  }
}

String getUserName() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.displayName ?? "None";
}

String getUserImageUrl() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.photoURL ?? "None";
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print("Error signing out: $e");
  }
}

String getUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.email ?? "None";
}
