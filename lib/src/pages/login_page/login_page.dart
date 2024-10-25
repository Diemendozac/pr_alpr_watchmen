import 'package:flutter/material.dart';
import 'package:pr_alpr_watchmen/src/providers/token_provider.dart';
import 'package:pr_alpr_watchmen/src/utils/input_validator.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Flutter!",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  String email = "";
  String password = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TokenProvider tokenProvider = TokenProvider();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();

    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) => InputValidator.validateEmail(value),
              onSaved: (value) {
                email = value!;
              },
              initialValue: 'jramireza@unicesar.edu.co',
              decoration: _buildTextInputDecoration('Email'),
            ),
            _gap(),
            TextFormField(
              validator: (value) => InputValidator.validatePassword(value),
              initialValue: 'asd1234',
              onSaved: (value) {
                password = value!;
              },
              obscureText: !_isPasswordVisible,
              decoration: _buildTextInputDecoration('Password')
                  .copyWith(suffixIcon: _buildPasswordSuffixIcon()),
            ),
            _gap(),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    dynamic state = await tokenProvider.saveToken(
                        'juancamilomendezsanchez@unicesar.edu.co', '4321dsa');
                    if (state["statusCode"] == 200) authState.setLoggedIn(true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildTextInputDecoration(String inputLabel) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0x50bdbdbd),
      contentPadding: const EdgeInsets.all(20),
      label: Text(inputLabel),
      floatingLabelStyle: const TextStyle(color: Colors.transparent),
      labelStyle: Theme.of(context).textTheme.titleSmall,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(50)),
    );
  }

  IconButton _buildPasswordSuffixIcon() {
    return IconButton(
      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
