// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  User? _user;
  User? get user => _user;
  UserCredential? _userCredential;
  UserCredential? get userCredential => _userCredential;
  final String _email = "shadyelnady@gmail.com";
  // final String _emailAuth = 'someemail@domain.com';
  final String _password = "123456789";
  AuthController() {
    //
    _auth.authStateChanges().listen((User? user) {
      if (user != null && !user.emailVerified) {
        // user.sendEmailVerification();
        _user = user;
        print(
            'authStateChanges : User is signed in!\n UserCredential : $_userCredential');
      } else if (user != null && user.emailVerified) {
        print("authStateChanges : User Sign In And Email Verified \n $user");
      } else {
        print('authStateChanges : User is currently signed out! ');
      }
    });
    //
    // _auth.idTokenChanges().listen((User? user) {
    //   if (user != null && !user.emailVerified) {
    //     // user.sendEmailVerification();
    //     print('idTokenChanges :User is signed in!\n User : $user');
    //   } else {
    //     print('idTokenChanges : User is currently signed out! ');
    //   }
    // });
    // //
    // _auth.userChanges().listen((User? user) {
    //   if (user != null && !user.emailVerified) {
    //     // user.sendEmailVerification();
    //     print('userChanges : User is signed in!');
    //   } else {
    //     print('userChanges : User is currently signed out!');
    //   }
    // });
  }

  void signInAnonymous() async {
    try {
      _userCredential = await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print("Sign In Anonymous Catch Error : $e");
    }
  }

  void emailPasswordRegistration() async {
    try {
      _userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print("Sign In Email Catch Error : $e");
    }
  }

  void signInEmail() async {
    try {
      _userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      // if (_auth.isSignInWithEmailLink(_email)) {
      //   // The client SDK will parse the code from the link for you.
      //   _auth
      //       .signInWithEmailLink(email: _emailAuth, emailLink: _email)
      //       .then((value) {
      //     // You can access the new user via value.user
      //     // Additional user info profile *not* available via:
      //     // value.additionalUserInfo.profile == null
      //     // You can check if the user is new or existing:
      //     // value.additionalUserInfo.isNewUser;
      //     _user = value.user;
      //     print('Successfully signed in with email link!');
      //   }).catchError((onError) {
      //     print('Error signing in with email link $onError');
      //   });
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // Google_Sign_In
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _userCredential = await _auth.signInWithCredential(credential);
  }

  // FaceBook

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    _userCredential =
        _auth.signInWithCredential(facebookAuthCredential) as UserCredential;
  }

  // Sign Out
  void signOut() async {
    tryCatch(FirebaseAuth.instance.signOut());
    await _googleSignIn.signOut();
  }

  // Delete User
  void deleteUser() {
    tryCatch(_auth.currentUser!.delete());
  }
}

//TryCatch
Future<void> tryCatch(Future<void> fun) async {
  try {
    await fun;
    print("shady sgin Out");
  } on FirebaseAuthException catch (fireError) {
    print(
        "FireBase Exception on Function ${fun.toString()} Catch Error : $fireError");
  } catch (error) {
    print("On Function ${fun.toString()} Catch Error : $error");
  }
}
