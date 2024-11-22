import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacementNamed(context, 'home');
            } else if (state is Unauthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Session expired. Please log in again.')),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/cg_logo.svg',
                    color: Colors.blue,

                    height: 175,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildLoginForm(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: 'juancamilomendezsanchez@unicesar.edu.co',
            onSaved: (value) => email = value!,
            validator: (value) =>
                value!.isEmpty ? 'Please enter an email' : null,
            decoration: _buildTextInputDecoration('Email'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: '4321dsa',
            onSaved: (value) => password = value!,
            validator: (value) =>
                value!.isEmpty ? 'Please enter a password' : null,
            obscureText: true,
            decoration: _buildTextInputDecoration('Password'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                context.read<AuthBloc>().add(LoginRequested(email, password));
              }
            },
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.white;
                }),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.blue;
                }),
                minimumSize:
                    const MaterialStatePropertyAll(Size(double.maxFinite, 50)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)))),
            child: const Text('Login'),
          ),
          const Flex(
            crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              direction: Axis.vertical,
              children: [
            Text('Campus Gate',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600))
          ]),
        ],
      ),
    );
  }

  InputDecoration _buildTextInputDecoration(String inputLabel) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0x50bdbdbd),
      contentPadding: const EdgeInsets.all(15),
      label: Text(inputLabel),
      floatingLabelStyle: const TextStyle(color: Colors.transparent),
      labelStyle: Theme.of(context).textTheme.titleSmall,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
    );
  }
}
