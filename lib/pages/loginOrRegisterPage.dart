import 'package:battleships/api/auth.dart';
import 'package:battleships/helpers/constants.dart';
import 'package:battleships/helpers/sharedPreferences.dart';
import 'package:battleships/helpers/utils.dart';
import 'package:battleships/pages/homepage.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  static const String RouteName = "HomePage";
  LoginOrRegisterPage();

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Perform login action
                                _login();
                              }
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                            child: const Text('Register'),
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

  _login() async {
    try {
      setState(() {
        isLoading = true;
      });
      final AuthAPI authAPI = AuthAPI();
      final username = _usernameController.text;
      final password = _passwordController.text;

      final data = await authAPI.login(username, password);
      print(data);
      await _saveUserInfoToPrefs(data, username);
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, HomePage.RouteName);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      UtilService.showSnackBar(context, e.toString());
    }
  }

  _register() async {
    try {
      setState(() {
        isLoading = true;
      });
      final AuthAPI authAPI = AuthAPI();
      final username = _usernameController.text;
      final password = _passwordController.text;

      final data = await authAPI.register(username, password);
      await _saveUserInfoToPrefs(data, username);
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, HomePage.RouteName);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      UtilService.showSnackBar(context, e.toString());
    }
  }

  _saveUserInfoToPrefs(dynamic data, String username) async {
    final accessToken = data["access_token"];
    await SharedPreferencesService.addStringValueForKey(ACCESS_TOKEN, accessToken);
    await SharedPreferencesService.addStringValueForKey(USER_NAME, username);
  }
}
