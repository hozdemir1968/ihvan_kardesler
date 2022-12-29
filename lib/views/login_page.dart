import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

enum Status { signin, signup }

Status type = Status.signin;

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginPage';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;
  bool _isLoading2 = false;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void loading2() {
    setState(() {
      _isLoading2 = !_isLoading2;
    });
  }

  void _switchType() {
    if (type == Status.signup) {
      setState(() {
        type = Status.signin;
      });
    } else {
      setState(() {
        type = Status.signup;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final auth = ref.watch(authServiceProvider);

            Future<void> onPressedFunction() async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (type == Status.signin) {
                loading();
                await auth.signinUser(_email.text, _password.text, context).whenComplete(
                      () => auth.authStateChange.listen(
                        (event) async {
                          if (event == null) {
                            loading();
                            return;
                          }
                        },
                      ),
                    );
              } else {
                loading();
                await auth
                    .signupUser(_name.text, _email.text, _password.text, context)
                    .whenComplete(
                      () => auth.authStateChange.listen(
                        (event) async {
                          if (event == null) {
                            loading();
                            return;
                          }
                        },
                      ),
                    );
              }
            }

            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'images/ozgurlogo.png',
                      height: size.width / 5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (type == Status.signup)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: _name,
                        autocorrect: true,
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'İsim',
                          hintStyle: TextStyle(color: Colors.black54),
                          icon: Icon(Icons.person_outlined, color: Colors.teal),
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Hatalı isim!';
                          }
                          return null;
                        },
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      controller: _email,
                      autocorrect: true,
                      enableSuggestions: true,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {},
                      decoration: const InputDecoration(
                        hintText: 'E-posta',
                        hintStyle: TextStyle(color: Colors.black54),
                        icon: Icon(Icons.email_outlined, color: Colors.teal),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Hatalı e-posta!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'Şifre çok kısa!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Şifre',
                        hintStyle: TextStyle(color: Colors.black54),
                        icon: Icon(Icons.lock_outlined, color: Colors.teal),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (type == Status.signup)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Şifre tekrar',
                          hintStyle: TextStyle(color: Colors.black54),
                          icon: Icon(Icons.lock_outlined, color: Colors.teal),
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                        ),
                        validator: type == Status.signup
                            ? (value) {
                                if (value != _password.text) {
                                  return 'Şifreler uyuşmuyor!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 32.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MaterialButton(
                            onPressed: onPressedFunction,
                            textColor: Colors.teal,
                            textTheme: ButtonTextTheme.primary,
                            minWidth: 100,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(color: Colors.teal),
                            ),
                            child: Text(
                              type == Status.signin ? 'Giriş Yap' : 'Kayıt Ol',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(flex: 1, child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: RichText(
                      text: TextSpan(
                        text:
                            type == Status.signin ? 'Hesabınız yok mu?   ' : 'Hesabınız var mı?   ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: type == Status.signin ? 'Kayıt Ol' : 'Giriş Yap',
                            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _switchType();
                              },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
