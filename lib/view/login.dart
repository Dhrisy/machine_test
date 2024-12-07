import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:machine_test/controller/auth_provider.dart';
import 'package:machine_test/view/navbar/navbar.dart';
import 'package:machine_test/services/login_service.dart';
import 'package:machine_test/utils/constants.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  String? _emailValidation(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }

    // email regex for validation
    const String emailValid =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    final RegExp regex = RegExp(emailValid);

    if (!regex.hasMatch(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextFormField(
                    controller: _emailController,
                    labelText: "Email",
                    theme: theme,
                    validation: _emailValidation),
                const SizedBox(
                  height: 20,
                ),
                _buildTextFormField(
                    controller: _pwController,
                    labelText: "Password",
                    theme: theme,
                    validation: (_) {
                      if (_pwController.text.trim().isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                Consumer<AuthProvider>(builder: (context, provider, child) {
                  return SizedBox(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, elevation: 2),
                        onPressed: () async {
                          _loginAction(provider);
                        },
                        child: provider.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Text(
                                "Login",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: Colors.white),
                              )),
                  );
                })
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _loginAction(AuthProvider provider) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_formKey.currentState!.validate()) {
      provider.setLoading(true);
      if (connectivityResult.contains(ConnectivityResult.none)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Oops! something went wrong. Check your internet connection")));
                 provider.setLoading(false);
      } else {
        final result = await LoginService.login(
            email: _emailController.text,
            password: _pwController.text,
            provider: provider);

        if (result == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(provider.loginError)));

          provider.setLoading(false);
          provider.setLoginError("");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Navbar()),
              (Route<dynamic> route) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(provider.loginError)));
          provider.setLoading(false);
          provider.setLoginError("");
        }
      }
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required ThemeData theme,
    String? Function(String?)? validation,
  }) {
    return TextFormField(
      controller: controller,
      validator: validation,
      decoration: InputDecoration(
        label: Text(labelText),
        labelStyle: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 212, 212, 212))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 212, 212, 212))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                BorderSide(color: const Color.fromARGB(255, 212, 212, 212))),
      ),
    );
  }
}
