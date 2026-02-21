import "package:flutter/material.dart";

import 'package:citysewa_provider/api/api.dart' show AuthService;
import "package:citysewa_provider/widgets/widgets.dart" show AppLogo;

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppLogo(size: 50),
                    SizedBox(height: 10),
                    InstructionText(),
                    SizedBox(height: 20),
                    OTPForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          children: [
            Text("Please verify your email", style: TextStyle(fontSize: 16)),
            Text(
              "OTP will be sent to your email",
              style: TextStyle(fontSize: 14, color: Color(0xff6e6a6a)),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPForm extends StatefulWidget {
  const OTPForm({super.key});

  @override
  State<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  bool sendingOTP = false;
  bool verifyingOTP = false;
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final auth = AuthService();

  Future sendOTP() async {
    setState(() {
      sendingOTP = true;
    });
    final email = emailController.text.toString();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("Please make sure you entered your email address."),
          ),
        ),
      );
    } else {
      try {
        final response = await auth.sendOTP(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: response.success
                ? Colors.green
                : Colors.deepOrange,
            content: Center(child: Text(response.message)),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("Something went wrong. Please try again."),
            ),
          ),
        );
      }
    }
    setState(() {
      sendingOTP = false;
    });
  }

  Future verifyOTP() async {
    setState(() {
      verifyingOTP = true;
    });

    final email = emailController.text.toString();
    final otp = otpController.text.toString();

    if (email.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("Both email and otp are required for verification."),
          ),
        ),
      );
    } else {
      int? integerOTP = int.tryParse(otp);
      if (integerOTP == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("Please ensure you entered correct otp."),
            ),
          ),
        );
      } else {
        try {
          final response = await auth.verifyOTP(email, integerOTP);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: response.success
                  ? Colors.green
                  : Colors.deepOrange,
              content: Center(child: Text(response.message)),
            ),
          );

          if (response.success) {
            Navigator.pushReplacementNamed(
              context,
              '/register',
              arguments: {"email": email},
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text("Something went wrong. Please try again."),
              ),
            ),
          );
        }
      }
    }
    setState(() {
      verifyingOTP = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 150,
            child: FilledButton.icon(
              onPressed: () {
                sendOTP();
              },
              label: sendingOTP
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Text("Send OTP", style: TextStyle(fontSize: 16)),
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "OTP",
                    prefixIcon: Icon(Icons.key_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: FilledButton.icon(
                  onPressed: () {
                    verifyOTP();
                  },
                  label: verifyingOTP
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text("Verify OTP", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
