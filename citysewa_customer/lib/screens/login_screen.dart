import "package:flutter/material.dart";

import "package:citysewa/services/pref_service.dart" show PrefService;
import "package:citysewa/api/api_services.dart" show AuthAPI;
import "package:citysewa/api/models.dart" show UserModel;
import 'package:citysewa/screens/signup_screen.dart' show SignupScreen;

const appIcon = "lib/assets/app_icon.png";

AuthAPI auth = AuthAPI();

class LoginScreen extends StatefulWidget {
  final VoidCallback afterLogin;
  LoginScreen({super.key, required this.afterLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbf0f9),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Logo(),
                WelcomeText(),
                LoginForm(afterLogin: widget.afterLogin),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont`t have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
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

class Logo extends StatelessWidget {
  Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: CircleAvatar(radius: 60, backgroundImage: AssetImage(appIcon)),
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
            Text("Welcome Back", style: TextStyle(fontSize: 20)),
            Text(
              "Login to continue",
              style: TextStyle(fontSize: 16, color: Color(0xff6e6a6a)),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final VoidCallback afterLogin;
  const LoginForm({super.key, required this.afterLogin});
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void login(String phoneNumber, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      UserModel user = await auth.login(phoneNumber, password);
      PrefService.setLoggedIn(true);
      PrefService.setUserFirstName(user.firstName);
      PrefService.setUserLastName(user.lastName);
      PrefService.setUserGender(user.gender);
      PrefService.setUserCategory(user.category);
      PrefService.setUserEmai(user.email);
      if (user.photoUrl != null) {
        PrefService.setUserPhoto(user.photoUrl!);
      }
      PrefService.setUserToken(user.token);
      widget.afterLogin();
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final passController = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              counterText: '',
              hintText: "Phone Number",
              fillColor: Color(0xfffffefe),
              hoverColor: Color(0xfffffefe),
              filled: true,
              prefixIcon: Icon(Icons.call_outlined),
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
          SizedBox(height: 20),
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {},
              child: const Text(
                "Forgot password?",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              onPressed: () {
                final phoneNumber = phoneController.text.toString().trim();
                final password = passController.text.toString().trim();
                if (phoneNumber.isNotEmpty && password.isNotEmpty) {
                  login(
                    phoneController.text.toString(),
                    passController.text.toString(),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Center(
                        child: Text(
                          "Ensure you entered correct credentials.",
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
