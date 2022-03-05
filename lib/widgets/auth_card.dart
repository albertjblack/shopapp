import 'package:flutter/material.dart';

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

  void _submit() {
    // if cannot validate (err)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // save form state othwerwise
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // log user logic
    if (_authMode == AuthMode.login) {
      //
    }
    // sign up user logic
    else {
      //
    }

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
        height: _authMode == AuthMode.signup ? 360 : 300,
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
                  return '';
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
                          return "";
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
