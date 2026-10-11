import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _txtUserController = TextEditingController();
  final _txtPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    if (isLoading) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _txtUserController.text.trim(),
        password: _txtPasswordController.text,
      );

      if (mounted) Navigator.pushReplacementNamed(context, '/dash');
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      final message = switch (error.code) {
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' => 'Correo o contraseña incorrectos',
        'invalid-email' => 'Ingresa un correo electrónico válido',
        'user-disabled' => 'Esta cuenta está deshabilitada',
        'too-many-requests' => 'Demasiados intentos. Inténtalo más tarde',
        _ => 'No se pudo iniciar sesión. Inténtalo de nuevo',
      };
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al iniciar sesión')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _txtUserController.dispose();
    _txtPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      controller: _txtUserController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu correo electrónico';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(),
      ),
    );

    final txtPassword = TextFormField(
      controller: _txtPasswordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu contraseña';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
    );

    final loading = Positioned(
      top: 350,
      child: CircularProgressIndicator(color: Colors.white.withOpacity(0.8)),
    );

    final btnLogin = ElevatedButton(
      onPressed: isLoading ? null : _login,
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.login),
                SizedBox(width: 8),
                Text('Iniciar Sesión'),
              ],
            ),
    );

    final btnRegister = TextButton(
      onPressed: () => Navigator.pushNamed(context, '/register'),
      child: const Text('¿No tienes cuenta? Regístrate'),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/spider-man-neon.jpg'),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/araña.png', height: 200),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.7,
              bottom: 100,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      txtUser,
                      const Divider(height: 10, color: Colors.transparent),
                      txtPassword,
                      const Divider(height: 10, color: Colors.transparent),
                      btnLogin,
                      btnRegister,
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading) loading,
          ],
        ),
      ),
    );
  }
}
