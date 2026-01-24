import "package:flutter/material.dart";

import "package:citysewa_provider/widgets/widgets.dart" show AppLogo;
import "package:citysewa_provider/api/api.dart" show AuthService;

AuthService auth = AuthService();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbf0f9),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(),
                WelcomeText(),
                SignupForm(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Text("Become a part of the family", style: TextStyle(fontSize: 20)),
            Text(
              "Services at your home",
              style: TextStyle(fontSize: 16, color: Color(0xff6e6a6a)),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void signUp(
    String fisrtName,
    String lastName,
    String email,
    String password,
  ) async {
    setState(() => isLoading = true);

    try {
      final result = await auth.register(fisrtName, lastName, email, password);
      print("result: $result");
    } catch (e) {
      print(e);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: firstNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "First name",
              fillColor: Color(0xfffffefe),
              prefixIcon: Icon(Icons.abc_rounded),
              hoverColor: Color(0xfffffefe),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: lastNameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Last name",
              fillColor: Color(0xfffffefe),
              hoverColor: Color(0xfffffefe),
              filled: true,
              prefixIcon: Icon(Icons.abc),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,

            decoration: InputDecoration(
              hintText: "Email",
              fillColor: Color(0xfffffefe),
              hoverColor: Color(0xfffffefe),
              filled: true,
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              fillColor: Color(0xfffffefe),
              hoverColor: Color(0xfffffefe),
              filled: true,
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              onPressed: () {
                final String firstName = firstNameController.text
                    .toString()
                    .trim();
                final String lastName = lastNameController.text
                    .toString()
                    .trim();
                final String email = emailController.text.toString().trim();
                final String password = passController.text.toString().trim();
                if (email.isNotEmpty &&
                    password.isNotEmpty &&
                    firstName.isNotEmpty &&
                    lastName.isNotEmpty) {
                  signUp(firstName, lastName, email, password);
                } else {
                  String msg = "Please ensure that you filed form correctly.";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Center(
                        child: Text(
                          msg,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
