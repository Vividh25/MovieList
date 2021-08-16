import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication_service.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: [
            const Text("Welcome to Cinephile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100)),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Text(
              "Sign in with google to access our services",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
                hintText: "Email",
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(),
                hintText: "Password",
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<AuthenticationService>(context, listen: false);
                provider.googleLogin();
              },
              child: const Text("Sign In"),
            )
          ],
        ),
      ),
    );
  }
}
