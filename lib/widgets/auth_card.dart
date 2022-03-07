import 'package:provider/provider.dart';
import './../providers/auth.dart';
import 'package:flutter/material.dart';
import './../models/http_exception.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };
  final _passwordController = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: [
                TextButton(
                    child: const Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  Future<void> _submit() async {
    // if cannot validate (err)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // save form state othwerwise
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // log user logic
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData["email"]!, _authData["password"]!);
      }
      // sign up user logic
      else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData["email"]!, _authData["password"]!);
      }
    } on HttpException catch (e) {
      var errorMessage = "Authentication failed.";
      if (e.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email address is already in use.";
      } else if (e.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This email is an invalid address.";
      } else if (e.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is not strong enough.";
      } else if (e.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "This email is not registered.";
      } else if (e.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Ivalid password.";
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = "Could not authenticate, please try again later.";
      _showErrorDialog(errorMessage);
      rethrow;
    }

    //
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white.withOpacity(0.95),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.signup ? 382 : 300,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.blueGrey,
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              TextFormField(
                cursorColor: Colors.blueGrey,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.signup)
                TextFormField(
                  enabled: _authMode == AuthMode.signup,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return "Passwords do not match!";
                          }
                          return null;
                        }
                      : null,
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  child: Text(
                    _authMode == AuthMode.login ? 'login' : 'sign up',
                  ),
                  onPressed: _submit,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      '${_authMode == AuthMode.login ? 'signup' : 'login'} ',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    onPressed: _toggleAuthMode,
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
