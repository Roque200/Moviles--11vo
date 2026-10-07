import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Usuario',
        border: OutlineInputBorder(),
      ),
    );
    final txtPassword = TextFormField(
      obscureText: true,
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
      onPressed: () {
        isLoading = !isLoading;
        setState(() {});
        Future.delayed(Duration(seconds: 4), () {
          isLoading = !isLoading;
          setState(() {});
        }).then((value) => Navigator.pushNamed(context, '/dash'));
        // Acción al presionar el botón de inicio de sesión
      },

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.login),
          SizedBox(width: 8),
          Text('Iniciar Sesión'),
        ],
      ),
    );

    final spacer = Container(height: 5);
    final spacer2 = SizedBox(height: 8);

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
              height: 200,
              width: MediaQuery.of(context).size.width * 0.7,
              bottom: 130,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    txtUser,
                    Divider(height: 10, color: Colors.transparent),
                    txtPassword,
                    Divider(height: 10, color: Colors.transparent),
                    btnLogin,
                  ],
                ),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            isLoading ? loading : Container(),
          ],
        ),
      ),
    );
  }
}
