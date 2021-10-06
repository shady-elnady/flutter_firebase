import 'package:flutter/material.dart';
import 'package:flutter_firebase/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auth FireBase"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  AuthController().signInAnonymous();
                },
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.login),
                    Text("sign In Anonymous"),
                  ],
                ),
              ),
            ),
            //
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  AuthController().emailPasswordRegistration();
                },
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.login),
                    Text("email Password Registration"),
                  ],
                ),
              ),
            ),
            //
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  AuthController().signInEmail();
                },
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.login),
                    Text("sign In Email"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  AuthController().signOut();
                },
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.logout),
                    Text("sign Out"),
                  ],
                ),
              ),
            ),
            Text(
              "${AuthController().userCredential}",
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
