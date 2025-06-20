import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/mountains.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSignupSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successful! Please log in.')));
                    Navigator.pushReplacementNamed(context, '/login');
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('assets/image/trek_logo.png', height: 60),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.check_circle, color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.check_circle, color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text("Remember me"),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthCubit>().signup(
                            _usernameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        child: state is AuthLoading ? CircularProgressIndicator() : const Text("Sign up"),
                      ),
                      const SizedBox(height: 10),
                      const Center(child: Text("Already have an account?")),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text("Login here"),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
