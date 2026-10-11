import 'package:flutter/material.dart';
import 'package:moviles/services/email_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailAuth = EmailAuth();

  final conName = TextEditingController();
  final conEmail = TextEditingController();
  final conPassword = TextEditingController();
  final conConfirm = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    conName.dispose();
    conEmail.dispose();
    conPassword.dispose();
    conConfirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final error = await _emailAuth.signUp(
      email: conEmail.text.trim(),
      password: conPassword.text,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (error == null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registro exitoso'),
          content: Text(
            'Te enviamos un correo de verificación a ${conEmail.text.trim()}. '
            'Verifica tu cuenta antes de iniciar sesión.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtName = TextFormField(
      controller: conName,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        labelText: 'Nombre completo',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu nombre';
        }
        return null;
      },
    );

    final txtEmail = TextFormField(
      controller: conEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Correo electrónico',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu correo';
        }
        final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
        if (!regex.hasMatch(value.trim())) {
          return 'Correo no válido';
        }
        return null;
      },
    );

    final txtPassword = TextFormField(
      controller: conPassword,
      obscureText: hidePassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => hidePassword = !hidePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa una contraseña';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );

    final txtConfirm = TextFormField(
      controller: conConfirm,
      obscureText: hideConfirm,
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(hideConfirm ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => hideConfirm = !hideConfirm),
        ),
      ),
      validator: (value) {
        if (value != conPassword.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );

    final btnRegister = ElevatedButton(
      onPressed: isLoading ? null : _register,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_add),
                SizedBox(width: 8),
                Text('Registrarse'),
              ],
            ),
    );

    final btnBack = TextButton(
      onPressed: isLoading ? null : () => Navigator.pop(context),
      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
    );

    const spacer = SizedBox(height: 10);

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset('assets/araña.png', height: 150),
                  spacer,
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Crear cuenta',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          spacer,
                          txtName,
                          spacer,
                          txtEmail,
                          spacer,
                          txtPassword,
                          spacer,
                          txtConfirm,
                          spacer,
                          btnRegister,
                          btnBack,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
